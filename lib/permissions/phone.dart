part of permissions;

extension Phone on Permissions {
  get phone => _checkRequestPermission(
      Permission.phone, AppLocalizations.of(context).phonePermissionRequest);
}
