import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/components/common_container.dart';
import 'package:starter/components/custom_image.dart';
import 'package:starter/components/widgets/section_title.dart';
import 'package:starter/features/profile/controller/profile_controller.dart';
import 'package:starter/utils/dimensions.dart';
import 'package:starter/utils/gaps.dart';

import '../../../utils/responsive.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!Responsive.isMobile(context)) 25.h,
        Text(
          "Profile",
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        gapH20,
        CommonContainer(
          hasDecoImage: true,
          decoImagePath: controller.userResponse!.user.avatar,
          child: Column(
            children: [
              const SectionTitle(title: 'Store'),
              gapH8,
              CustomImage(
                width: Dimensions.imageSizeLarge * 2,
                radius: 10,
                path: controller.userResponse!.user.avatar,
              ),
              gapH24,
            ],
          ),
        ),
        gapH24,
        CommonContainer(
          child: Column(
            children: [
              const SectionTitle(title: 'General Info'),
              gapH8,
              Form(
                child: Column(
                  children: [
                    TextFormFieldComponent(
                      label: 'Name',
                      controller: controller.nameController,
                    ),
                    gapH8,
                    TextFormFieldComponent(
                      label: 'Email',
                      controller: controller.emailController,
                    ),
                    gapH8,
                    TextFormFieldComponent(
                      label: 'Phone',
                      controller: controller.phoneController,
                    ),
                    gapH8,
                  ],
                ),
              ),
            ],
          ),
        ),
        gapH24,
        gapH24,
        CommonContainer(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                child: const Text('Discard Changes',
                    style: TextStyle(color: Colors.red)),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child:
                    const Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TextFormFieldComponent extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final String? hintText;
  final FormFieldValidator<String>? validator;

  const TextFormFieldComponent({
    super.key,
    required this.label,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines,
    this.maxLength,
    this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        gapH4,
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
