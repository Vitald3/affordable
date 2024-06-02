class ShareResponseModel {
  late int id;
  late String email;
  String? uuid;

  ShareResponseModel({
    required this.id,
    required this.email,
    this.uuid
  });

  ShareResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['uuid'] = uuid;
    return data;
  }
}