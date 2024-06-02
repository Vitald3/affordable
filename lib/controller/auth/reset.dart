import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../network/auth/reset.dart';

class ResetController extends GetxController {
  bool submitButton = false;
  bool passwordHide = false;
  TextEditingController password = TextEditingController();
  TextEditingController code = TextEditingController();
  final focusPassword = FocusNode();
  final focusCode = FocusNode();

  @override
  void onClose() {
    password.dispose();
    focusPassword.dispose();
    code.dispose();
    focusCode.dispose();
    super.onClose();
  }

  void setPasswordHide() {
    passwordHide = !passwordHide;
    update();
  }

  Future<void> reset() async {
    FocusScope.of(Get.context!).unfocus();
    final String passwordStr = password.value.text;
    final String codeStr = code.value.text;

    if (passwordStr != '' && codeStr != '') {
      if (!submitButton) {
        submitButton = true;
        update();

        final token = await ResetNetwork.reset(passwordStr, codeStr, Get.arguments['email']);

        if (token) {
          Get.offAllNamed("/login");
        }

        submitButton = false;
        update();
      }
    } else {
      if (codeStr == '') {
        focusCode.requestFocus();
      } else if (passwordStr == '') {
        focusPassword.requestFocus();
      }
    }
  }
}