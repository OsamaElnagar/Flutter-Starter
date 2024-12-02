import 'dart:developer';
import 'package:get/get.dart';
import 'package:starter/components/custom_snackbar.dart';
import 'package:starter/core/helpers/route_helper.dart';
import 'package:starter/features/authentication/controller/auth_controller.dart';

class ApiChecker {
  static void checkApi(Response response) {
    log("CheckApi >>>> StatusCode is: ${response.statusCode}");

    if (response.statusCode == 401) {
      Get.find<AuthController>().clearSharedData();
      if (Get.currentRoute != RouteHelper.getSignInRoute('splash')) {
        Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.main));
        customSnackBar("${response.statusCode!}".tr);
      }
    } else if (response.statusCode == 500) {
      customSnackBar("${response.statusCode!}".tr);
    } else {
      //customSnackBar("${response.body['message']}");
    }
  }
}
