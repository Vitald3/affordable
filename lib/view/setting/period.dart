import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/setting/period.dart';
import '../../model/period_response_model.dart';
import '../../utils/constant.dart';
import '../../utils/extension.dart';
import '../../utils/pie_chart.dart';

class PeriodView extends StatelessWidget {
  const PeriodView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PeriodController>(
        init: PeriodController(),
        builder: (controller) => Scaffold(
          appBar: Get.arguments != null && (Get.arguments['title'] ?? false) ? AppBar(
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              scrolledUnderElevation: 0,
              title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'text_period',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400
                            ),
                          ).tr()
                        ],
                      ),
                      GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                              height: 40,
                              width: 40,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                              alignment: Alignment.center,
                              child: const Icon(Icons.arrow_back_ios, size: 16)
                          )
                      )
                    ],
                  )
              )
          ) : null,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  if (Get.arguments == null || !(Get.arguments?['title'] ?? false)) const SizedBox(height: 30),
                  if (Get.arguments == null || !(Get.arguments?['title'] ?? false)) Row(
                    children: [
                      const Text(
                        'text_period',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color(0xFF4E4E4E),
                            fontSize: 28,
                            fontWeight: FontWeight.w400
                        ),
                      ).tr()
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: PieChart(
                      data: controller.periods.isNotEmpty ? List<PieChartData>.generate(controller.periods.length + 1, (index) {
                        return PieChartData(index == 0 ? Get.isDarkMode ? Colors.transparent : Colors.white : getColors(index == 1 ? index-1 : index), index == 0 ? 10 : (90 / controller.periods.length));
                      }) : const [
                        PieChartData(Colors.white, 10),
                        PieChartData(Color(0xFFD8D8D8), 90)
                      ],
                      radius: 136,
                      child: controller.periods.isNotEmpty ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(controller.periods.length, (index) {
                          final PeriodResponseModel item = controller.periods[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    controller.goEdit(item);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 9,
                                        height: 9,
                                        decoration: ShapeDecoration(
                                          color: getColors(index),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 46,
                                            child: Text(
                                              '${item.day}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 36,
                                                  fontWeight: FontWeight.w300
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          SizedBox(
                                            width: 80,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.name,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w700,
                                                      height: 1
                                                  ),
                                                ),
                                                Text(
                                                  convertPrice(double.parse('${item.price}')),
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w300
                                                  ),
                                                )
                                              ],
                                            )
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                if (controller.periods.length > index) const Divider(thickness: .1, height: .1)
                              ],
                            )
                          );
                        })
                      ) : null,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'text_day_get_d',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : const Color(0xFF7E7D84),
                      fontSize: 13,
                      fontWeight: FontWeight.w300
                    ),
                  ).tr(),
                  const SizedBox(height: 30),
                  if (controller.periods.length < 4) ElevatedButton(
                    onPressed: () async {
                      controller.edit.value = 0;
                      Get.toNamed('/period_edit')?.then((value) => controller.getPeriods());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      minimumSize: Size(Get.width-44, 60),
                      elevation: 0,
                      alignment: Alignment.center,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(width: 1, color: primaryColor)
                      ),
                    ),
                    child: const Text(
                      'text_add_period',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400
                      ),
                    ).tr()
                  ),
                  if (controller.periods.isNotEmpty && controller.periods.length < 4) const SizedBox(height: 15),
                  if (controller.periods.isNotEmpty && Get.arguments == null) ElevatedButton(
                    onPressed: () async {
                      Get.toNamed('/planning');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      minimumSize: Size(Get.width-44, 60),
                      elevation: 0,
                      alignment: Alignment.center,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(width: 1, color: primaryColor)
                      ),
                    ),
                    child: const Text(
                      'text_save',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400
                      ),
                    ).tr()
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}