import 'package:affordable/utils/constant.dart';
import 'package:affordable/view/setting/menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller/chart/chart.dart';
import '../../model/chart_formula_response_model.dart';
import '../../model/chart_point_model.dart';
import '../../model/chart_response_model.dart';
import '../../utils/dimensions.dart';
import '../../utils/extension.dart';
import '../bottom_navigation_view.dart';
import 'chart_edit.dart';
import 'chart_widget.dart';

class ChartView extends StatelessWidget {
  const ChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChartController>(
        init: ChartController(),
        builder: (controller) => Scaffold(
            key: controller.scaffoldKey,
            drawer: MenuView(scaffoldKey: controller.scaffoldKey, type: 4),
            drawerEnableOpenDragGesture: false,
            body: SafeArea(
                child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                          automaticallyImplyLeading: false,
                          elevation: 0,
                          titleSpacing: 0,
                          scrolledUnderElevation: 0,
                          expandedHeight: 118,
                          floating: true,
                          flexibleSpace: FlexibleSpaceBar(
                              collapseMode: CollapseMode.pin,
                              background: Padding(
                                  padding: const EdgeInsets.only(left: 18, right: 18, top: 18),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                controller.scaffoldKey.currentState?.openDrawer();
                                              },
                                              child: SvgPicture.asset('assets/icons/setting2.svg', colorFilter: Get.isDarkMode ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null, semanticsLabel: 'Setting', width: 31, height: 31)
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 9),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'text_chart',
                                            style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.w400
                                            ),
                                          ).tr(),
                                          InkWell(
                                              onTap: () => Get.to(() => const ChartEditView())?.then((value) => controller.initialize()),
                                              child: SvgPicture.asset('assets/icons/plus.svg', semanticsLabel: 'Add chart', width: 31, height: 31)
                                          )
                                        ],
                                      )
                                    ],
                                  )
                              )
                          )
                      ),
                      SliverList(delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                        return Obx(() => controller.isLoading.value ? Padding(
                            padding: const EdgeInsets.all(18),
                            child: controller.charts.isNotEmpty && controller.items.isNotEmpty ? Wrap(
                                alignment: WrapAlignment.center,
                                runSpacing: 28,
                                spacing: 57,
                                children: List.generate(controller.charts.length, (index) {
                                  final ChartResponseModel item = controller.charts[index];

                                  return Container(
                                      decoration: BoxDecoration(
                                          color: Get.isDarkMode ? Colors.transparent : Colors.white,
                                          border: Border.all(
                                              color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFF2F2F2),
                                              width: 1
                                          ),
                                          borderRadius: const BorderRadius.all(Radius.circular(10))
                                      ),
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                              onTap: () => Get.to(() => ChartEditView(chart: item))?.then((value) => controller.initialize()),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(item.name),
                                                  (item.type ?? 0) == 0 ? const Text('text_day').tr() : GestureDetector(
                                                    onTap: () => openChartSheet(context, controller, item.id, item.formulaList),
                                                    child: Text(controller.getView(item.type ?? 0, item.formulaList), style: const TextStyle(color: primaryColor)).tr(),
                                                  )
                                                ]
                                              )
                                          ),
                                          Divider(color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFF2F2F2)),
                                          SizedBox(
                                            width: double.infinity,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Wrap(spacing: 12, children: List.generate(item.formulaList!.length, (index) {
                                                return Row(
                                                  mainAxisSize: MainAxisSize.min,
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
                                                    Text(controller.changeShort(item.type ?? 1, item.formulaList![index]), style: const TextStyle(fontSize: 12))
                                                  ]
                                                );
                                              }))
                                            )
                                          ),
                                          const SizedBox(height: 11),
                                          SizedBox(
                                            width: double.infinity,
                                            height: 140,
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  if (item.leftLabels != null && item.leftLabels!.isNotEmpty) Padding(
                                                      padding: const EdgeInsets.only(bottom: 17),
                                                      child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: List.generate(item.leftLabels!.length, (index) => Flexible(
                                                              child: Text(item.leftLabels![index], style: TextStyle(color: Get.isDarkMode ? Colors.white : const Color(0xFF7E7D84), fontSize: 9, fontWeight: FontWeight.w200))
                                                          ))
                                                      )
                                                  ),
                                                  const SizedBox(width: Dimensions.regular),
                                                  if (item.bottomLabels != null) Expanded(
                                                      child: Container(
                                                        width: double.infinity,
                                                        decoration: BoxDecoration(color: Get.isDarkMode ? Colors.transparent : Colors.white),
                                                        clipBehavior: Clip.hardEdge,
                                                        child: item.bottomLabels!.length <= 6 ? Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              if (controller.items.length - 1 >= index) Expanded(
                                                                  child: SizedBox.expand(
                                                                      child: ChartWidget(
                                                                          points: controller.items[index],
                                                                          type: item.type ?? 1,
                                                                          onPointTap: (ChartPointModel val, int i) {
                                                                            int? vertical;

                                                                            for (var items in controller.items[index]) {
                                                                              for (var (x, element) in items.indexed) {
                                                                                if (element.id == val.id) {
                                                                                  vertical = x;
                                                                                } else {
                                                                                  element.selected = false;
                                                                                }
                                                                              }
                                                                            }

                                                                            for (var (x3, items2) in controller.items[index].indexed) {
                                                                              for (var (x4, element2) in items2.indexed) {
                                                                                if (vertical != null && vertical == x4) {
                                                                                  element2.selected = val.selected;

                                                                                  if (x3 != i) {
                                                                                    item.formulaList![x3].price = (val.selected ?? false) ? element2.value : 0.0;
                                                                                  }
                                                                                }
                                                                              }
                                                                            }

                                                                            item.formulaList![i].price = (val.selected ?? false) ? val.value : 0.0;
                                                                            controller.update();
                                                                          }
                                                                      )
                                                                  )
                                                              ),
                                                              const SizedBox(height: 3),
                                                              if (item.bottomLabels != null && item.bottomLabels!.isNotEmpty) Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: List.generate(item.bottomLabels!.length, (index) => Flexible(
                                                                      child: Text(item.bottomLabels![index], overflow: TextOverflow.ellipsis, style: TextStyle(color: Get.isDarkMode ? Colors.white : const Color(0xFF7E7D84), fontSize: 9, fontWeight: FontWeight.w200))
                                                                  ))
                                                              ),
                                                            ]
                                                        ) : SingleChildScrollView(
                                                            controller: controller.scrolls[index].value,
                                                            scrollDirection: Axis.horizontal,
                                                            child: SizedBox(
                                                              width: item.bottomLabels!.length * (((item.type ?? 1) != 3) ? 26 : 60),
                                                              child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    if (controller.items.length - 1 >= index) Expanded(
                                                                        child: SizedBox.expand(
                                                                            child: ChartWidget(
                                                                                points: controller.items[index],
                                                                                type: item.type ?? 1,
                                                                                onPointTap: (ChartPointModel val, int i) {
                                                                                  int? vertical;

                                                                                  for (var items in controller.items[index]) {
                                                                                    for (var (x, element) in items.indexed) {
                                                                                      if (element.id == val.id) {
                                                                                        vertical = x;
                                                                                      } else {
                                                                                        element.selected = false;
                                                                                      }
                                                                                    }
                                                                                  }

                                                                                  for (var (x3, items2) in controller.items[index].indexed) {
                                                                                    for (var (x4, element2) in items2.indexed) {
                                                                                      if (vertical != null && vertical == x4) {
                                                                                        element2.selected = val.selected;

                                                                                        if (x3 != i) {
                                                                                          item.formulaList![x3].price = (val.selected ?? false) ? element2.value : 0.0;
                                                                                        }
                                                                                      }
                                                                                    }
                                                                                  }

                                                                                  item.formulaList![i].price = (val.selected ?? false) ? val.value : 0.0;
                                                                                  controller.update();
                                                                                }
                                                                            )
                                                                        )
                                                                    ),
                                                                    const SizedBox(height: 3),
                                                                    if (item.bottomLabels!.isNotEmpty) Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: List.generate(item.bottomLabels!.length, (index) => (item.type ?? 1) == 3 ? Flexible(
                                                                            child: Text(item.bottomLabels![index], textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: TextStyle(color: Get.isDarkMode ? Colors.white : const Color(0xFF7E7D84), fontSize: 7, fontWeight: FontWeight.w200))
                                                                        ) : Container(
                                                                            width: index == 0 ? 0 : 20,
                                                                            margin: EdgeInsets.only(right: index == 0 ? 11 : 0),
                                                                            child: Text(item.bottomLabels![index], textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: TextStyle(color: Get.isDarkMode ? Colors.white : const Color(0xFF7E7D84), fontSize: 9, fontWeight: FontWeight.w200))
                                                                        ))
                                                                    ),
                                                                  ]
                                                              )
                                                            )
                                                        )
                                                      )
                                                  )
                                                ]
                                            ),
                                          )
                                        ],
                                      )
                                  );
                                })
                            ) : const Text(
                              'text_chart_empty',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400
                              ),
                            ).tr()
                        ) : Container(
                            width: double.infinity,
                            height: Get.height/2-106,
                            alignment: Alignment.bottomCenter,
                            child: const SizedBox(
                                width: 26,
                                height: 26,
                                child: CircularProgressIndicator(color: primaryColor)
                            )
                        ));
                      }, childCount: 1))
                    ]
                )
            ),
            bottomNavigationBar: BottomNavigationView()
        ));
  }

  void openChartSheet(BuildContext context, ChartController controller, int id, List<ChartFormulaResponseModel>? formulaList) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        builder: (context) {
          return Container(
              padding: EdgeInsets.only(
                  bottom: Get.mediaQuery.viewInsets.bottom
              ),
              decoration: BoxDecoration(
                color: Get.isDarkMode ? Colors.black : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Get.isDarkMode ? Colors.white : const Color(0x29000000),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Wrap(
                children: [
                  Container(
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color(0xFFF2F2F2)))
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(Icons.arrow_back_ios, size: 16)
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'text_select_view',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400
                                  ),
                                ).tr()
                              ]
                          )
                        ],
                      )
                  ),
                  if (controller.getViewDay(formulaList)) InkWell(
                      onTap: () => controller.setView(context, id, 0),
                      child: Container(
                          decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color(0xFFF2F2F2)))
                          ),
                          alignment: Alignment.center,
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'text_day',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400
                                ),
                              ).tr()
                            ],
                          )
                      )
                  ),
                  InkWell(
                      onTap: () => controller.setView(context, id, 1),
                      child: Container(
                          decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color(0xFFF2F2F2)))
                          ),
                          alignment: Alignment.center,
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'text_month',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400
                                ),
                              ).tr()
                            ],
                          )
                      )
                  ),
                  InkWell(
                      onTap: () => controller.setView(context, id, 2),
                      child: Container(
                          decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color(0xFFF2F2F2)))
                          ),
                          alignment: Alignment.center,
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'text_year',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400
                                ),
                              ).tr()
                            ],
                          )
                      )
                  ),
                  InkWell(
                      onTap: () => controller.setView(context, id, 3),
                      child: Container(
                          decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color(0xFFF2F2F2)))
                          ),
                          alignment: Alignment.center,
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          margin: const EdgeInsets.only(bottom: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'text_period_chart',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400
                                ),
                              ).tr()
                            ],
                          )
                      )
                  )
                ],
              )
          );
        }
    );
  }
}