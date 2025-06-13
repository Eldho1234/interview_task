import 'package:flutter/material.dart';
import 'package:interview_task/feature/auth/services/user_shared_pref.dart';
import '../model/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

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
    }
    return false;
  }

  Future<void> logOut() async {
    await UserSharedPreService.clearUser();
    _user = null;
    notifyListeners();
  }
}
