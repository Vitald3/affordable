import 'chart_formula_response_model.dart';

class ChartResponseModel {
  late int id;
  late String name;
  List<ChartFormulaResponseModel>? formulaList;
  int? type;
  List<String>? leftLabels;
  List<String>? bottomLabels;

  ChartResponseModel({
    required this.id,
    required this.name,
    required this.formulaList,
    this.type,
    this.leftLabels,
    this.bottomLabels
  });

  ChartResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];

    if (json['chart_formula'] != null) {
      formulaList = <ChartFormulaResponseModel>[];

      json['chart_formula'].forEach((v) {
        formulaList!.add(ChartFormulaResponseModel.fromJson(v));
      });
    }

    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (formulaList != null) {
      data['chart_formula'] = formulaList!.map((v) => v.toJson()).toList();
    }
    data['type'] = type;
    return data;
  }
}