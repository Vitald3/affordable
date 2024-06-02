class ExpenseResponse {
  late int id;
  late int categoryId;
  late int planningId;
  late String name;
  late double price;
  late DateTime date;

  ExpenseResponse({
    required this.id,
    required this.categoryId,
    required this.planningId,
    required this.name,
    required this.price,
    required this.date
  });

  ExpenseResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    planningId = json['planning_id'];
    name = json['name'];
    price = double.tryParse('${json['price']}') ?? 0.0;
    date = DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['planning_id'] = planningId;
    data['name'] = name;
    data['price'] = price;
    data['created_at'] = date;
    return data;
  }
}