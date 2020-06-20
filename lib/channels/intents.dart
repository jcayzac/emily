part of channels;

/// Encapsulates Android intent stuff.
class IntentsChannel extends BaseChannel {
  const IntentsChannel() : super('intents');

  /// Start an activity.
  launch({String action, String uri, List<int> flags, List<int> categories}) =>
      parse(invokeMethod("launch", {
        "action": action,
        "uri": uri,
        "flags": flags,
        "categories": categories,
      }));

  /// Start composing a message.
  startComposingMessage(String number) => parse(invokeMethod("smsComposer", {
        "number": number,
      }));

  /// Open app settings.
  openAppSettings() => parse(invokeMethod("appSettings"));
}
