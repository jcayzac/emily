package io.github.jcayzac.emily.channels

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.Settings

class IntentsChannel(context: Context): Channel(context, "intents") {
  @Route("launch")
  fun launch(args: Map<String, Any>, complete: Callback) {
    context.startActivity(Intent(args["action"] as? String ?: Intent.ACTION_VIEW).apply {
      val uri = args["uri"] as? String
      uri?.let { setData(Uri.parse(uri)) }

      @Suppress("UNCHECKED_CAST")
      (args["categories"] as? List<String>)?.forEach { addCategory(it) }

      @Suppress("UNCHECKED_CAST")
      (args["flags"] as? List<Int>)?.forEach { addFlags(it) }
    })

    complete()
  }

  @Route("smsComposer")
  fun smsComposer(args: Map<String, Any>, complete: Callback) {
    val number = args["number"] as? String ?: throw IllegalArgumentException("Missing 'number' argument")

    launch(mapOf(
      "uri" to "sms:$number",
      "flags" to listOf(Intent.FLAG_ACTIVITY_NEW_TASK)
    ), complete)
  }

  @Route("appSettings")
  fun appSettings(args: Map<String, Any>, complete: Callback) {
    launch(mapOf(
      "action" to Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
      "uri" to "package:${context.applicationContext.packageName}",
      "categories" to listOf(Intent.CATEGORY_DEFAULT),
      "flags" to listOf(
        Intent.FLAG_ACTIVITY_NEW_TASK,
        Intent.FLAG_ACTIVITY_NO_HISTORY,
        Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS
      )
    ), complete)
  }
}