import 'package:affordable/utils/extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetNetwork {
  static Future<bool> reset(String password, String code, String email) async {
    try {
      final AuthResponse response = await Supabase.instance.client.auth.verifyOTP(
        type: OtpType.email,
        token: code,
        email: email
      );

      if (response.user != null) {
        final UserResponse res = await Supabase.instance.client.auth.updateUser(
          UserAttributes(
            password: password,
          ),
        );

        if (res.user != null) {
          return true;
        } else {
          snackBar(text: tr('error_account'), error: true);
          return false;
        }
      } else {
        snackBar(text: tr('error_code_reset'), error: true);
        return false;
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return false;
  }
}