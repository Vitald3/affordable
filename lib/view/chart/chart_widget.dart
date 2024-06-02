import 'package:flutter/material.dart';
import '../../model/chart_point_model.dart';
import '../../utils/dimensions.dart';
import '../../utils/extension.dart';
import 'package:collection/collection.dart';
import '../../utils/line_painter.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key, required this.points, required this.type, required this.onPointTap});

  final List<List<ChartPointModel>> points;
  final int type;
  final void Function(ChartPointModel, int)? onPointTap;

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double chartWidth = constraints.maxWidth - Dimensions.regular * 2;
        double chartHeight = constraints.maxHeight - Dimensions.tappable / 2 - Dimensions.regular * 2 + 12;
        double min = widget.points.map((point) => point.map((e) => e.value).min).min;
        double max = widget.points.map((point) => point.map((e) => e.value).max).max;
        double yFactor = max == min ? max : max - min;

        return Stack(
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.regular),
                  width: double.infinity,
                  height: double.infinity,
                  child: CustomPaint(
                      painter: LineChartPainter(
                          context,
                          widget.points
                      )
                  )
              ),
              for (int i = 0; i < widget.points.length; i++)
                Builder(builder: (BuildContext context) {
                  return Stack(
                    children: List.generate(widget.points[i].length, (i2) {
                      double value = widget.points.reversed.toList()[i][i2].value;
                      value = yFactor == 0 ? 0 : chartHeight - ((max - value) / yFactor) * chartHeight;
                      double top = constraints.maxHeight - value - Dimensions.regular - Dimensions.tappable / 2;

                      if (value == 0.0) {
                        top = chartHeight - Dimensions.regular;
                      }

                      return Positioned(
                          left: (((chartWidth / (widget.points[i].length - 1)).isInfinite ? chartWidth / 2.0 : i2 * (chartWidth / (widget.points[i].length - 1))) - Dimensions.tappable / 2.0 + Dimensions.tappable) - 20,
                          top: top,
                          child: SizedBox(
                            width: Dimensions.tappable,
                            height: Dimensions.tappable,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AnimatedScale(
                                  scale: widget.points.reversed.toList()[i][i2].selected ?? false ? 1.5 : 1.0,
                                  curve: Curves.ease,
                                  duration: const Duration(milliseconds: 250),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: getColors(widget.points.length - (i + 1), reset: true),
                                        border: Border.all(color: Colors.white, width: 1),
                                        borderRadius: BorderRadius.circular(Dimensions.regular / 2.0),
                                      ),
                                      width: Dimensions.regular,
                                      height: Dimensions.regular
                                  ),
                                ),
                                InkResponse(
                                  radius: Dimensions.regular * 1.5,
                                  onTap: () => onTap(widget.points.reversed.toList()[i][i2], widget.points.length - (i + 1)),
                                ),
                              ],
                            ),
                          )
                      );
                    })
                  );
                }),
            ]
        );
      },
    );
  }

  void onTap(ChartPointModel point, int index) {
    point.selected = !(point.selected ?? false);
    setState(() {});
    widget.onPointTap?.call(point, index);
  }
}