import 'package:affordable/utils/constant.dart';
import 'package:affordable/utils/extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/expense_response.dart';
import '../../model/income_response.dart';
import '../../model/period_response_model.dart';
import '../../model/spending_response_model.dart';
import '../../network/dashboard/dashboard.dart';
import '../../network/dashboard/spending_plan.dart';
import '../../network/setting/planning.dart';

class CalendarController extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  RxBool isLoading = false.obs;
  RxBool isScroll = false.obs;
  var calendar = <MapEntry<String, List<List<MapEntry<String, Map<String, dynamic>>>>>>[];
  RxList<IncomeResponseModel> incomes = <IncomeResponseModel>[].obs;
  RxList<PeriodResponseModel> periods = <PeriodResponseModel>[].obs;
  final DateTime now = DateTime.now();
  final String nowStr = DateFormat('dd.MM.y').format(DateTime.now());
  List<SpendingResponseModel> spendings = <SpendingResponseModel>[].obs;
  List<SpendingResponseModel> spendingPlan = <SpendingResponseModel>[].obs;
  RxList<ExpenseResponse> expenses = <ExpenseResponse>[].obs;
  List<int> periodIds = <int>[].obs;
  List<int> periodDays = <int>[].obs;
  final GlobalKey dataKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  void initialize({bool scroll = true}) async {
    calendar.clear();
    spendingPlan.clear();

    if (scroll) {
      periodIds.clear();
      periods.clear();
      expenses.clear();
      incomes.clear();
      spendings.clear();
      periods.addAll(await PlanningNetwork.getPeriods(all: true));

      if (periods.isNotEmpty) {
        for (var i in periods) {
          periodIds.add(i.id);
          periodDays.add(i.day);

          if (i.planning?.expenses != null) {
            expenses.addAll(i.planning!.expenses!.toList());
          }
        }
      } else {
        Get.offAllNamed('/period');
      }

      incomes.addAll(await DashboardNetwork.getAllIncomes(periodIds));
      spendings.addAll(await DashboardNetwork.getSpendingsAll(periodIds));
    }

    spendingPlan.addAll(await SpendingPlanNetwork.getSpendings(periodIds));

    for (var month in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]) {
      List<List<MapEntry<String, Map<String, dynamic>>>> rows = [];
      final dayInMonth = getDaysInMonth(now.year, month);
      int length = (dayInMonth / 7).floor();
      int day = 0;

      for (var row = 0; row <= length; row++) {
        List<MapEntry<String, Map<String, dynamic>>> rowDays = <MapEntry<String, Map<String, dynamic>>>[];
        DateTime? date;

        if (row == 0) {
          day++;
          date = DateTime(now.year, month, day);

          if (day == 1 && date.weekday == 7) {
            length += 1;
          }
        }

        int dayRowIndex = 0;

        if (row == 0 && date!.weekday > 1) {
          for (var index = 0; index < date.weekday - 1; index++) {
            rowDays.add(const MapEntry('', {}));
          }

          dayRowIndex = date.weekday - 1;
          day--;
        } else if (row == 0) {
          day--;
        }

        for (var dayRow = dayRowIndex; dayRow < 7; dayRow++) {
          day++;
          date = DateTime(now.year, month, day);

          Color? background;
          Color color = secondColor;
          List<Color>? bottom;

          if (DateFormat('dd.MM.y').format(date) == nowStr) {
            background = primaryColor;
            color = Colors.white;
          }

          final (int, DateTime, PeriodResponseModel?, bool, bool, DateTime)? list = await getPeriod(date);
          final PeriodResponseModel? period = list!.$3;
          final double spendingPlanPrice = spendingPlan.where((p0) => p0.periodId == period?.id && p0.date == DateFormat('dd.MM.y').format(date!)).map((e) => e.price).fold(0, (a, b) => a + b);
          double saldo = 0;
          double priceToDay = 0;
          final double income = incomes.where((element) => element.categoryId == 0 && element.periodId == period?.id).map((element) => element.price).fold(0, (a, b) => a + b);
          final double spending = spendings.where((element) => element.date == DateFormat('dd.MM.y').format(date!) && element.periodId == period?.id).map((element) => element.price).fold(0, (a, b) => a + b);

          if (list.$3 != null) {
            final planning = getPlanningToDay(date, list.$1, list.$2, period!);
            saldo = planning[3];
            priceToDay = planning[2];
          }

          if (list.$4 && list.$2.millisecondsSinceEpoch <= date.millisecondsSinceEpoch && now.month >= date.month && now.millisecondsSinceEpoch >= date.millisecondsSinceEpoch) {
            background = const Color(0xFF76C86C);
            color = Colors.white;
          }

          if (income < period!.price && list.$4 && list.$2.millisecondsSinceEpoch <= now.millisecondsSinceEpoch && list.$6.millisecondsSinceEpoch >= now.millisecondsSinceEpoch && date.month >= list.$2.month && now.millisecondsSinceEpoch >= date.millisecondsSinceEpoch) {
            background = const Color(0xFFE33E34);
            color = Colors.white;
          }

          final List<Color> colorList = <Color>[];

          if (spending > 0 && list.$2.millisecondsSinceEpoch <= date.millisecondsSinceEpoch && now.month == date.month && list.$6.month <= now.month && saldo > 0) {
            colorList.add(const Color(0xFF76C86C));
          }

          if (spending > 0 && list.$6.millisecondsSinceEpoch >= now.millisecondsSinceEpoch && list.$2.millisecondsSinceEpoch <= now.millisecondsSinceEpoch && list.$2.millisecondsSinceEpoch <= date.millisecondsSinceEpoch && list.$6.millisecondsSinceEpoch >= date.millisecondsSinceEpoch && now.month == date.month && saldo < 0) {
            colorList.add(const Color(0xFFE33E34));
          }

          if (spendingPlanPrice > 0) {
            colorList.add(const Color(0xFFFFBB00));
          }

          if (colorList.isNotEmpty) {
            bottom = colorList;
          }

          rowDays.add(MapEntry('$day', {'periodId': list.$3?.id, 'priceToDay': priceToDay, 'spendingPlanPrice': 0.0, 'date': DateFormat('dd.MM.y').format(date), 'start': list.$4, 'end': list.$5, 'background': background, 'color': color, 'bottom': bottom}));

          if (day == dayInMonth) {
            day = 0;

            if (row == length && date.weekday < 7) {
              for (var index = 0; index < 7; index++) {
                rowDays.add(const MapEntry('', {}));
              }

              dayRowIndex = date.weekday;
            }
          }
        }

        rows.add(rowDays);
      }

      day = 1;

      calendar.add(MapEntry('${tr('text_month_$month')} ${now.year}', rows));
    }

    isLoading.value = true;

    if (scroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) => Scrollable.ensureVisible(dataKey.currentContext!, duration: const Duration(milliseconds: 600)));
    } else {
      update();
    }
  }

  Future<(int, DateTime, PeriodResponseModel?, bool, bool, DateTime)?> getPeriod(DateTime date) async {
    List<Map<String, dynamic>> dates = [];

    for (var (index, element) in periods.indexed) {
      if (index == 0) {
        DateTime startDate = DateTime(date.year, date.month, periods[periods.length-1].day).subtractMonths(1);
        String endDateStr = DateFormat('y-${'${date.month}'.padLeft(2, '0')}-${'${element.day}'.padLeft(2, '0')}').format(now.toUtc());
        DateTime endDate = DateTime.parse(endDateStr).subtract(const Duration(days: 1));
        bool fixStart = false;
        bool fixEnd = false;

        if (element.ever) {
          if (startDate.weekday == 6 || startDate.weekday + 1 == 6) {
            fixStart = true;
            startDate = startDate.subtract(const Duration(days: 1));
          } else if (startDate.weekday == 7) {
            fixStart = true;
            startDate = startDate.subtract(const Duration(days: 2));
          }

          if (endDate.weekday == 6 || endDate.weekday + 1 == 6) {
            fixEnd = true;
            endDate = endDate.subtract(Duration(days: fixStart ? 2 : 1));
          } else if (endDate.weekday == 7 || endDate.weekday + 1 == 7) {
            fixEnd = true;
            endDate = endDate.subtract(Duration(days: fixStart ? 3 : 2));
          }
        }

        final start = DateFormat('y-MM-dd').format(startDate);
        final end = DateFormat('y-MM-dd').format(endDate);

        dates.add({'id': periods[periods.length-1].id, 'start': start, 'end': end, 'fix': fixStart || fixEnd});
      } else {
        DateTime startDate = DateTime.parse(dates[dates.length-1]['end']).addDays(1);
        String endDateStr = DateFormat('y-${'${date.month}'.padLeft(2, '0')}-${'${element.day}'.padLeft(2, '0')}').format(date);
        DateTime endDate = DateTime.parse(endDateStr).subtract(const Duration(days: 1));
        bool fixStart = dates[dates.length-1]['fix'] ?? false;
        bool fixEnd = false;

        if (element.ever) {
          if (startDate.weekday == 6) {
            fixStart = true;
            startDate = startDate.subtract(const Duration(days: 1));
          } else if (startDate.weekday == 7) {
            fixStart = true;
            startDate = startDate.subtract(const Duration(days: 2));
          }

          if (endDate.weekday == 6 || endDate.weekday + 1 == 6) {
            fixEnd = true;
            endDate = endDate.subtract(Duration(days: fixStart ? 2 : 1));
          } else if (endDate.weekday == 7 || endDate.weekday + 1 == 7) {
            fixEnd = true;
            endDate = endDate.subtract(Duration(days: fixStart ? 3 : 2));
          }
        }

        final start = DateFormat('y-MM-dd').format(startDate);
        final end = DateFormat('y-MM-dd').format(endDate);

        dates.add({'id': periods[index-1].id, 'start': start, 'end': end, 'fix': fixStart || fixEnd});
      }

      if (periods.length-1 == index) {
        DateTime startDate = DateTime.parse(dates[dates.length-1]['end']).add(const Duration(days: 1));
        int addDay = 0;

        if (date.month == DateTime.february) {
          final bool isLeapYear = (date.year % 4 == 0) && (date.year % 100 != 0) || (date.year % 400 == 0);
          addDay = isLeapYear ? 1 : 0;
        } else {
          addDay = 1;
        }

        String endDateStr = DateFormat('y-MM-dd').format(startDate.add(Duration(days: DateTime.parse(dates[0]['end']).daysSince(DateTime.parse(dates[0]['start'])) + addDay)));

        DateTime endDate = DateTime.parse(endDateStr);

        if (element.ever && (startDate.weekday == 1 || endDate.weekday == 1)) {
          endDate = endDate.subtract(const Duration(days: 3));
        }

        dates.add({'id': element.id, 'start': DateFormat('y-MM-dd').format(startDate), 'end': DateFormat('y-MM-dd').format(endDate)});
      }
    }

    for (var i in dates) {
      final List<String> splitStart = i['start'].toString().split('-');
      final List<String> splitEnd = i['end'].toString().split('-');

      final timeStart = DateTime(int.parse(splitStart[0]), int.parse(splitStart[1]), int.parse(splitStart[2]));
      final timeEnd = DateTime(int.parse(splitEnd[0]), int.parse(splitEnd[1]), int.parse(splitEnd[2]));

      if (date.millisecondsSinceEpoch >= timeStart.millisecondsSinceEpoch && date.millisecondsSinceEpoch <= timeEnd.millisecondsSinceEpoch) {
        final start = DateTime.parse(i['start']);
        final end = DateTime.parse(i['end']);

        return (end.daysSince(start), start, periods.firstWhereOrNull((element) => element.id == i['id']), end != date && start == date, end == date, end);
      }
    }

    return null;
  }

  List<double> getPlanningToDay(DateTime dates, int periodDayCount, DateTime startDay, PeriodResponseModel period) {
    final double expenseTotal = expenses.where((p0) => p0.planningId == period.planningId && p0.categoryId != 0).map((e) => [6,7].contains(e.categoryId) ? ((e.price / 100) * period.price) : e.price).fold(0, (a, b) => a + b);
    final double realIncome = incomes.where((element) => element.categoryId != 0 && element.periodId == period.id).map((element) => element.price).fold(0, (a, b) => a + b);
    final incomeSum = incomes.where((element) => element.categoryId == 0 && element.periodId == period.id).map((element) => element.price).fold(0, (a, b) => a + b);
    final double realCleanTotal = incomeSum - realIncome;
    final double cleanIncome = incomeSum - expenseTotal;
    double spendTotal = 0;
    final String now = DateFormat('dd.MM.y').format(dates);
    List<dynamic> prevList = <dynamic>[];
    var list = <List<dynamic>>[];
    List<double> spendingPrevPrice = <double>[];
    int index = 0;
    int index2 = 0;

    for (var i = 0; i < periodDayCount + 1; i++) {
      final DateTime format = startDay.add(Duration(days: i));
      double spendingToDay = spendings.where((element) => element.date == DateFormat('dd.MM.y').format(format) && element.periodId == period.id && (element.type ?? false)).map((element) => element.price).fold(0, (a, b) => a + b);
      spendingToDay -= spendings.where((element) => element.date == DateFormat('dd.MM.y').format(format) && element.periodId == period.id && !(element.type ?? false)).map((element) => element.price).fold(0, (a, b) => a + b);
      spendTotal += spendingToDay;
      double spendingPlanPrice = spendingPlan.where((element) => element.date == DateFormat('dd.MM.y').format(format)).map((element) => element.price).fold(0, (a, b) => a + b);
      final double cell1 = spendingToDay;

      double income = 0.0;
      double cell2 = 0.0;
      double cell3 = 0.0;
      double cell4 = 0.0;

      if (i > 0) {
        if (expenseTotal > realIncome) {
          income = cleanIncome;
          cell2 = (cleanIncome / (periodDayCount + 1)) + prevList[3];
        } else {
          income = realCleanTotal;
          cell2 = (realCleanTotal / (periodDayCount + 1)) + prevList[3];
        }

        if (prevList[0] == 0) {
          if (spendingPrevPrice.isNotEmpty) {
            cell3 = spendingPrevPrice.last;
          } else {
            cell3 = prevList[2];
          }
        } else {
          cell3 = ((income - spendTotal) / ((periodDayCount + 1) - (i + 1) + 1));
        }

        if (spendingPlanPrice > 0) {
          spendingPrevPrice.add(cell3);
          double changeCell3 = 0;
          int dateNowIndex = 0;

          for (var index = 0; index < i; index++) {
            if (now == list[index][4]) {
              dateNowIndex = index;
            }
          }

          if (spendingPlanPrice > cell3) {
            changeCell3 = (spendingPlanPrice - cell3) / (list.length - 1);

            for (var index = dateNowIndex; index < i; index++) {
              list[index][2] = (double.tryParse('${list[index][2]}') ?? 0) - changeCell3;
            }
          } else {
            changeCell3 = (cell3 - spendingPlanPrice) / (list.length - 1);

            for (var index = dateNowIndex; index < i; index++) {
              list[index][2] = (double.tryParse('${list[index][2]}') ?? 0) + changeCell3;
            }
          }

          cell3 = spendingPlanPrice;
        }

        cell4 = cell2 - spendingToDay;
      } else {
        if (expenseTotal > realIncome) {
          cell2 = (cleanIncome / (periodDayCount + 1));
        } else {
          cell2 = (realCleanTotal / (periodDayCount + 1));
        }

        cell3 = spendingPlanPrice == 0.0 ? cell2 : spendingPlanPrice;
        cell4 = cell2 - spendingToDay;
      }

      if (format == dates) {
        index2 = index;
      }

      final arrList = [cell1, cell2, cell3, cell4, DateFormat('dd.MM.y').format(format)];

      list.add(arrList);
      prevList = arrList;
      index++;
    }

    return [list[index2][0], list[index2][1], list[index2][2], list[index2][3]];
  }
}