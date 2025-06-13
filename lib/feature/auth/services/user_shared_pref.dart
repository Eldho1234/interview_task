import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';

class UserSharedPreService {
  static const _keyUser = 'user';

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyUser, userModelToJson(user));
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyUser);
    if (jsonStr != null) {
      return userModelFromJson(jsonStr);
    }
    return null;
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyUser);
  }
}
