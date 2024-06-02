class ChartFormulaResponseModel {
  late int id;
  late int chartId;
  late String formula;
  late String formulaText;
  double? price;

  ChartFormulaResponseModel({
    required this.id,
    required this.chartId,
    required this.formula,
    required this.formulaText,
    this.price
  });

  ChartFormulaResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chartId = json['chart_id'];
    formula = json['formula'];
    formulaText = json['formula_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['chart_id'] = chartId;
    data['formula'] = formula;
    data['formula_text'] = formulaText;
    return data;
  }
}