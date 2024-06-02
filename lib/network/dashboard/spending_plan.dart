import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/spending_response_model.dart';
import '../../utils/extension.dart';

class SpendingPlanNetwork {
  static Future<bool> editSpending(Map <String, dynamic> body) async {
    try {
      await Supabase.instance.client
          .from('spending_plan')
          .delete()
          .eq('date', body['date']);

      await Supabase.instance.client
          .from('spending_plan')
          .insert(body);

      return true;
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return false;
  }

  static Future<bool> deleteSpending(String date) async {
    try {
      await Supabase.instance.client
          .from('spending_plan')
          .delete()
          .eq('date', date);

      return true;
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return false;
  }

  static Future<List<SpendingResponseModel>> getSpendingById(int id) async {
    var items = <SpendingResponseModel>[];

    try {
      final response = await Supabase.instance.client
          .from('spending_plan')
          .select('id, price, period_id, date')
          .eq('period_id', id);

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

  static Future<List<SpendingResponseModel>> getSpending(String date) async {
    var items = <SpendingResponseModel>[];

    try {
      final response = await Supabase.instance.client
          .from('spending_plan')
          .select('id, price, period_id, date')
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

  static Future<List<SpendingResponseModel>> getSpendings(List<int> periodIds) async {
    var items = <SpendingResponseModel>[];

    try {
      final response = await Supabase.instance.client
          .from('spending_plan')
          .select('id, price, period_id, date')
          .filter('period_id', 'in', periodIds);

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