import 'package:get/get.dart';
import 'package:starter/features/authentication/controller/auth_controller.dart';
import 'package:starter/features/authentication/repo/auth_repo.dart';
import 'package:starter/features/payment/controllers/payment_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => AuthController(
        authRepo: AuthRepo(
          apiClient: Get.find(),
          sharedPreferences: Get.find(),
          userHiveService: Get.find(),
        ),
      ),
    );
    Get.lazyPut(
      () => PaymentController(),
    );
  }
}
