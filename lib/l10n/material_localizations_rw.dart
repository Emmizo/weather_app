import 'package:flutter/material.dart';

class MaterialLocalizationsRw extends DefaultMaterialLocalizations {
  const MaterialLocalizationsRw();

  static const LocalizationsDelegate<MaterialLocalizations> delegate =
      _MaterialLocalizationsRwDelegate();

  // Custom Kinyarwanda translations
  @override
  String get okButtonLabel => 'Yego';
  @override
  String get cancelButtonLabel => 'Hagarika';
  @override
  String get closeButtonLabel => 'Funga';
  @override
  String get backButtonTooltip => 'Subira inyuma';
  @override
  String get nextMonthTooltip => 'Ukwezi gukurikira';
  @override
  String get previousMonthTooltip => 'Ukwezi kwabanje';

  // Add other custom translations here.
  // The rest will automatically fall back to English.
}

class _MaterialLocalizationsRwDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _MaterialLocalizationsRwDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'rw';

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      const MaterialLocalizationsRw();

  @override
  bool shouldReload(_MaterialLocalizationsRwDelegate old) => false;
}
