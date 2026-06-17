import 'package:get_it/get_it.dart';

import 'package:nmc_wrapper/utils/secure.storage.dart';
import 'package:nmc_wrapper/view/shared/models/city.model.dart';
import 'package:nmc_wrapper/view/shared/models/grievance.type.model.dart';
import 'package:nmc_wrapper/view/shared/models/localization.model.dart';


final getIt = GetIt.instance;

class RegistrationRequest {
  Map<String, dynamic>? data;
}

void setupLocator() {
  getIt.registerSingleton<RegistrationRequest>(
    RegistrationRequest(),
  );
  getIt.registerSingleton<SecureStorage>(
    SecureStorage(),
  );
  getIt.registerSingleton<MasterDataStore>(
    MasterDataStore(),
  );

 /* getIt.registerSingleton<LanguageService>(
    LanguageService(),
  );*/
}

class MasterDataStore {
  List<ServiceDef> serviceDefs = [];

  // Add this
  List<CityModule> cityModules = [];



  String? getServiceDesc(String code) {
    return serviceDefs
        .where((e) => e.serviceCode == code)
        .first
        .name;
  }

  String? getDepartmentName(String code) {
    return serviceDefs
        .where((e) => e.department == code)
        .first
        .menuPath;
  }

  CityModule? getModuleByCode(String code) {
    try {
      return cityModules.firstWhere((e) => e.code == code);
    } catch (_) {
      return null;
    }
  }


  List<LocalizationMessage> localizations = [];

  final Map<String, String> localizationMap = {};

  void setLocalizations(List<LocalizationMessage> data) {
    localizations = data;

    localizationMap.clear();

    for (final item in data) {
      localizationMap[item.code.trim()] = item.message;
    }
  }

  String getLocalizedText(String code) {
    return localizationMap[code.trim()] ?? code;
  }

}
