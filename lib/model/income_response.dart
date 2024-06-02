class IncomeResponseModel {
  late int id;
  late String name;
  late int price;
  late int periodId;
  late int categoryId;
  int? expenseId;
  late bool salary;
  late bool unplanned;
  late DateTime date;

  IncomeResponseModel({
    required this.id,
    required this.name,
    required this.price,
    required this.periodId,
    required this.categoryId,
    required this.expenseId,
    required this.salary,
    required this.unplanned,
    required this.date
  });

  IncomeResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    periodId = json['period_id'];
    categoryId = json['category_id'];
    expenseId = json['expense_id'];
    salary = json['salary'];
    unplanned = json['unplanned'];
    date = DateTime.parse(json['created_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['period_id'] = periodId;
    data['category_id'] = categoryId;
    data['expense_id'] = expenseId;
    data['salary'] = salary;
    data['unplanned'] = unplanned;
    data['created_at'] = date;
    return data;
  }
}