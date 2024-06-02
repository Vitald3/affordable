import '../main.dart';
import '../utils/constant.dart';
import 'expense_response.dart';

class CategoryResponse {
  late int id;
  late String icon;
  late String name;
  late bool percent;
  List<ExpenseResponse>? expenses;

  CategoryResponse({
    required this.id,
    required this.icon,
    required this.name,
    required this.percent,
    this.expenses
  });

  jsonStringToMap(String data) {
    if (!data.contains('{')) {
      return data;
    }

    List<String> str = data.replaceAll("{","").replaceAll("}","").replaceAll("\"","").replaceAll("'","").split(",");
    Map<String, dynamic> result = {};

    for (int i = 0; i < str.length; i++) {
      List<String> s = str[i].split(":");

      if (s.isNotEmpty) {
        result.putIfAbsent(s[0].trim(), () => s[1].trim());
      }
    }

    return result['${prefs?.getInt('languageId') ?? languagesList.first.id}'];
  }

  CategoryResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    icon = json['icon'];
    name = jsonStringToMap(json['name']);
    percent = json['percent'];
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
    data['icon'] = icon;
    data['name'] = name;
    data['percent'] = percent;
    if (expenses != null) {
      data['expenses'] = expenses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}