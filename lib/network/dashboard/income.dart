import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/expense_response.dart';
import '../../utils/extension.dart';

class IncomeNetwork {
  static Future<bool> editIncome(int id, Map <String, dynamic> body) async {
    try {
      if (id == 0) {
        await Supabase.instance.client
            .from('incomes')
            .insert(body);
      } else {
        await Supabase.instance.client
            .from('incomes')
            .update(body)
            .eq('id', id);
      }

      return true;
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return false;
  }

  static Future<bool> deleteIncome(int id) async {
    try {
      await Supabase.instance.client
          .from('incomes')
          .delete()
          .eq('id', id);

      return true;
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return false;
  }

  static Future<ExpenseResponse?> getExpense(int id) async {
    try {
      final response = await Supabase.instance.client
          .from('expenses')
          .select('id, category_id, planning_id, name, price, created_at')
          .eq('id', id);

      if (response.isNotEmpty) {
        return ExpenseResponse.fromJson(response.single);
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return null;
  }
}