import 'package:affordable/utils/extension.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/category_response.dart';
import '../../model/expense_response.dart';
import '../../model/period_response_model.dart';
import '../../model/planning_response_model.dart';

class PlanningNetwork {
  static Future<List<PeriodResponseModel>> getPeriods({bool all = false}) async {
    var items = <PeriodResponseModel>[];

    try {
      final response = await Supabase.instance.client
          .from('periods')
          .select('*, plannings(id, category_id, expenses(id, category_id, planning_id, name, price, created_at))')
          .eq('uuid', Supabase.instance.client.auth.currentUser!.id)
          .order('day', ascending: true);

      var categoryIds = <int>[];
      var categories = <CategoryResponse>[];

      for (var i in response) {
        final PeriodResponseModel item = PeriodResponseModel.fromJson(i);

        if (item.planning != null && item.planning!.categoryIds != null) {
          categoryIds.addAll(item.planning!.categoryIds!);
        }
      }

      final query = Supabase.instance.client
          .from('categories')
          .select('id, name, icon, percent');

      if (!all) {
        query.inFilter('id', categoryIds);
      }

      final categoriesMap = await query;

      if (categoriesMap.isNotEmpty) {
        for (var i in categoriesMap) {
          categories.add(CategoryResponse.fromJson(i));
        }
      }

      for (var i in response) {
        final PeriodResponseModel item = PeriodResponseModel.fromJson(i);

        if (item.planning != null) {
          final PlanningResponseModel planning = item.planning!;

          if (all) {
            var categoryPlannings = <CategoryResponse>[];

            for (var category in categories) {
              final CategoryResponse itemCategory = category;
              category.expenses = planning.expenses?.where((expense) => (planning.id == expense.planningId && expense.categoryId == itemCategory.id)).toList();
              categoryPlannings.add(itemCategory);
            }

            planning.categories = categoryPlannings.map((e) => CategoryResponse.fromJson(e.toJson())).toList();
            item.planning = planning;
          } else {
            if (categories.isNotEmpty && planning.categoryIds != null && planning.expenses != null && planning.expenses!.isNotEmpty) {
              var categoryPlannings = <CategoryResponse>[];

              for (var category in categories.where((element) => planning.categoryIds!.contains(element.id))) {
                final CategoryResponse itemCategory = category;
                category.expenses = planning.expenses?.where((expense) => (planning.id == expense.planningId && expense.categoryId == itemCategory.id)).toList();
                categoryPlannings.add(itemCategory);
              }

              planning.categories = categoryPlannings.map((e) => CategoryResponse.fromJson(e.toJson())).toList();
              planning.expenses = null;
              item.planning = planning;
              categoryPlannings = [];
            } else {
              item.planning = null;
            }
          }
        }

        items.add(item);
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return items;
  }

  static Future<PeriodResponseModel?> getPeriod(int periodId, {int id = 0, bool addPlanning = false}) async {
    try {
      var map = <dynamic, dynamic>{};

      if (id > 0) {
        map['planning_id'] = id;
      }

      if (periodId > 0) {
        map['id'] = periodId;
      }

      final response = await Supabase.instance.client
          .from('periods')
          .select('*, plannings(id, category_id, expenses(id, category_id, planning_id, name, price, created_at))')
          .match(map);

      if (response.isNotEmpty) {
        var categories = <CategoryResponse>[];

        final PeriodResponseModel item = PeriodResponseModel.fromJson(response.single);

        if (item.planning == null && addPlanning) {
          item.planning = await PlanningNetwork.addPlanning(periodId);
        }

        if (item.planning != null) {
          final PlanningResponseModel planning = item.planning!;

          if (planning.categoryIds != null) {
            final categoriesMap = await Supabase.instance.client
                .from('categories')
                .select('id, name, icon, percent')
                .inFilter('id', item.planning!.categoryIds!);

            if (categoriesMap.isNotEmpty) {
              for (var i in categoriesMap) {
                categories.add(CategoryResponse.fromJson(i));
              }
            }
          }

          if (categories.isNotEmpty && planning.categoryIds != null && planning.expenses != null && planning.expenses!.isNotEmpty) {
            var categoryPlannings = <CategoryResponse>[];

            for (var category in categories.where((element) => planning.categoryIds!.contains(element.id))) {
              final CategoryResponse itemCategory = category;
              category.expenses = planning.expenses?.where((expense) => (planning.id == expense.planningId && expense.categoryId == itemCategory.id)).toList();
              categoryPlannings.add(itemCategory);
            }

            planning.categories = categoryPlannings.map((e) => CategoryResponse.fromJson(e.toJson())).toList();
            planning.expenses = null;
            item.planning = planning;
            categoryPlannings = [];
          }
        }

        return item;
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return null;
  }

  static Future<PlanningResponseModel?> addPlanning(int periodId) async {
    try {
      final response = await Supabase.instance.client.from('plannings').insert({}).select('id');

      if (response.isNotEmpty) {
        final PlanningResponseModel planning = PlanningResponseModel.fromJson(response.single);

        await Supabase.instance.client
            .from('periods')
            .update({'planning_id': planning.id})
            .eq('id', periodId);

        return planning;
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return null;
  }

  static Future<List<CategoryResponse>> getCategories(int id) async {
    var items = <CategoryResponse>[];

    try {
      final response = await Supabase.instance.client
          .from('categories')
          .select('id, name, icon, percent');

      if (response.isNotEmpty) {
        var categoryInts = <int>[];

        for (var i in response) {
          final CategoryResponse item = CategoryResponse.fromJson(i);
          categoryInts.add(item.id);
        }

        final expenseResponse = await Supabase.instance.client
            .from('expenses')
            .select('id, category_id, planning_id, name, price, created_at')
            .inFilter('category_id', categoryInts)
            .eq('planning_id', id);

        for (var i in response) {
          final CategoryResponse item = CategoryResponse.fromJson(i);

          if (expenseResponse.isNotEmpty) {
            var expenseList = <ExpenseResponse>[];

            for (var expense in expenseResponse) {
              final ExpenseResponse expenseItem = ExpenseResponse.fromJson(expense);

              if (expenseItem.categoryId == item.id) {
                expenseList.add(expenseItem);
              }
            }

            item.expenses = expenseList;
          }

          items.add(item);
        }
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return items;
  }
}