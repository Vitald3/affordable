import 'package:affordable/utils/extension.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart';
import '../../model/pay_response_model.dart';

class PayNetwork {
  static Future<PayResponseModel?> getPay() async {
    try {
      final response = await Supabase.instance.client
          .from('pay')
          .select()
          .match({'uuid': Supabase.instance.client.auth.currentUser!.id});

      if (response.isNotEmpty) {
        final pay = PayResponseModel.fromJson(response.single);

        if (pay.date.year == DateTime.now().year) {
          return PayResponseModel.fromJson(response.single);
        }
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return null;
  }

  static Future<void> setPay() async {
    try {
      await Supabase.instance.client
          .from('pay')
          .insert({'uuid': Supabase.instance.client.auth.currentUser!.id});
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }
  }

  static Future<void> updatePay() async {
    try {
      await Supabase.instance.client
          .from('pay')
          .update({'pay': true})
          .eq('id', pay!.id);
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }
  }
}