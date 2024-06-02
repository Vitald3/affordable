class NotificationResponseModel {
  late int id;
  late int type;

  NotificationResponseModel({
    required this.id,
    required this.type
  });

  NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    return data;
  }
}