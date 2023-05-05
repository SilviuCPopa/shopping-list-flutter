import 'dart:ui';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Currencies { usd, euro, ron }

class Settings {
  Locale locale;
  Currencies currency;

  Settings(this.locale, this.currency);
}

class SettingsService {
  final String _localeKey = 'locale_key';
  final String _currencyKey = 'currencty_key';
  Stream<Locale> get currentLocale => _localeSuject.stream.distinct();
  Stream<Currencies> get currentCurrency => _curencySuject.stream.distinct();
  Stream<Settings> get currentSettings =>
      Rx.combineLatest2(currentLocale, currentCurrency,
          (Locale locale, Currencies currency) {
        return Settings(locale, currency);
      });

  final _localeSuject = BehaviorSubject<Locale>();
  final _curencySuject = BehaviorSubject<Currencies>();
  String locale = 'en';
  Currencies currency;

  static final SettingsService _singleton = SettingsService._internal();
  factory SettingsService() {
    return _singleton;
  }
  SettingsService._internal();

  init() {
    setDefaultLocale();
  }

  setDefaultLocale() async {
    locale = await getLocale();
  }

  updateLocale(locale) async {
    _localeSuject.sink.add(new Locale(locale));
    this.locale = locale;
    await setLocale(locale);
  }

  updateCurrency(currency) async {
    _curencySuject.add(currency);
    this.currency = currency;
    await setCurrecnty(currency);
  }

  setLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_localeKey, locale);
  }

  setCurrecnty(Currencies currency) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_currencyKey, currency.toString());
  }

  Future<String> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_localeKey);
  }

  Future<Currencies> getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    String prefValue = prefs.getString(_currencyKey);
    return getCurrencyValue(prefValue);
  }

  getCurrencyValue(String prefValue) {
    switch (prefValue) {
      case 'Currencies.euro':
        return Currencies.euro;
      case 'Currencies.usd':
        return Currencies.usd;
      case 'Currencies.ron':
        return Currencies.ron;
    }
  }

  dispose() {
    _localeSuject.close();
  }
}
