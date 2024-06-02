class ChartModel {
  late String name;
  late double price;

  ChartModel({
    required this.name,
    required this.price
  });

  ChartModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['price'] = price;
    return data;
  }
}