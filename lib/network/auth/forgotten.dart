import 'package:affordable/utils/extension.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgottenNetwork {
  static Future<bool> forgotten(String email) async {
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(email);

      return true;
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return false;
  }
}