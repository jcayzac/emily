library languages;

import '../strings.dart';

part 'en.dart';
part 'ja.dart';
part 'language.dart';

/// Supported languages index
final languages = {
  'en': () => EnglishLocalization(),
  'ja': () => JapaneseLocalization(),
};
