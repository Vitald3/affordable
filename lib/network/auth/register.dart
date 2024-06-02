import 'package:easy_localization/easy_localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/login_model.dart';

class RegisterNetwork {
  static Future<Map<String, dynamic>> register(LoginModel login) async {
    String error = '';
    bool unique = false;

    try {
      final AuthResponse response = await Supabase.instance.client.auth.signUp(email: login.email, password: login.password, data: {'username': login.name});

      if ((response.user?.identities ?? []).isEmpty) {
        unique = true;
      }
    } on AuthException catch (_) {
      error = tr('error_send_email');
    } catch (e) {
      error = tr('text_error');
    }

    return {'error': error, 'unique': unique};
  }
}