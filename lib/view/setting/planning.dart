import 'package:affordable/view/setting/planning_edit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller/setting/planning.dart';
import '../../model/category_response.dart';
import '../../model/period_response_model.dart';
import '../../utils/constant.dart';
import '../../utils/extension.dart';
import 'category_edit.dart';

class PlanningView extends StatelessWidget {
  const PlanningView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlanningController>(
        init: PlanningController(),
        builder: (controller) => Scaffold(
          appBar: Get.arguments != null && (Get.arguments['title'] ?? false) ? AppBar(
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              scrolledUnderElevation: 0,
              title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      const SizedBox(height: 28),
                      Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'text_planning',
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
                      ),
                      const SizedBox(height: 28)
                    ]
                  )
              )
          ) : null,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (Get.arguments == null || !(Get.arguments?['title'] ?? false)) const SizedBox(height: 30),
                    if (Get.arguments == null || !(Get.arguments?['title'] ?? false)) InkWell(
                      onTap: () => controller.getPeriods(),
                      child: const Text(
                        'text_planning',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w400
                        ),
                      ).tr()
                    ),
                    const SizedBox(height: 22),
                    if (controller.periods.isNotEmpty) Wrap(runSpacing: 11, children: List.generate(controller.periods.length, (index) {
                      final PeriodResponseModel period = controller.periods[index];

                      return Container(
                          width: double.infinity,
                          decoration: ShapeDecoration(
                            color: Get.isDarkMode ? const Color(0xFF2B3034) : Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFECF2F2)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => Get.to(() => PlanningEditView(id: period.planning?.id ?? 0, periodId: period.id))?.then((value) => controller.getPeriods()),
                                child: Container(
                                    width: double.infinity,
                                    height: 45,
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                        color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFECF2F2),
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFE4E8E9),
                                                width: 1
                                            )
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        )
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${period.name} ${convertPrice(double.parse('${period.price}'))}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Get.isDarkMode ? Colors.white : secondColor,
                                              fontFamily: 'Poppins'
                                          ),
                                        ),
                                        SvgPicture.asset('assets/icons/edit.svg', colorFilter: Get.isDarkMode ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null, semanticsLabel: 'Edit', width: 19, height: 18),
                                      ],
                                    )
                                ),
                              ),
                              if (controller.categories.isNotEmpty) Column(
                                children: List.generate(controller.categories.length, (index) {
                                  final CategoryResponse category = controller.categories[index];
                                  final item = period.planning?.categories?[index];
                                  final double expensePrice = item?.expenses != null ? item!.expenses!.map((e) => e.price).fold(0.0, (a, b) => a + b) : 0.0;

                                  return Container(
                                      color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFECF2F2),
                                      padding: const EdgeInsets.symmetric(horizontal: 18),
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Get.isDarkMode ? Colors.transparent : const Color(0xFFECF2F2),
                                            border: controller.categories.length-1 > index ? Border(
                                                bottom: BorderSide(
                                                    color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFE4E8E9),
                                                    width: 1
                                                )
                                            ) : null,
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          child: InkWell(
                                              onTap: () => Get.to(() => CategoryEditView(id: period.planning?.id ?? 0, periodId: period.id, selectCategoryId: category.id))?.then((value) => controller.getPeriods()),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        width: 9,
                                                        height: 9,
                                                        decoration: ShapeDecoration(
                                                          color: getColors(index),
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 11),
                                                      Text(
                                                        category.name,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Get.isDarkMode ? Colors.white : secondColor,
                                                            fontWeight: FontWeight.w400
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Text(
                                                    convertPrice(category.percent ? ((expensePrice / 100) * period.price) : expensePrice),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400
                                                    ),
                                                  ),
                                                ],
                                              )
                                          )
                                      )
                                  );
                                }),
                              ),
                              Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'text_total',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Get.isDarkMode ? Colors.white : secondColor,
                                                fontFamily: 'Poppins'
                                            ),
                                          ).tr(),
                                          Text(
                                            convertPrice(controller.calculate(period).first),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Get.isDarkMode ? Colors.white : secondColor,
                                                fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'text_today',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Get.isDarkMode ? Colors.white : secondColor,
                                                fontFamily: 'Poppins'
                                            ),
                                          ).tr(),
                                          Text(
                                            convertPrice(controller.calculate(period).last),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Get.isDarkMode ? Colors.white : secondColor,
                                                fontWeight: FontWeight.w600
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                              ),
                            ],
                          )
                      );
                    })),
                    const SizedBox(height: 27),
                    if (controller.periods.isNotEmpty) Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'text_total',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400
                            ),
                          ).tr(),
                          Text(
                            convertPrice(controller.calculateAll().first),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      )
                    ),
                    const SizedBox(height: 24),
                    if (controller.periods.isNotEmpty && Get.arguments == null) ElevatedButton(
                      onPressed: () {
                        if (controller.save) {
                          controller.nextOpen();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !controller.save ? const Color(0xFFEFEFEF) : primaryColor,
                        minimumSize: Size(Get.width-36, 60),
                        elevation: 0,
                        alignment: Alignment.center,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(width: 1, color: !controller.save ? const Color(0xFFEFEFEF) : primaryColor)
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
                  ]
              ),
            ),
          ),
        ));
  }
}