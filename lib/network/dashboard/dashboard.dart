import 'package:affordable/utils/extension.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/category_response.dart';
import '../../model/expense_response.dart';
import '../../model/income_response.dart';
import '../../model/spending_response_model.dart';

class DashboardNetwork {
  static Future<List<IncomeResponseModel>> getIncomes(int periodId) async {
    var items = <IncomeResponseModel>[];

    try {
      final response = await Supabase.instance.client
          .from('incomes')
          .select()
          .eq('period_id', periodId);

      for (var i in response) {
        items.add(IncomeResponseModel.fromJson(i));
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return items;
  }

  static Future<List<SpendingResponseModel>> getSpendingsAll(List<int> periodIds) async {
    var items = <SpendingResponseModel>[];

    try {
      final response = await Supabase.instance.client
          .from('spendings')
          .select('id, price, period_id, date, type')
          .filter('period_id', 'in', periodIds);

      for (var i in response) {
        items.add(SpendingResponseModel.fromJson(i));
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return items;
  }

  static Future<List<IncomeResponseModel>> getAllIncomes(List<int> periodIds) async {
    var items = <IncomeResponseModel>[];

    try {
      final response = await Supabase.instance.client
          .from('incomes')
          .select()
          .filter('period_id', 'in', periodIds);

      for (var i in response) {
        items.add(IncomeResponseModel.fromJson(i));
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return items;
  }

  static Future<List<CategoryResponse>> getCategories() async {
    var items = <CategoryResponse>[];

    try {
      final response = await Supabase.instance.client
          .from('categories')
          .select('id, name, icon, percent');

      if (response.isNotEmpty) {
        for (var i in response) {
          items.add(CategoryResponse.fromJson(i));
        }
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return items;
  }

  static Future<IncomeResponseModel?> getIncome(int id) async {
    try {
      final response = await Supabase.instance.client
          .from('incomes')
          .select()
          .eq('id', id);

      if (response.isNotEmpty) {
        return IncomeResponseModel.fromJson(response.single);
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return null;
  }

  static Future<List<ExpenseResponse>> getExpenses(List<int> planningIds) async {
    var items = <ExpenseResponse>[];

    try {
      final response = await Supabase.instance.client
          .from('expenses')
          .select('id, planning_id, name, price, category_id, created_at')
          .filter('planning_id', 'in', planningIds);

      for (var i in response) {
        items.add(ExpenseResponse.fromJson(i));
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return items;
  }

  static Future<List<SpendingResponseModel>> getSpendings(int periodId) async {
    var items = <SpendingResponseModel>[];

    try {
      final response = await Supabase.instance.client
          .from('spendings')
          .select('id, price, period_id, date, type')
          .eq('period_id', periodId);

      for (var i in response) {
        items.add(SpendingResponseModel.fromJson(i));
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return items;
  }
}