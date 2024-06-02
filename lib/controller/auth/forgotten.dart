import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../network/auth/forgotten.dart';

class ForgottenController extends GetxController {
  bool submitButton = false;
  TextEditingController login = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    login.dispose();
    super.onClose();
  }

  Future<void> forgotten() async {
    FocusScope.of(Get.context!).unfocus();
    final String email = login.value.text;

    if (formKey.currentState!.validate()) {
      if (!submitButton) {
        submitButton = true;
        update();

        final token = await ForgottenNetwork.forgotten(login.value.text);

        if (token) {
          Get.offNamed('/reset', arguments: {'email': email});
        }

        submitButton = false;
        update();
      }
    }
  }
}