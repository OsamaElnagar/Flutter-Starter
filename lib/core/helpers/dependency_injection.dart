import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:starter/controllers/theme_controller.dart';
import 'package:starter/services/api_client.dart';
import 'package:starter/services/local_client.dart';
import 'package:starter/features/authentication/model/signin_response_model.dart';
import 'package:starter/features/authentication/service/user_hive_service.dart';
import 'package:starter/features/splash/controller/splash_controller.dart';
import 'package:starter/features/splash/repository/splash_repo.dart';
import 'package:starter/models/language_model.dart';
import 'package:starter/services/payments/payment_service_interface.dart';
import 'package:starter/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/payments/paymob_service.dart';

class DependencyInjection {
  ///The following methods will be called before GetMaterialApp.
  ///IT is responsible for loading some dependencies before the app starts.
  static Future<void> initialize() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.put(sharedPreferences, permanent: true);

    final userBox = await Hive.openBox<UserResponse>('userBox');

    Get.put(UserHiveService(userBox), permanent: true);

    Get.put(
      ApiClient(
        appBaseUrl: GetPlatform.isAndroid || GetPlatform.isMobile
            ? AppConstants.emulatorApiUrl
            : AppConstants.apiUrl,
        sharedPreferences: Get.find(),
      ),
      permanent: true,
    );
    Get.put(
      HiveStorage(),
      permanent: true,
    );

    Get.put<PaymentServiceInterface>(
      PaymobService()..initialize(),
      permanent: true,
    );

    Get.lazyPut(
      () => SplashController(
        splashRepo: SplashRepo(
          apiClient: Get.find<ApiClient>(),
          sharedPreferences: Get.find<SharedPreferences>(),
        ),
        userHiveService: Get.find<UserHiveService>(),
      ),
    );

    Get.lazyPut(() =>
        ThemeController(sharedPreferences: Get.find<SharedPreferences>()));
  }

  static Future<Map<String, Map<String, String>>> initializeLanguages() async {
    Map<String, Map<String, String>> languages = {};
    for (LanguageModel languageModel in AppConstants.languages) {
      String jsonStringValues = await rootBundle
          .loadString('assets/language/${languageModel.languageCode}.json');
      Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
      Map<String, String> jsonValue = {};
      mappedJson.forEach((key, value) {
        jsonValue[key] = value.toString();
      });
      languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
          jsonValue;
    }
    return languages;
  }
}
