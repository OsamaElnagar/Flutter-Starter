import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/features/authentication/model/signin_response_model.dart';
import 'package:starter/features/profile/repo/profile_repo.dart';

import '../../authentication/service/user_hive_service.dart';

class ProfileController extends GetxController implements GetxService {
  final ProfileRepository repository;
  ProfileController({
    required this.repository,
  });

  UserResponse? userResponse;

  @override
  void onInit() {
    userResponse = Get.find<UserHiveService>().getUser();
    nameController.text = userResponse!.user.name;
    emailController.text = userResponse!.user.email;
    phoneController.text = userResponse!.user.phoneNumber ?? "";
    super.onInit();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
}
