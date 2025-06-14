import 'package:flutter/material.dart';
import 'package:interview_task/core/app/app_constants.dart';
import 'package:interview_task/feature/auth/services/user_shared_pref.dart';
import '../model/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;
  String _username = 'Guest';
  String get username => _username;

  Future<void> signUp(String username, String email, String password) async {
    final newUser =
        UserModel(username: username, email: email, password: password);
    await UserSharedPreService.saveUser(newUser);
    _user = newUser;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final storedUser = await UserSharedPreService.getUser();
    if (storedUser != null &&
        storedUser.email == email &&
        storedUser.password == password) {
      _user = storedUser;
      notifyListeners();
      return true;
    } else if (email == AppConstants.adminEmail &&
        password == AppConstants.adminPassword) {
      _user = UserModel(
        username: 'Admin',
        email: email,
        password: password,
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logOut() async {
    await UserSharedPreService.clearUser();
    _user = null;
    notifyListeners();
  }

  Future<void> loadUsername() async {
    UserModel? user = await UserSharedPreService.getUser();
    _username = user?.username ?? 'Guest';
    notifyListeners();
  }
}
