class AwardResponseModel {
  late int id;
  late String award;

  AwardResponseModel({
    required this.id,
    required this.award
  });

  AwardResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    award = json['award'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['award'] = award;
    return data;
  }
}