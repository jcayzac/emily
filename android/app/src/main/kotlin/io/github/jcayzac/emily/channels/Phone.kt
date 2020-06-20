package io.github.jcayzac.emily.channels

import android.annotation.SuppressLint
import android.content.Context
import android.telephony.SmsManager
import android.telephony.SubscriptionManager
import android.telephony.TelephonyManager
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.builtins.list
import java.lang.IllegalArgumentException

@Serializable
data class SimInfo(
  @SerialName("slot") val slot: Int,
  @SerialName("subscription") val subscription: Int,
  @SerialName("name") val name: String,
  @SerialName("number") val number: String
)

class PhoneChannel(context: Context): Channel(context, "phone") {
  private val phone = context.getSystemService(Context.TELEPHONY_SERVICE) as? TelephonyManager
  private val subscriptions = context.getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as? SubscriptionManager

  @Route("simCards")
  fun simCards(args: Map<String, Any>, complete: Callback) {
    val cards = ArrayList<SimInfo>()
    for (index in 0..10) {
      if (phone?.getSimState(index) != TelephonyManager.SIM_STATE_READY) continue
      @SuppressLint("MissingPermission")
      val info = subscriptions?.getActiveSubscriptionInfoForSimSlotIndex(index) ?: continue

      cards.add(SimInfo(
        slot = index,
        subscription = info.subscriptionId,
        name = info.displayName.toString(),
        number = info.number
      ))
    }

    complete(cards, SimInfo.serializer().list)
  }

  @Route("sendTextMessage")
  fun sendTextMessage(args: Map<String, Any>, complete: Callback) = launch {
    val number = args["number"] as? String ?: throw IllegalArgumentException("Missing number")
    val body = args["body"] as? String ?: throw IllegalArgumentException("Missing body")
    val subscription = args["subscription"] as? Int

    val service =
      if (subscription == null) SmsManager.getDefault()
      else SmsManager.getSmsManagerForSubscriptionId(subscription)

    service.sendTextMessage(number, null, body, null, null)

    launch(Dispatchers.Main) {
      complete()
    }
  }
}
