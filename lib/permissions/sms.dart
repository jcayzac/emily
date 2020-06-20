part of permissions;

extension Sms on Permissions {
  get sms => _checkRequestPermission(
      Permission.sms, AppLocalizations.of(context).smsPermissionRequest);
}
