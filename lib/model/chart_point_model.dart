class ChartPointModel {
  final int id = DateTime.now().microsecondsSinceEpoch;
  final String price;
  final double value;
  bool? selected = false;

  ChartPointModel({
    required this.price,
    required this.value,
    this.selected
  });
}