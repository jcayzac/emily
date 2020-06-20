library permissions;

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../channels/channels.dart';
import '../localization/localization.dart';

part 'contacts.dart';
part 'phone.dart';
part 'sms.dart';

/// Handles requesting permissions
class Permissions {
  final BuildContext context;
  final IntentsChannel intentsChannel;

  const Permissions(this.context, this.intentsChannel);

  Future<bool> _checkRequestPermission(
      Permission permission, String rationale) async {
    final request = await permission.request();
    if (!request.isGranted && !request.isDenied)
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            AppLocalizations.of(context).permissionRequestTitle,
          ),
          content: Text(
            rationale,
          ),
          actions: [
            FlatButton(
              child: Text(
                AppLocalizations.of(context).openAppSettings,
                style: Theme.of(context).textTheme.button.copyWith(
                      fontSize: 16.0,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await intentsChannel.openAppSettings();
              },
            ),
          ],
        ),
      );

    return request.isGranted;
  }
}
