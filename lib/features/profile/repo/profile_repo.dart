import 'package:starter/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../authentication/service/user_hive_service.dart';

class ProfileRepository {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  final UserHiveService userHiveService;

  ProfileRepository({
    required this.apiClient,
    required this.sharedPreferences,
    required this.userHiveService,
  });
}
