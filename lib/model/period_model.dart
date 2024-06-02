class PeriodModel {
  late String name;
  late int day;
  late int price;
  late bool ever;

  PeriodModel({
    required this.name,
    required this.day,
    required this.price,
    required this.ever
  });

  PeriodModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    day = json['day'];
    price = json['price'];
    ever = json['ever'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['day'] = day;
    data['price'] = price;
    data['ever'] = ever;
    return data;
  }
}