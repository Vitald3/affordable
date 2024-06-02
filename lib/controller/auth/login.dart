import 'package:affordable/utils/extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart';
import '../../model/login_model.dart';
import '../../network/auth/login.dart';
import '../../utils/constant.dart';

class LoginController extends GetxController {
  bool submitButton = false;
  bool submitGoogle = false;
  bool passwordHide = true;
  TextEditingController login = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void setPasswordHide() {
    passwordHide = !passwordHide;
    update();
  }

  Future<void> auth() async {
    FocusScope.of(Get.context!).unfocus();

    if (formKey.currentState!.validate()) {
      if (!submitButton) {
        submitButton = true;
        update();

        final token = await LoginNetwork.auth(LoginModel(email: login.value.text, password: password.value.text));

        if (token) {
          Get.offAllNamed((prefs?.getBool('level') ?? false) ? '/' : '/period');
        }

        submitButton = false;
        update();
      }
    }
  }

  Future<void> googleSignIn() async {
    submitGoogle = false;
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
          Get.offAllNamed((prefs?.getBool('level') ?? false) ? '/' : '/period');
        } else {
          snackBar(text: tr('error_auth'), error: true);
        }
      }
    }
  }
}