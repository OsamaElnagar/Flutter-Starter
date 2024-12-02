import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:starter/components/custom_snackbar.dart';
import 'package:starter/core/helpers/log_helper.dart';
import 'package:starter/core/helpers/route_helper.dart';
import 'package:starter/features/authentication/repo/auth_repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:starter/services/api_client.dart';

import 'package:package_info_plus/package_info_plus.dart';

import '../model/signin_response_model.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController({required this.authRepo});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  final storeNameController = TextEditingController();
  final storeEmailController = TextEditingController();
  final storeDescriptionController = TextEditingController();

  RxBool isLoading = false.obs;

  UserResponse? userResponse;

  Future<void> login() async {
    isLoading(true);
    try {
      final email = emailController.text.trim();
      final password = passwordController.text;
      final deviceName = await getDeviceName();

      Map<String, dynamic> body = {
        'email': email,
        'password': password,
        'device_name': deviceName,
      };
      Response response = await authRepo.login(body);

      if (response.statusCode == 200 &&
          response.body['response_code'] == 'auth_login_200') {
        userResponse = UserResponse.fromJson(response.body['content']);
        await authRepo.saveToken(userResponse!.token);
        await authRepo.saveUserResponse(userResponse!).then((user) {
          printLog('Saved User: ${user.user.name}');
          printLog('Saved Store: ${user.user.name}');
        });

        Get.offAllNamed(RouteHelper.getInitialRoute());

        customSnackBar('Logged in successfully'.tr, isError: false);
      } else {
        customSnackBar(response.body['message']);
      }
    } catch (e) {
      customSnackBar('Error\n$e');
      printLog(e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    Response? response = await authRepo.logout();
    await authRepo.clearSharedData();
    await authRepo.clearUserResponse();

    if (response?.statusCode == 200) {
      customSnackBar('Logged out successfully', isError: false);
    } else {
      customSnackBar("${response?.body['message']}");
    }
    Get.offAllNamed(RouteHelper.getSignInRoute(''));
    update();
  }

  assignUser(UserResponse user) {
    userResponse = user;
    update();
  }

  XFile? logoImage;
  XFile? coverImage;

  void updateLogoImage(XFile? image) {
    logoImage = image;
    update();
  }

  void updateCoverImage(XFile? image) {
    coverImage = image;
    update();
  }

  Future<void> registerVendor() async {
    isLoading(true);
    try {
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text;
      final confirmPassword = confirmPasswordController.text;
      final phone = phoneController.text.trim();
      final storeName = storeNameController.text.trim();
      final storeEmail = storeEmailController.text.trim();
      final storeDescription = storeDescriptionController.text.trim();
      final deviceName = await getDeviceName();

      if (password != confirmPassword) {
        customSnackBar('Passwords do not match', isError: true);
        return;
      }

      final body = {
        'name': name,
        'email': email,
        'phone_number': phone,
        'password': password,
        'password_confirmation': confirmPassword,
        'device_name': deviceName,
        'store_name': storeName,
        'store_email': storeEmail,
        'store_description': storeDescription,
      };

      List<MultipartBody> multipartBody = [];

      if (logoImage != null) {
        multipartBody.add(MultipartBody('logo', logoImage!));
      }

      if (coverImage != null) {
        multipartBody.add(MultipartBody('cover', coverImage!));
      }

      Response response = await authRepo.registerVendor(body, multipartBody);

      if (response.statusCode == 200 &&
          response.body['response_code'] == 'registration_200') {
        userResponse = UserResponse.fromJson(response.body['content']);
        await authRepo.saveToken(userResponse!.token);
        await authRepo.saveUserResponse(userResponse!);
        await authRepo.updateToken();

        Get.offNamed(RouteHelper.getInitialRoute());

        customSnackBar('Registered successfully as a vendor', isError: false);
      } else {
        customSnackBar(
          'Registration failed!\n ${response.body['errors'].toString()}',
          duration: 10,
        );
      }
    } catch (e) {
      customSnackBar('Error\n$e', duration: 7);
      printLog(e);
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    storeNameController.dispose();
    storeEmailController.dispose();
    storeDescriptionController.dispose();
    super.onClose();
  }

  Future<String> getDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();
    String deviceName = 'Unknown device';

    try {
      if (kIsWeb) {
        final webInfo = await deviceInfo.webBrowserInfo;
        deviceName = '${webInfo.browserName.name} on ${webInfo.platform}';
      } else if (GetPlatform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceName = '${androidInfo.brand} ${androidInfo.model}';
      } else if (GetPlatform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceName = '${iosInfo.name} ${iosInfo.model}';
      } else if (GetPlatform.isWindows) {
        final windowsInfo = await deviceInfo.windowsInfo;
        deviceName = 'Windows: ${windowsInfo.computerName}';
      } else if (GetPlatform.isMacOS) {
        final macOsInfo = await deviceInfo.macOsInfo;
        deviceName = 'macOS ${macOsInfo.osRelease}';
      } else if (GetPlatform.isLinux) {
        final linuxInfo = await deviceInfo.linuxInfo;
        deviceName = '${linuxInfo.name} ${linuxInfo.version}';
      }

      final packageInfo = await PackageInfo.fromPlatform();
      deviceName += ' (App v${packageInfo.version})';
    } catch (e) {
      printLog('Error getting device info: $e');
    }

    return deviceName;
  }

  Future<bool> clearSharedData() async {
    return await authRepo.clearSharedData();
  }

  bool isLoggedIn() {
    bool isLoggedIn = authRepo.isLoggedIn();

    update();
    return isLoggedIn;
  }

  Future<void> updateToken() async {
    await authRepo.updateToken();
  }

/*
  void saveUserNumberAndPassword(String number, String password) {
    authRepo.saveUserNumberAndPassword(number, password);
  }

  String getUserNumber() {
    return authRepo.getUserNumber();
  }

  String getUserCountryCode() {
    return authRepo.getUserCountryCode();
  }

  String getUserPassword() {
    return authRepo.getUserPassword();
  }

  bool isNotificationActive() {
    return authRepo.isNotificationActive();
  }

  toggleNotificationSound() {
    authRepo.toggleNotificationSound(!isNotificationActive());
    update();
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authRepo.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  
  GoogleSignInAccount? googleAccount;
  GoogleSignInAuthentication? auth;

  Future<void> socialLogin() async {
    googleAccount = (await _googleSignIn.signIn())!;
    auth = await googleAccount!.authentication;
    update();
  }

  Future<void> googleLogout() async {
    try {
      googleAccount = (await _googleSignIn.disconnect())!;
      auth = await googleAccount!.authentication;
    } catch (e) {
      if (kDebugMode) {
        print("");
      }
    }
  }

  Future<void> signOutWithFacebook() async {
    await FacebookAuth.instance.logOut();
  }

 

  void initCountryCode() {
    countryDialCode = CountryCode.fromCountryCode(
            Get.find<SplashController>().configModel.content != null
                ? Get.find<SplashController>().configModel.content!.countryCode!
                : "BD")
        .dialCode!;
  }
*/
}
