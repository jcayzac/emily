package io.github.jcayzac.emily

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.github.jcayzac.emily.channels.Channels
import io.github.jcayzac.emily.channels.IntentsChannel
import io.github.jcayzac.emily.channels.PhoneChannel

class MainActivity: FlutterActivity() {
  private var channels: Channels? = null

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    // (Re)register our channels
    channels = Channels(
      this,
      flutterEngine.dartExecutor,
      PhoneChannel::class.java,
      IntentsChannel::class.java
    )
  }
}
