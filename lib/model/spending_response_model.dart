class SpendingResponseModel {
  late int id;
  late double price;
  late int periodId;
  bool? type;
  late String date;

  SpendingResponseModel({
    required this.id,
    required this.price,
    required this.periodId,
    this.type,
    required this.date
  });

  SpendingResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = double.parse('${json['price']}');
    periodId = json['period_id'];
    type = json['type'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['price'] = price;
    data['period_id'] = periodId;
    data['type'] = type;
    data['date'] = date;
    return data;
  }
}