import 'package:affordable/utils/constant.dart';
import 'package:affordable/view/setting/menu.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller/calendar/calendar.dart';
import '../bottom_navigation_view.dart';
import 'extract.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late ScrollController controllerScroll;
  bool isVisibleMy = false;

  @override
  void dispose() {
    super.dispose();
    controllerScroll.dispose();
  }

  @override
  void initState() {
    controllerScroll = ScrollController();
    controllerScroll.addListener(() {
      int countYears = Get.find<CalendarController>().listCalendars.length;

      var heightMonth = controllerScroll.positions.last.maxScrollExtent / (12 * countYears);

      var curPre = ((controllerScroll.positions.last.maxScrollExtent - heightMonth) / 100).toStringAsFixed(0);
      var curLast = (controllerScroll.offset / 100).toStringAsFixed(0);

      if (controllerScroll.offset == 0) {
        if (isVisibleMy == true) return;

        setState(() {
          isVisibleMy = true;
        });

        Future.delayed(const Duration(milliseconds: 700)).then((val) {
          Get.find<CalendarController>()
              .addYearToFirstPlace()
              .then((val) {})
              .then((fd) {
            setState(() {
              isVisibleMy = false;
            });
          }).then((vall) {
            controllerScroll.jumpTo(heightMonth * 11);
          });
        });
      }

      if (curPre == curLast) {
        if (isVisibleMy == true) return;

        setState(() {
          isVisibleMy = true;
        });

        Future.delayed(const Duration(milliseconds: 700)).then((val) {
          Get.find<CalendarController>().addYear().then((val) {}).then((fd) {
            setState(() {
              isVisibleMy = false;
            });
          });
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalendarController>(
        init: CalendarController(),
        builder: (controller) {
          return Scaffold(
              key: controller.scaffoldKey,
              drawer: MenuView(scaffoldKey: controller.scaffoldKey, type: 3),
              drawerEnableOpenDragGesture: false,
              body: Stack(
                children: [
                  SafeArea(
                      child: CustomScrollView(
                          controller: controllerScroll,
                          slivers: [
                            SliverAppBar(
                                automaticallyImplyLeading: false,
                                elevation: 0,
                                titleSpacing: 0,
                                scrolledUnderElevation: 0,
                                expandedHeight: 118,
                                snap: false,
                                floating: true,
                                pinned: false,
                                flexibleSpace: FlexibleSpaceBar(
                                    collapseMode: CollapseMode.pin,
                                    background: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 18,
                                            right: 18,
                                            top: 18,
                                            bottom: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      controller
                                                          .scaffoldKey.currentState
                                                          ?.openDrawer();
                                                    },
                                                    child: SvgPicture.asset(
                                                        'assets/icons/setting2.svg',
                                                        colorFilter: Get.isDarkMode ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null,
                                                        semanticsLabel: 'Setting',
                                                        width: 31,
                                                        height: 31))
                                              ],
                                            ),
                                            const SizedBox(height: 9),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                    child: const Text(
                                                      'text_calendar',
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 28,
                                                          fontWeight: FontWeight.w400),
                                                    ).tr()),
                                                InkWell(
                                                    onTap: () {
                                                      Scrollable.ensureVisible(
                                                          controller.dataKey
                                                              .currentContext!,
                                                          duration: const Duration(
                                                              milliseconds: 600));
                                                    },
                                                    child: SvgPicture.asset(
                                                        'assets/icons/calendar2.svg',
                                                        colorFilter: Get.isDarkMode ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null,
                                                        semanticsLabel: 'Calendar',
                                                        width: 31,
                                                        height: 31))
                                              ]
                                            )
                                          ]
                                        )
                                    )
                                )
                            ),
                            SliverList(
                                delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                      return Obx(() => controller.isLoading.value
                                          ? Column(
                                        children: [
                                          ...controller.listCalendars
                                              .mapIndexed((index, cal) {
                                            if (controller.prevYears > 0 &&
                                                controller.prevYears > index) {
                                              return buildCalendarInPadding(
                                                  controller: controller,
                                                  now: controller.now.subtract(
                                                      Duration(
                                                          days: 365 * (index + 1))),
                                                  calendar: cal);
                                            } else if (controller.prevYears ==
                                                index) {
                                              return buildCalendarInPadding(
                                                  controller: controller,
                                                  now: controller.now,
                                                  calendar: cal);
                                            } else {
                                              return buildCalendarInPadding(
                                                  controller: controller,
                                                  now: controller.now.add(
                                                      Duration(days: 365 * index)),
                                                  calendar: cal);
                                            }
                                          })
                                        ],
                                      ) : Container(
                                          width: double.infinity,
                                          height: Get.height / 2 - 106,
                                          alignment: Alignment.bottomCenter,
                                          child: const SizedBox(
                                              width: 26,
                                              height: 26,
                                              child: CircularProgressIndicator(
                                                  color: primaryColor)))
                                      );
                                    }, childCount: 1))
                          ])),
                  isVisibleMy ? const Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(child: CircularProgressIndicator())
                  ) : const SizedBox.shrink()
                ]
              ),
              bottomNavigationBar: BottomNavigationView());
        });
  }
}
