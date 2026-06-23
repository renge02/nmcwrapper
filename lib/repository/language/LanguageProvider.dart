import 'package:flutter/material.dart';
import 'package:nmc_wrapper/repository/registerRepo/service.locator.dart';
import 'package:nmc_wrapper/utils/secure.storage.dart';

class LanguageProvider extends ChangeNotifier {

  Locale _locale = const Locale('en');

  Locale get locale => _locale;


  Future<void> loadLanguage() async {

    String? language = await getIt<SecureStorage>()
            .getLanguage();

    _locale = Locale(language ?? 'en');

    notifyListeners();

  }


  Future<void> changeLanguage(String code) async {

    _locale = Locale(code);

    await getIt<SecureStorage>()
        .saveLanguage(code);

    notifyListeners();

  }

}