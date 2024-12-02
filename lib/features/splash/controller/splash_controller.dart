import 'package:get/get.dart';
import 'package:starter/components/custom_snackbar.dart';
import 'package:starter/core/helpers/log_helper.dart';
import 'package:starter/services/api_client.dart';
import 'package:starter/services/checker_api.dart';
import 'package:starter/features/authentication/model/signin_response_model.dart';
import 'package:starter/features/authentication/service/user_hive_service.dart';
import 'package:starter/models/config_model.dart';
import 'package:starter/utils/app_constants.dart';

import '../repository/splash_repo.dart';

class SplashController extends GetxController implements GetxService {
  final SplashRepo splashRepo;
  final UserHiveService userHiveService;
  SplashController({
    required this.splashRepo,
    required this.userHiveService,
  });

  ConfigModel? _configModel = ConfigModel();
  bool _firstTimeConnectionCheck = true;
  bool _hasConnection = true;
  final bool _isLoading = false;

  bool get isLoading => _isLoading;
  ConfigModel get configModel => _configModel!;
  DateTime get currentTime => DateTime.now();
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;
  bool get hasConnection => _hasConnection;

  bool savedCookiesData = false;

  @override
  void onInit() async {
    getUserResponse();
    super.onInit();
  }

  UserResponse? getUserResponse() {
    return userHiveService.getUser();
  }

  Future<void> clearUserResponse() async {
    await userHiveService.clearUser();
  }

  Future<bool> getConfigData() async {
    _hasConnection = true;
    Response response = await splashRepo.getConfigData();
    bool isSuccess = false;
    if (response.statusCode == 200) {
      _configModel = ConfigModel.fromJson(response.body);

      printLog("Time Format: ${_configModel?.content?.timeFormat}");

      isSuccess = true;
    } else {
      ApiChecker.checkApi(response);
      if (response.statusText == ApiClient.noInternetMessage) {
        _hasConnection = false;
      }
      isSuccess = false;
    }
    update();
    return isSuccess;
  }

  Future<bool> initSharedData() {
    return splashRepo.initSharedData();
  }

  void setGuestId(String guestId) {
    splashRepo.setGuestId(guestId);
  }

  String getGuestId() {
    return splashRepo.getGuestId();
  }

  Future<bool> saveSplashSeenValue(bool value) async {
    return await splashRepo.setSplashSeen(value);
  }

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  void saveCookiesData(bool data) {
    splashRepo.saveCookiesData(data);
    savedCookiesData = true;
    update();
  }

  getCookiesData() {
    savedCookiesData = splashRepo.getSavedCookiesData();
    update();
  }

  void cookiesStatusChange(String? data) {
    if (data != null) {
      splashRepo.sharedPreferences
          .setString(AppConstants.cookiesManagement, data);
    }
  }

  bool getAcceptCookiesStatus(String data) =>
      splashRepo.sharedPreferences.getString(AppConstants.cookiesManagement) !=
          null &&
      splashRepo.sharedPreferences.getString(AppConstants.cookiesManagement) ==
          data;

  String getZoneId() => splashRepo.getZoneId();
  bool isSplashSeen() => splashRepo.isSplashSeen();

  Future<void> updateLanguage(bool isInitial) async {
    Response response = await splashRepo.updateLanguage(getGuestId());

    if (!isInitial) {
      if (response.statusCode == 200 &&
          response.body['response_code'] == "default_200") {
      } else {
        customSnackBar("${response.body['message']}");
      }
    }
  }
}
