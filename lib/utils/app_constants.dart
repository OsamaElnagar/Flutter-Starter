import '../models/language_model.dart';
import 'images.dart';

class AppConstants {
  static const String appVersion = '1.0';
  static const String baseUrl = 'http://mv-store.test';
  static const String apiUrl = "$baseUrl/api/";
  static const String emulatorApiUrl =
      "https://46okceks5y.sharedwithexpose.com/api/";
  /*
   Expose service, just run [expose share http://mv-store.test] and get the share link.
   */
  static const String products = 'products';
  static const String categories = 'categories';
  static const String categorySelection = 'category-select';
  static const String login = 'auth/login';
  static const String registerVendor = 'auth/register-vendor';
  static const String register = 'auth/register';
  static const String logout = 'auth/logout';
  static const String forgotPassword = 'auth/forgot-password';
  static const String configUri = '/api/v1/customer/config';
  static const String storeReview = "/reviews/store";
  //SharedPreferences keys
  static const String guestId = 'guest_id';
  static const String theme = 'mv_theme';
  static const String token = 'token';
  static const String zoneId = 'zoneId';
  static const String localizationKey = 'x-localization';
  static const String appApiKey = 'x-api-key';
  static const String appApiValue =
      'base64:5Xc2tvX35I8olTe/Z2Ap7g2xTpYvb2KvepmLzVihUqk=';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String cartList = 'cart_list';
  static const String acceptCookies = 'accept_cookies';
  static const String userPassword = 'user_password';
  static const String userAddress = 'user_address';
  static const String userNumber = 'user_number';
  static const String userCountryCode = 'user_country_code';
  static const String notification = 'notification';
  static const String searchHistory = 'search_history';
  static const String notificationCount = 'notification_count';
  static const String isSplashSeen = 'splash_seen';
  static const String cookiesManagement = 'cookies_management';
  static const String changeLanguage = 'change-language';

  static Map<String, String> configHeader = {
    'Content-Type': 'application/json; charset=UTF-8',
    AppConstants.zoneId: 'configuration',
  };
  static List<LanguageModel> languages = [
    LanguageModel(
      imageUrl: Images.us,
      languageName: 'English',
      countryCode: 'US',
      languageCode: 'en',
    ),
    LanguageModel(
      imageUrl: Images.ar,
      languageName: 'عربى',
      countryCode: 'SA',
      languageCode: 'ar',
    ),
  ];
}

class PaymentConfig {
  static const String paymobApiKey =
      'ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TWpReE1qQXpMQ0p1WVcxbElqb2lhVzVwZEdsaGJDSjkuYnpHZk9rQTFvMzdVTHpxZ3lWaUctNnlOSXNvZ2RmeVJ5S1Z6dzRYc1lYcHNGc2EwY0tNNWY3d3N5MURoZnlSbHFVVGZ2bFVvN1FueWxDRUhvdk5rQmc=';
  static const int paymobCardIntegrationId = 2397670;
  static const int paymobWalletIntegrationId = 4890459;
  static const int paymobKioskIntegrationId = 123456; // replace
  static const int paymobIframeId = 430046;
}
