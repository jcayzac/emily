import 'dart:convert';

import 'package:flutter/services.dart';

/// Base class for our channels.
class BaseChannel extends MethodChannel {
  const BaseChannel(String name) : super("local-channel:$name");

  /// Native methods return JSON objects.
  dynamic parse(Future<String> json) async =>
      const JsonCodec().decode(await json);
}
