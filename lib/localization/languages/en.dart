part of languages;

class EnglishLocalization extends Language {
  const EnglishLocalization();

  @override
  get appTitle => 'Emily';

  @override
  get permissionRequestTitle => 'Uh oh…';

  @override
  get contactPermissionRequest =>
      '''The app cannot load your kid's information unless you grant it the "Contacts" permission on the next screen.''';

  @override
  get smsPermissionRequest =>
      '''The app cannot communicate with your kid's phone unless you grant it the "SMS" permission on the next screen.''';

  @override
  get phonePermissionRequest =>
      '''The app cannot communicate with your kid's phone unless you grant it the "Phone" permission on the next screen.''';

  @override
  get openAppSettings => 'Understood!';

  @override
  get pickSimCard => 'Which SIM card do you want to use?';

  @override
  get pickContact => 'Contact Selection';

  @override
  get requestLocationLog => 'Request Location Log';

  @override
  get requestMostRecentLocation => 'Request Most Recent Location';

  @override
  get switchContinuousTrackingOn => 'Enable Continuous Tracking';

  @override
  get switchContinuousTrackingOff => 'Disable Continuous Tracking';

  @override
  get startChat => 'Start Chat';

  @override
  get triggerAlarm => 'Set Off Alarm';
}
