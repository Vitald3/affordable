import 'category_response.dart';
import 'expense_response.dart';

class PlanningResponseModel {
  late int id;
  List<int>? categoryIds;
  List<CategoryResponse>? categories;
  List<ExpenseResponse>? expenses;

  PlanningResponseModel({
    required this.id,
    this.categoryIds,
    this.categories,
    this.expenses
  });

  PlanningResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['category_id'] != null) {
      categoryIds = json['category_id'].cast<int>();
    }
    if (json['categories'] != null) {
      categories = <CategoryResponse>[];
      json['categories'].forEach((v) {
        categories!.add(CategoryResponse.fromJson(v));
      });
    }
    if (json['expenses'] != null) {
      expenses = <ExpenseResponse>[];
      json['expenses'].forEach((v) {
        expenses!.add(ExpenseResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryIds;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (expenses != null) {
      data['expenses'] = expenses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}