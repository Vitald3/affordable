import 'package:affordable/utils/extension.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/expense_response.dart';
import '../../model/planning_response_model.dart';

class PlanningCategoryNetwork {
  static Future<List<ExpenseResponse>?> getExpense(int id, int categoryId) async {
    try {
      final response = await Supabase.instance.client
          .from('plannings')
          .select('id, category_id, expenses(id, category_id, planning_id, name, price, created_at)')
          .match({'id': id, 'expenses.category_id': categoryId});

      if (response.isNotEmpty) {
        final PlanningResponseModel planning = PlanningResponseModel.fromJson(response.single);

        return planning.expenses!;
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return null;
  }

  static Future<int> addPlanning(int periodId) async {
    int id = 0;

    try {
      final response = await Supabase.instance.client.from('planning').insert({}).single();

      if (response.isNotEmpty) {
        final PlanningResponseModel planning = PlanningResponseModel.fromJson(response);
        id = planning.id;
        await Supabase.instance.client
            .from('periods')
            .update({'planning_id': id})
            .match({'id': periodId});
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return id;
  }

  static Future<bool> addExpense(Map<String, dynamic> body, int? id) async {
    bool success = false;

    try {
      if (id == null) {
        await Supabase.instance.client
            .from('expenses')
            .insert(body);

        var list = <int>[];

        if (body['planning_id'] != null && body['category_id'] != null) {
          final response = await Supabase.instance.client.from('plannings').select('category_id').eq('id', body['planning_id']).single();

          if (response['category_id'] != null) {
            for (var i in response['category_id']) {
              list.add(i);
            }
          }

          if (!list.contains(body['category_id'])) {
            list.add(body['category_id']);
          }

          await Supabase.instance.client
              .from('plannings')
              .update({'category_id': list})
              .eq('id', body['planning_id']);
        }
      } else {
        await Supabase.instance.client
            .from('expenses')
            .update(body)
            .match({'id': id});
      }

      success = true;
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return success;
  }

  static Future<bool> deleteExpense(int id) async {
    bool success = false;

    try {
      await Supabase.instance.client
          .from('expenses')
          .delete()
          .match({'id': id});

      success = true;
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return success;
  }
}