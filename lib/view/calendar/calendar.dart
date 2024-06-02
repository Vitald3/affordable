import 'package:affordable/utils/constant.dart';
import 'package:affordable/view/setting/menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller/calendar/calendar.dart';
import '../bottom_navigation_view.dart';
import '../dashboard/spending_plan_edit.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalendarController>(
        init: CalendarController(),
        builder: (controller) => Scaffold(
            key: controller.scaffoldKey,
            drawer: MenuView(scaffoldKey: controller.scaffoldKey, type: 3),
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
                                  padding: const EdgeInsets.only(left: 18, right: 18, top: 18, bottom: 20),
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
                                          Expanded(
                                            child: const Text(
                                              'text_calendar',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.w400
                                              ),
                                            ).tr()
                                          ),
                                          InkWell(
                                              onTap: () {
                                                Scrollable.ensureVisible(controller.dataKey.currentContext!, duration: const Duration(milliseconds: 600));
                                              },
                                              child: SvgPicture.asset('assets/icons/calendar2.svg', colorFilter: Get.isDarkMode ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null, semanticsLabel: 'Calendar', width: 31, height: 31)
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
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            child: LayoutBuilder(
                              builder: (context, constraint) {
                                return Wrap(
                                    alignment: WrapAlignment.center,
                                    runSpacing: 28,
                                    spacing: 57,
                                    children: List.generate(controller.calendar.length, (x) {
                                      final MapEntry<String, List<List<MapEntry<String, Map<String, dynamic>>>>> item = controller.calendar[x];
                                      bool boxStart = false;
                                      bool boxEnd = false;
                                      int boxInt = 0;

                                      return Column(
                                          key: controller.now.month - 1 == x ? controller.dataKey : null,
                                          children: [
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                LayoutBuilder(builder: (context, constraint) {
                                                  return Container(
                                                    width: constraint.maxWidth-15,
                                                    margin: const EdgeInsets.symmetric(horizontal: 22),
                                                    height: 2.5,
                                                    alignment: Alignment.center,
                                                    decoration: const BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage('assets/images/line2.png'),
                                                            fit: BoxFit.fill
                                                        )
                                                    ),
                                                  );
                                                }),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                          height: 38,
                                                          padding: const EdgeInsets.symmetric(horizontal: 14),
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(color: Get.isDarkMode ? Colors.black : Colors.white),
                                                          child: Text(
                                                            item.key,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(
                                                                fontSize: 25,
                                                                fontWeight: FontWeight.w400
                                                            ),
                                                          )
                                                      )
                                                    ]
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 31),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                              child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: List.generate(7, (index) => SizedBox(
                                                      width: 36,
                                                      child: Text(
                                                        'text_day_$index',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Get.isDarkMode ? Colors.white : const Color(0xFF4E4E4E),
                                                            fontSize: 16
                                                        ),
                                                      ).tr()
                                                  ))
                                              ),
                                            ),
                                            const SizedBox(height: 14),
                                            Column(children: List.generate(item.value.length, (index) {
                                              final row = item.value[index];

                                              return Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                                                  alignment: Alignment.center,
                                                  child: Stack(
                                                      alignment: Alignment.center,
                                                      children: [
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: List.generate(7, (rowIndex) {
                                                              BorderRadius? radius;
                                                              final itemRow = row[rowIndex];

                                                              bool start = (itemRow.value['start'] ?? false);
                                                              bool end = (itemRow.value['end'] ?? false);

                                                              if (!end && rowIndex + 1 <= row.length - 1) {
                                                                end = row[rowIndex + 1].value['start'] ?? false;
                                                              }

                                                              if (!start && rowIndex - 1 >= 0) {
                                                                start = row[rowIndex - 1].value['end'] ?? false;
                                                              }

                                                              if (start) {
                                                                boxInt = int.tryParse(itemRow.key) ?? 0;
                                                                boxStart = true;
                                                                boxEnd = false;
                                                              }

                                                              if (boxStart) {
                                                                boxEnd = boxInt == controller.periodDays.last;
                                                                boxInt = 0;
                                                              }

                                                              if (boxEnd) {
                                                                boxStart = false;
                                                              }

                                                              if (rowIndex == 0 || (rowIndex - 1 > 0 && row[rowIndex - 1].key == '') || (rowIndex == 1 && row[0].key == '') || (start && !end)) {
                                                                if (rowIndex == 6) {
                                                                  radius = const BorderRadius.all(Radius.circular(36));
                                                                } else {
                                                                  radius = const BorderRadius.only(topLeft: Radius.circular(36), bottomLeft: Radius.circular(36));
                                                                }
                                                              } else if (rowIndex == 6 || (rowIndex + 1 <= row.length - 1 && (row[rowIndex + 1].key == '' || end))) {
                                                                radius = const BorderRadius.only(topRight: Radius.circular(36), bottomRight: Radius.circular(36));
                                                              }

                                                              if (rowIndex == 0 && (end || row[rowIndex + 1].key == '')) {
                                                                radius = const BorderRadius.all(Radius.circular(36));
                                                              }

                                                              if (boxEnd && !boxStart) {
                                                                boxEnd = false;
                                                              }

                                                              return Container(
                                                                  width: ((constraint.maxWidth - 36) / 7) - (start || end ? 4 : 0),
                                                                  height: 40,
                                                                  margin: EdgeInsets.only(left: start ? 4 : 0, right: end ? 4 : 0),
                                                                  alignment: Alignment.center,
                                                                  decoration: itemRow.key != '' ? BoxDecoration(
                                                                      color: boxStart || (!boxStart && boxEnd) ? Get.isDarkMode ? const Color(0xFF232C35) : const Color(0xFFE1F5E4).withOpacity(.7) : Get.isDarkMode ? const Color(0xFF252524) : const Color(0xFFECF2F2),
                                                                      borderRadius: radius
                                                                  ) : null
                                                              );
                                                            })
                                                        ),
                                                        Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 4),
                                                            child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: List.generate(7, (rowIndex) {
                                                                  final itemRow = row[rowIndex];
                                                                  final bool start = (itemRow.value['start'] ?? false);
                                                                  final List<Color> bottom = itemRow.value['bottom'] ?? [];

                                                                  return InkWell(
                                                                      onTap: () {
                                                                        if (itemRow.key != '') {
                                                                          Get.to(() => SpendingPlanEditView(date: itemRow.value['date'], priceToDay: itemRow.value['priceToDay'] ?? 0, spendingPlanPrice: itemRow.value['spendingPlanPrice'] ?? 0.0, periodId: itemRow.value['periodId']))?.then((value) => controller.initialize(scroll: false));
                                                                        }
                                                                      },
                                                                      borderRadius: const BorderRadius.all(Radius.circular(36)),
                                                                      hoverColor: itemRow.key == '' ? Colors.transparent : null,
                                                                      child: Stack(
                                                                        alignment: Alignment.bottomCenter,
                                                                        children: [
                                                                          Container(
                                                                              width: 36,
                                                                              height: 36,
                                                                              alignment: Alignment.center,
                                                                              decoration: ShapeDecoration(
                                                                                color: itemRow.value['background'],
                                                                                shape: OvalBorder(
                                                                                  side: (itemRow.value['spendingPlanPrice'] ?? 0) > 0 ? const BorderSide(color: Color(0xFFFFBB00), width: 2) : const BorderSide(width: 0, color: Colors.transparent)
                                                                                )
                                                                              ),
                                                                              child: Text(
                                                                                itemRow.key,
                                                                                textAlign: TextAlign.center,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(
                                                                                    decoration: start ? TextDecoration.underline : null,
                                                                                    decorationColor: itemRow.value['color'],
                                                                                    color: Get.isDarkMode ? Colors.white : itemRow.value['color'],
                                                                                    fontSize: 16
                                                                                ),
                                                                              )
                                                                          ),
                                                                          if (bottom.isNotEmpty) Row(
                                                                            children: List.generate(bottom.length, (indexColor) => Container(
                                                                              width: 4,
                                                                              height: 4,
                                                                              margin: const EdgeInsets.only(bottom: 4.5),
                                                                              decoration: ShapeDecoration(
                                                                                color: bottom[indexColor],
                                                                                shape: const OvalBorder()
                                                                              ),
                                                                            ))
                                                                          )
                                                                        ]
                                                                      )
                                                                  );
                                                                })
                                                            )
                                                        )
                                                      ]
                                                  )
                                              );
                                            }))
                                          ]
                                      );
                                    })
                                );
                              },
                            )
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
}