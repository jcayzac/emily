part of permissions;

extension Contacts on Permissions {
  get contacts => _checkRequestPermission(Permission.contacts,
      AppLocalizations.of(context).contactPermissionRequest);
}
