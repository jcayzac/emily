part of languages;

/// Abstract language. The current language is available at
/// [Language.current].
abstract class Language implements Strings {
  static Language current;
  const Language();
}
