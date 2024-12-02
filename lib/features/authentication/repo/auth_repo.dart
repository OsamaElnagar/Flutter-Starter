import 'package:get/get.dart';
import 'package:starter/services/api_client.dart';
import 'package:starter/features/authentication/model/signin_response_model.dart';
import 'package:starter/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/user_hive_service.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  final UserHiveService userHiveService;

  AuthRepo({
    required this.apiClient,
    required this.sharedPreferences,
    required this.userHiveService,
  });

  Future<Response> login(
    body,
  ) async {
    return await apiClient.postData(
      AppConstants.login,
      body,
    );
  }

  Future<Response?> logout() async {
    return await apiClient.postData(AppConstants.logout, {});
  }

  Future<Response> register(Map<String, dynamic> body) async {
    return await apiClient.postData(
      AppConstants.register,
      body,
    );
  }

  Future<void> saveToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token: token);
    await sharedPreferences.setString(AppConstants.token, token);
  }

  String getToken() {
    return sharedPreferences.getString(AppConstants.token) ?? '';
  }

  Future<Response?> updateToken() async {
    return null;
  }

  Future<bool> clearSharedData() async {
    await sharedPreferences.clear();
    return true;
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  Future<Response> registerVendor(
      Map<String, String> body, List<MultipartBody> multipartBody) async {
    return await apiClient.postMultipartData(
      AppConstants.registerVendor,
      body,
      multipartBody,
    );
  }

  Future<UserResponse> saveUserResponse(UserResponse userResponse) async {
    return userHiveService.saveUser(userResponse);
  }

  UserResponse? getUserResponse() {
    return userHiveService.getUser();
  }

  Future<void> clearUserResponse() async {
    await userHiveService.clearUser();
  }
}
