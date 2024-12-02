import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/components/custom_auth_field.dart';
import 'package:starter/core/helpers/validation.dart';
import 'package:starter/features/authentication/controller/auth_controller.dart';

import '../../../components/prepare_image_to_upload.dart';
import '../../../utils/gaps.dart';

class SignupStepOne extends GetView<AuthController> {
  final GlobalKey<FormState> formKey;

  const SignupStepOne({
    super.key,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          width: 296,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Store Information',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                gapH16,
                CustomTextFormField(
                  controller: controller.storeNameController,
                  hintText: 'Store Name',
                  iconAsset: 'assets/icons/store_light.svg',
                  validator: Validation.validateName,
                ),
                gapH16,
                CustomTextFormField(
                  controller: controller.storeDescriptionController,
                  hintText: 'Store Description',
                  iconAsset: 'assets/icons/history_filled.svg',
                  //validator: Validation.validateName,
                ),
                gapH16,
                CustomTextFormField(
                  controller: controller.storeEmailController,
                  hintText: 'Store Email',
                  keyboardType: TextInputType.emailAddress,
                  iconAsset: 'assets/icons/mail_light.svg',
                  validator: Validation.validateEmail,
                ),
                gapH16,
                ...[
                  PrepareImageToUpload(
                    title: 'Logo',
                    initialImage: controller.logoImage,
                    onImageChanged: controller.updateLogoImage,
                  ),
                  gapH8,
                  PrepareImageToUpload(
                    title: 'Cover',
                    initialImage: controller.coverImage,
                    onImageChanged: controller.updateCoverImage,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
