import 'package:affordable/utils/extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart';
import '../../model/login_model.dart';
import '../../network/auth/register.dart';
import '../../utils/constant.dart';

class RegisterController extends GetxController {
  bool submitButton = false;
  bool submitGoogle = false;
  bool passwordHide = true;
  TextEditingController name = TextEditingController();
  TextEditingController login = TextEditingController();
  TextEditingController password = TextEditingController();
  bool unique = false;
  final formKey = GlobalKey<FormState>();
  int shareId = 0;

  @override
  void onInit() {
    if ((prefs?.getInt('share_id') ?? 0) != 0) {
      shareId = prefs?.getInt('share_id') ?? 0;
    }

    super.onInit();
  }

  @override
  void onClose() {
    login.dispose();
    name.dispose();
    password.dispose();
    super.onClose();
  }

  void setPasswordHide() {
    passwordHide = !passwordHide;
    update();
  }

  void setUnique(bool val) {
    unique = val;
    update();
  }

  Future<void> register() async {
    submitButton = false;

    if (formKey.currentState!.validate() && !unique) {
      if (!submitButton) {
        submitButton = true;
        update();
        unique = false;

        final Map<String, dynamic> response = await RegisterNetwork.register(LoginModel(email: login.value.text.trim(), password: password.value.text, name: name.value.text));

        if (response['unique'] ?? false) {
          unique = true;
        } else if (response['error'] != null && response['error'] == '') {
          Get.offAllNamed('/confirmation', arguments: {'email': login.value.text, 'password': password.value.text, 'name': name.value.text});
        } else {
          snackBar(text: response['error'].toString(), error: true);
        }

        submitButton = false;
        update();
      }
    }
  }

  Future<void> googleSignIn() async {
    if (!submitGoogle) {
      submitGoogle = true;
      update();

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );

      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        snackBar(text: tr('error_token'), error: true);
      }

      if (idToken == null) {
        snackBar(text: tr('error_token'), error: true);
      } else {
        submitGoogle = false;
        update();

        final token = await Supabase.instance.client.auth.signInWithIdToken(
            provider: OAuthProvider.google,
            idToken: idToken,
            accessToken: accessToken
        );

        if (token.session != null && token.session?.accessToken != '') {
          Get.offAllNamed('/period');
        } else {
          snackBar(text: tr('error_auth'), error: true);
        }
      }
    }
  }
}