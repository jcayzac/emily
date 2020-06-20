package io.github.jcayzac.emily.channels

import android.content.Context
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.serialization.SerializationStrategy
import kotlinx.serialization.builtins.serializer
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonConfiguration
import kotlin.reflect.full.findAnnotation
import kotlin.reflect.full.memberFunctions

private val json = Json(JsonConfiguration.Stable)

/**
 * Simple annotation for mapping a [Channel]'s method to a
 * route.
 */
@Target(AnnotationTarget.FUNCTION)
annotation class Route(val path: String)

/**
 * Wraps a [MethodChannel.Result] into an invocable object that takes
 * care of encoding things to JSON.
 */
class Callback(private val result: MethodChannel.Result) {
  /**
   * Generic operator.
   */
  operator fun <T>invoke(value: T, serializer: SerializationStrategy<T>) {
    result.success(json.stringify(serializer, value))
  }

  /**
   * Shortcut for void methods (returns `true` to the Dart side).
   */
  operator fun invoke() {
    result.success("true")
  }

  /**
   * Shortcut for methods that return strings.
   */
  operator fun invoke(value: String) {
    result.success(json.stringify(String.serializer(), value))
  }
}

/**
 * Base class for channels.
 */
open class Channel(protected val context: Context, name: String) : CoroutineScope by CoroutineScope(Dispatchers.IO) {
  private val identifier = "local-channel:$name"

  /**
   * Expose the channel to Dart.
   */
  fun install(executor: DartExecutor) = also {
    val cls = this::class
    MethodChannel(
      executor.binaryMessenger,
      identifier
    ).setMethodCallHandler { call, result ->

      // Find which method of the channel maps to the requested method.
      @Suppress("UNCHECKED_CAST")
      val callable = cls.memberFunctions.find { function ->
        function.findAnnotation<Route>()?.let {
          if (it.path == call.method) return@find true
        }

        false
      } ?: throw NotImplementedError()

      // Gather method arguments
      @Suppress("UNCHECKED_CAST")
      val arguments = call.arguments as? Map<String, Any> ?: emptyMap()

      // Invoke the method
      callable.call(this, arguments, Callback(result))
    }
  }
}

/**
 * A factory, installer and container for channels. It instantiates and exposes channels
 * to Dart automatically, and keeps a strong reference to each channel for as long as it
 * lives.
 */
class Channels(context: Context, executor: DartExecutor, vararg types: Class<out Channel>) {
  private var channels = ArrayList<Channel>()

  init {
    for (type in types) {
      val channel = type.constructors.first().newInstance(context) as Channel
      channels.add(channel.install(executor))
    }
  }
}
