class PayResponseModel {
  late int id;
  late String uuid;
  late DateTime date;
  late bool pay;
  late int day;

  PayResponseModel({
    required this.id,
    required this.uuid,
    required this.date,
    required this.pay,
    required this.day
  });

  PayResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    pay = json['pay'];
    day = json['day'];
    date = DateTime.parse(json['created_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['created_at'] = date;
    data['pay'] = pay;
    data['day'] = day;
    return data;
  }
}