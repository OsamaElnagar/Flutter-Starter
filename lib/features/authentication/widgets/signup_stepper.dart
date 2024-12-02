import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/components/custom_stepper.dart';
import 'package:starter/core/helpers/route_helper.dart';
import 'package:starter/features/authentication/widgets/signup_step_one.dart';
import 'package:starter/features/authentication/widgets/signup_step_two.dart';
import 'package:starter/features/authentication/widgets/signup_step_three.dart';
import 'package:starter/theme/app_colors.dart';
import 'package:starter/utils/gaps.dart';
import 'package:starter/features/authentication/controller/signup_stepper_controller.dart';

class SignupStepper extends StatelessWidget {
  SignupStepper({super.key});

  final SignupStepperController signupStepperController =
      Get.put(SignupStepperController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Signup',
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          gapH24,

          /// SIGNUP TEXT
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textGrey),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    color: AppColors.titleLight,
                  ),
                ),
                onPressed: () => Get.toNamed(RouteHelper.getSignInRoute('')),
                child: const Text('Sign in'),
              ),
            ],
          ),

          gapH24,
          Obx(() => CustomStepper(
              currentStep: signupStepperController.currentStep.value,
              totalSteps: 3)),
          Expanded(
            child: PageView(
              controller: signupStepperController.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SignupStepOne(
                  formKey: signupStepperController.formKeyStepOne,
                ),
                SignupStepTwo(
                  formKey: signupStepperController.formKeyStepTwo,
                ),
                SignupStepThree(
                  formKey: signupStepperController.formKeyStepThree,
                  onPlanSelected: signupStepperController.setSelectedPlan,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (signupStepperController.currentStep.value > 0)
                      ElevatedButton(
                        onPressed: signupStepperController.previousStep,
                        child: const Text('Previous'),
                      )
                    else
                      const SizedBox(),
                    ElevatedButton(
                      onPressed: signupStepperController.nextStep,
                      child: Text(signupStepperController.currentStep.value < 2
                          ? 'Next'
                          : 'Submit'),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
