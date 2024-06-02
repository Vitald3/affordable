import 'package:affordable/utils/extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/login_model.dart';

class LoginNetwork {
  static Future<bool> auth(LoginModel login) async {
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: login.email,
        password: login.password,
      );

      return true;
    } on AuthException catch (error) {
      if (error.message.contains('not confirm')) {
        snackBar(text: tr('error_confirm'), error: true, callback: () => Get.toNamed('/confirmation', arguments: {'use_code': 1, 'email': login.email, 'password': login.password, 'name': login.name}));
      } else {
        snackBar(text: tr('error_login'), error: true);
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return false;
  }
}