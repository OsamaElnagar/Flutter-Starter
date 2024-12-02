import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:starter/components/custom_snackbar.dart';
import 'package:starter/features/authentication/controller/auth_controller.dart';

class SignupStepperController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentStep = 0.obs;

  // Form keys for each step
  final formKeyStepOne = GlobalKey<FormState>();
  final formKeyStepTwo = GlobalKey<FormState>();
  final formKeyStepThree = GlobalKey<FormState>();

  final Rxn<String> selectedPlan = Rxn<String>();

  // Get the AuthController instance
  final AuthController authController = Get.find<AuthController>();

  void nextStep() {
    if (currentStep.value < 2) {
      if (currentStep.value == 0) {
        if (!formKeyStepOne.currentState!.validate()) {
          return;
        }
        if (authController.logoImage == null ||
            authController.coverImage == null) {
          customSnackBar(
            'Missing Images\nPlease add both a logo and a cover image for your store.',
            isError: true,
          );
          return;
        }
      }
      if (currentStep.value == 1 && !formKeyStepTwo.currentState!.validate()) {
        return;
      }

      currentStep.value++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      submitForm();
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void submitForm() {
    // Call the registerVendor method from AuthController
    authController.registerVendor();
  }

  void setSelectedPlan(String plan) {
    selectedPlan.value = plan;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
