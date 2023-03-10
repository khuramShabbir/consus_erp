import 'dart:convert';

import 'package:consus_erp/Model/UserAuth/login.dart';
import 'package:consus_erp/Services/ApiServices/api_urls.dart';
import 'package:consus_erp/Services/StorageServices/storage_services.dart';
import 'package:consus_erp/utils/info_controller.dart';
import 'package:flutter/cupertino.dart';

import '/Model/UserAuth/user.dart';
import '/Services/ApiServices/api_services.dart';

class LoginProvider extends ChangeNotifier {
  TextEditingController userNameCtrl = TextEditingController(text: "");
  TextEditingController passwordCtrl = TextEditingController(text: "");
  GlobalKey<FormState> formKey = GlobalKey();
  bool rememberMe = false;
  LoginResponse? loginResponse;

  /// Check Form Field Valid or invalid
  bool formValidation() {
    if (formKey.currentState!.validate()) return true;
    return false;
  }

  /// Login
  Future<bool> login() async {
    if (formValidation()) {
      try {
        Info.startProgress();
        String response = await ApiServices.getMethodApi(
          "${ApiUrls.VERIFY_USER}?username=${userNameCtrl.text.trim()}&password=${passwordCtrl.text.trim()}",
        );
        Info.stopProgress();

        logger.i("Login Response>>>>>>>>  $response");

        if (response.isEmpty) return false;

        loginResponse = loginResponseFromJson(response);

        if (loginResponse?.error == true || loginResponse?.user == null) {
          await Info.errorSnackBar(loginResponse?.responseMessage ?? "Something Went Wrong");
          return false;
        }
        if (loginResponse?.user != null) {
          await saveUser(loginResponse!.user!);
          await Info.successSnackBar(loginResponse?.responseMessage ?? "");
          clearControllers();
          return true;
        }
      } catch (e) {
        logger.e(e);
        await Info.errorSnackBar(e.toString());
      } finally {
        Info.stopProgress();
      }
    }
    return false;
  }

  /// Clear Controllers
  void clearControllers() {
    userNameCtrl.clear();
    passwordCtrl.clear();
  }

  /// Remember Me
  void remember() async {
    rememberMe = !rememberMe;
    logger.i(rememberMe);
    notifyListeners();
  }

  /// Save User Data After Login
  Future<void> saveUser(User data) async {
    if (rememberMe)
      await LocalStorage.write(LocalStorage.remember, rememberMe);
    else {
      LocalStorage.remove(LocalStorage.remember);
    }
    final String jd = jsonEncode(data);

    await LocalStorage.write(LocalStorage.userData, jd);
  }

  /// Check if user already login
  Future<bool> checkUserStatus() async {
    if (LocalStorage.box.hasData(LocalStorage.userData)) {
      return true;
    }
    return false;
  }

  /// LogoOut User
  Future<bool> logout() async {
    // await LocalStorage.box.erase();
    LocalStorage.box.remove(LocalStorage.userData);

    await Info.successSnackBar("User Logged Successfully");
    return true;
  }

  /// Get User Data From Local Storage
  static User getUser() {
    return User.fromJson(jsonDecode(LocalStorage.box.read(LocalStorage.userData)));
  }
}
