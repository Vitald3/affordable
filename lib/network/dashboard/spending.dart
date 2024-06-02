import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/spending_response_model.dart';
import '../../utils/extension.dart';

class SpendingNetwork {
  static Future<bool> editSpending(Map <String, dynamic> body) async {
    try {
      await Supabase.instance.client
          .from('spendings')
          .insert(body);

      return true;
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return false;
  }

  static Future<bool> deleteSpending(String date) async {
    try {
      final response = await Supabase.instance.client
          .from('spendings')
          .select('id, price, period_id, date, type')
          .eq('date', date)
          .limit(1)
          .order('id');

      if (response.isNotEmpty) {
        await Supabase.instance.client
            .from('spendings')
            .delete()
            .eq('id', response.single['id']);
      }

      return true;
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return false;
  }

  static Future<List<SpendingResponseModel>> getSpending(String date) async {
    var items = <SpendingResponseModel>[];

    try {
      final response = await Supabase.instance.client
          .from('spendings')
          .select('id, price, period_id, date, type')
          .eq('date', date);

      if (response.isNotEmpty) {
        for (var i in response) {
          items.add(SpendingResponseModel.fromJson(i));
        }
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return items;
  }
}