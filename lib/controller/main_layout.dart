import 'package:affordable/controller/dashboard/dashboard.dart';
import 'package:affordable/view/dashboard/dashboard_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../utils/extension.dart';
import '../view/award/award.dart';
import '../view/calendar/calendar.dart';
import '../view/chart/chart.dart';
import '../view/dashboard/income_edit.dart';

class MainLayoutController extends GetxController {
  DashboardController? dashboardController;
  final Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
    3: GlobalKey<NavigatorState>(),
    4: GlobalKey<NavigatorState>()
  };

  final List<Widget> widgetOptions = <Widget>[
    const DashBoardView(),
    const ChartView(),
    const SizedBox.shrink(),
    const CalendarView(),
    const AwardView()
  ];

  int activeTab = 0;

  void setController(DashboardController controller) {
    dashboardController = controller;
  }

  void setActiveIndex(int index) {
    activeTab = index;

    if (index == 2 && dashboardController != null) {
      final String date = DateFormat('dd.MM.y').format(DateTime.now());
      final List<dynamic>? toDay = dashboardController!.tables.firstWhereOrNull((element) => element[0] == date);
      Get.to(() => IncomeEditView(date: date, priceToDay: toDay != null ? toDay[3] ?? 0 : 0, incomes: dashboardController!.incomes, incomeId: 0, categoryId: null, periodId: dashboardController!.periodId.value, planPrice: null, expenseId: 0, color: getColors(0), expenses: dashboardController!.expenses))?.then((value) => dashboardController!.initialize());
    } else {
      update();
    }
  }
}