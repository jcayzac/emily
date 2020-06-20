part of languages;

class JapaneseLocalization extends Language {
  const JapaneseLocalization();

  @override
  get appTitle => 'えみり';

  @override
  get permissionRequestTitle => '何かが機能していない…';

  @override
  get contactPermissionRequest => '''お子様の情報を読み込むには、
次の画面で、「連絡先」の「許可」を選択します。''';

  @override
  get smsPermissionRequest => '''お子様の携帯電話との通信を有効するには、
次の画面で「SMS」の「許可」を選択して下さい。''';

  @override
  get phonePermissionRequest => '''お子様の携帯電話との通信を有効するには、
次の画面で「電話」の「許可」を選択して下さい。''';

  @override
  get openAppSettings => '了解です！';

  @override
  get pickSimCard => 'SIMカードを選択してください：';

  @override
  get pickContact => '連絡先選択';

  @override
  get requestLocationLog => 'どこ行ったのか？';

  @override
  get requestMostRecentLocation => '今はどこ？';

  @override
  get switchContinuousTrackingOn => '連続測位 ON';

  @override
  get switchContinuousTrackingOff => '連続測位 OFF';

  @override
  get startChat => 'チャット開始';

  @override
  get triggerAlarm => '鳴動音を鳴らす';
}
