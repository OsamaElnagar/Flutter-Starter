import 'package:hive/hive.dart';
import '../model/signin_response_model.dart';

class UserHiveService {
  final Box<UserResponse> userBox;

  UserHiveService(this.userBox);

  Future<UserResponse> saveUser(UserResponse userResponse) async {
    await userBox.put('user', userResponse);
    return userResponse;
  }

  UserResponse? getUser() {
    return userBox.get('user');
  }

  Future<void> clearUser() async {
    await userBox.delete('user');
  }
} 