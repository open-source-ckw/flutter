import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Util/Utils.dart';
import 'demo_localization.dart';

const String LAGUAGE_CODE = 'languageCode';

//languages code
const String ENGLISH = 'en';
const String GUJARATI = 'gu';
const String FRENCH = 'fr';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LAGUAGE_CODE) ?? "en";
  if (languageCode == 'en') {
    UtilsUrl.currentLanguage = "en";
  } else if (languageCode == 'gu') {
    UtilsUrl.currentLanguage = "gu";
  } else {
    UtilsUrl.currentLanguage = 'fr';
  }
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case ENGLISH:
      return Locale(ENGLISH, 'US');
    case GUJARATI:
      return Locale(GUJARATI, "IN");
    case FRENCH:
      return Locale(FRENCH, "FR");
    default:
      return Locale(ENGLISH, 'US');
  }
}

String? getTranslated(BuildContext context, String key) {
  return DemoLocalization.of(context)!.translate(key);
}
