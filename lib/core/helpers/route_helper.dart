import 'dart:convert';

import 'package:get/get.dart';
import 'package:starter/features/authentication/view/register_page.dart';
import 'package:starter/features/authentication/view/sign_in_page.dart';
import 'package:starter/models/notification_body.dart';

import '../../bindings/initial_binding.dart';
import '../../features/initial/view/initial_page.dart';
import '../../features/payment/controllers/payment_controller.dart';
import '../../features/payment/views/payment_test_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String dashboard = '/dashboard';
  static const String register = '/register';
  static const String signIn = '/sign-in';
  static const String main = '/main';
  static const String products = '/products';
  static const String addProduct = '/add-product';
  static const String editProduct = '/edit-product';
  static const String draftProducts = '/draft-products';
  static const String sendOtpScreen = '/send-otp';
  static const String verification = '/verification';
  static const String changePassword = '/change-password';
  static const String update = '/update';
  static const String chatScreen = '/chat-screen';
  static const String chatInbox = '/chat-inbox';
  static const String onBoardScreen = '/onBoardScreen';
  static const String settingScreen = '/settingScreen';
  static const String languageScreen = '/language-screen';
  static const String html = '/html';
  static const String paymentTest = '/payment-test';
  static String getSplashRoute(NotificationBody? body) {
    String data = 'null';
    if (body != null) {
      List<int> encoded = utf8.encode(jsonEncode(body));
      data = base64Encode(encoded);
    }
    return '$splash?data=$data';
  }

  static String getInitialRoute() => initial;

  static String getSignInRoute(String page) => '$signIn?page=$page';

  static String getSignUpRoute() => register;

  static String getSendOtpScreen(String fromScreen) {
    return '$sendOtpScreen?fromPage=$fromScreen';
  }

  static String getVerificationRoute(
      String identity, String identityType, String fromPage) {
    String data = Uri.encodeComponent(jsonEncode(identity));
    return '$verification?identity=$data&identity_type=$identityType&fromPage=$fromPage';
  }

  static String getChangePasswordRoute(
      String identity, String identityType, String otp) {
    String identity0 = Uri.encodeComponent(jsonEncode(identity));
    String otp0 = Uri.encodeComponent(jsonEncode(otp));
    return '/$changePassword?identity=$identity0&identity_type=$identityType&otp=$otp0';
  }

  static String getUpdateRoute(bool isUpdate) =>
      '$update?update=${isUpdate.toString()}';
  static String getInboxScreenRoute({String? fromNotification}) =>
      '$chatInbox?fromNotification=$fromNotification';
  static String getHtmlRoute(String page) => '$html?page=$page';
  static String getLanguageScreen(String fromPage) =>
      '$languageScreen?fromPage=$fromPage';

  static List<GetPage> routes = [
    GetPage(
      name: initial,
      binding: InitialBinding(),
      page: () => const InitialPage(),
      //middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: register,
      page: () => const RegisterPage(),
    ),
    GetPage(
      name: signIn,
      page: () => const SignInPage(),
    ),

    // GetPage(
    //   name: languageScreen,
    //   page: () => LanguageScreen(
    //     fromPage: Get.parameters['fromPage']!,
    //   ),
    // ),
    // GetPage(
    //     binding: InitialBinding(),
    //     name: html,
    //     page: () => HtmlViewerScreen(
    //         htmlType: Get.parameters['page'] == 'terms-and-condition'
    //             ? HtmlType.termsAndCondition
    //             : Get.parameters['page'] == 'privacy-policy'
    //                 ? HtmlType.privacyPolicy
    //                 : Get.parameters['page'] == 'cancellation_policy'
    //                     ? HtmlType.cancellationPolicy
    //                     : Get.parameters['page'] == 'refund_policy'
    //                         ? HtmlType.refundPolicy
    //                         : HtmlType.aboutUs)),
    GetPage(
      name: paymentTest,
      page: () => PaymentTestScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => PaymentController());
      }),
    ),
  ];
}
