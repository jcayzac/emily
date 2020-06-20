part of channels;

/// Everything we know about a SIM card
class SimCard {
  final String number;
  final String name;
  final int subscription;
  final int slot;

  const SimCard({this.number, this.name, this.subscription, this.slot});
}

/// Encapsulate everything we need from telephony services
class PhoneChannel extends BaseChannel {
  const PhoneChannel() : super('phone');

  /// Get information about all the available SIM cards
  Future<List<SimCard>> simCards() async {
    final raw = await parse(invokeMethod('simCards')) as List<dynamic>;
    final converted = raw
        .map((e) => SimCard(
            number: e['number'],
            name: e['name'],
            subscription: e['subscription'],
            slot: e['slot']))
        .toList();
    return converted;
  }

  /// Send a text-only SMS to a number
  sendTextMessage(String number, String body, int subscription) =>
      parse(invokeMethod("sendTextMessage", {
        "number": number,
        "body": body,
        "subscription": subscription,
      }));
}
