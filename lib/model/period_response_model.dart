import 'package:affordable/model/planning_response_model.dart';

class PeriodResponseModel {
  late int id;
  late String name;
  late int day;
  late int price;
  late int planningId;
  late String uuid;
  late bool ever;
  PlanningResponseModel? planning;

  PeriodResponseModel({
    required this.id,
    required this.name,
    required this.day,
    required this.price,
    required this.planningId,
    required this.uuid,
    required this.ever,
    this.planning
  });

  PeriodResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    day = json['day'];
    price = json['price'];
    planningId = json['planning_id'] ?? 0;
    uuid = json['uuid'];
    ever = json['ever'];
    if (json['plannings'] != null) {
      planning = PlanningResponseModel.fromJson(json['plannings']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['day'] = day;
    data['price'] = price;
    data['planning_id'] = planningId;
    data['uuid'] = uuid;
    data['ever'] = ever;
    data['plannings'] = planning;
    return data;
  }
}