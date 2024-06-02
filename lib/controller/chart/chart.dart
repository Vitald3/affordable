import 'package:affordable/utils/extension.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';
import '../../main.dart';
import '../../model/chart_formula_response_model.dart';
import '../../model/chart_point_model.dart';
import '../../model/chart_response_model.dart';
import '../../model/expense_response.dart';
import '../../model/income_response.dart';
import '../../model/period_response_model.dart';
import '../../model/spending_response_model.dart';
import '../../network/chart/chart.dart';
import '../../network/dashboard/dashboard.dart';
import '../../network/dashboard/spending_plan.dart';
import '../../network/setting/planning.dart';

class ChartController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool touchingGraph = false.obs;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  RxList<ChartResponseModel> charts = <ChartResponseModel>[].obs;
  RxList<IncomeResponseModel> incomes = <IncomeResponseModel>[].obs;
  RxList<PeriodResponseModel> periods = <PeriodResponseModel>[].obs;
  RxList<SpendingResponseModel> spendingList = <SpendingResponseModel>[].obs;
  RxList<SpendingResponseModel> spendingPlanList = <SpendingResponseModel>[].obs;
  RxList<ExpenseResponse> expenses = <ExpenseResponse>[].obs;
  List<int> periodIds = <int>[].obs;
  List<int> planningIds = <int>[].obs;
  Map<int, double> periodPrices = <int, double>{}.obs;
  RxList<List<List<ChartPointModel>>> items = <List<List<ChartPointModel>>>[].obs;
  final DateTime now = DateTime.now();
  final String nowStr = DateFormat('dd.MM.y').format(DateTime.now());
  final Map<String, String> searchFormula = {
    '00': 'incomePlaned', '01': 'incomeNotPlaned', '02': 'spendingFact',
    '10': 'expensePlaned', '11': 'expenseNotPlaned', '12': 'expenseFact',
    '20': 'investPlaned', '21': 'investNotPlaned', '22': 'investFact',
    '30': 'moneyPlaned', '31': 'moneyNotPlaned', '32': 'moneyFact',
    '40': 'dayExpensePlaned', '41': 'dayExpenseFact', '42': 'dayExpenseSaldo', '43': 'dayExpenseAccumulate'
  };
  Parser p = Parser();
  RxList<Map<String, dynamic>> dates = <Map<String, dynamic>>[].obs;
  RxList<MapEntry<int, ScrollController>> scrolls = <MapEntry<int, ScrollController>>[].obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  void scrollRight(_) {
    for (var i in scrolls) {
      i.value.animateTo(i.key * 86, duration: const Duration(milliseconds: 100), curve: Curves.ease);
    }
  }

  void initialize() async {
    charts.clear();
    spendingList.clear();
    spendingPlanList.clear();
    periods.clear();
    periodIds.clear();
    incomes.clear();
    charts.addAll(await ChartNetwork.getCharts());

    for (var chart in charts) {
      bool item = false;

      for (var i in chart.formulaList ?? <ChartFormulaResponseModel>[]) {
        item = i.formula.contains('40') || i.formula.contains('41') || i.formula.contains('42') || i.formula.contains('43');
        if (item) break;
      }

      chart.type = prefs?.getInt('chart_${chart.id}_type') ?? (!item ? 1 : 0);

      if (prefs?.getInt('chart_${chart.id}_type') == null) {
        prefs?.setInt('chart_${chart.id}_type', (!item ? 1 : 0));
      }
    }

    periods.addAll(await PlanningNetwork.getPeriods(all: true));

    if (periods.isNotEmpty) {
      expenses.clear();

      for (var i in periods) {
        periodIds.add(i.id);
        planningIds.add(i.planningId);
        periodPrices.putIfAbsent(i.planningId, () => i.price.toDouble());

        if (i.planning?.expenses != null) {
          expenses.addAll(i.planning!.expenses!.toList());
        }
      }
    } else {
      Get.offAllNamed('/period');
    }

    incomes.addAll(await DashboardNetwork.getAllIncomes(periodIds));
    spendingList.addAll(await DashboardNetwork.getSpendingsAll(periodIds));
    spendingPlanList.addAll(await SpendingPlanNetwork.getSpendings(periodIds));
    await getPeriodDate();
    await getPoints();
    isLoading.value = true;
    WidgetsBinding.instance.addPostFrameCallback(scrollRight);
  }

  Future<void> getPoints() async {
    items.clear();
    scrolls.clear();

    for (var chart in charts) {
      List<List<ChartPointModel>> listItems = <List<ChartPointModel>>[];
      int type = (chart.type ?? 1);

      final List<double> values = <double>[];
      chart.bottomLabels = <String>[];
      chart.leftLabels = <String>[];

      if (type == 0) {
        for (var indexDay = 1; indexDay <= getDaysInMonth(now.year, now.month); indexDay++) {
          chart.bottomLabels!.add('$indexDay');
        }
      } else if (type == 1) {
        final List<int> bottom = <int>[];
        bottom.addAll([now.addMonth(-2).month, now.subtractMonths(1).month, now.month, now.addMonth(1).month, now.addMonth(2).month, now.addMonth(3).month]);

        for (var i in bottom) {
          chart.bottomLabels!.add(getMonthName(i));
        }
      } else if (type == 2) {
        chart.bottomLabels!.addAll(['${now.year-2}', '${now.year-1}', '${now.year}']);
      } else if (type == 3) {
        chart.bottomLabels = dates.map((element) => element['period'].toString()).toList();
      }

      for (var i in (chart.formulaList ?? <ChartFormulaResponseModel>[])) {
        List<ChartPointModel> points = <ChartPointModel>[];

        if (type == 0) {
          for (var indexDay = 1; indexDay <= getDaysInMonth(now.year, now.month); indexDay++) {
            final double price = getPrice(type, i.formula, indexDay);
            values.add(price);
            points.add(ChartPointModel(price: convertPrice(price), value: price));
          }

          listItems.add(points);
        } else if (type == 1) {
          for (var month in [now.addMonth(-2).month, now.subtractMonths(1).month, now.month, now.addMonth(1).month, now.addMonth(2).month, now.addMonth(3).month]) {
            final double price = getPrice(type, i.formula, month);
            values.add(price);
            points.add(ChartPointModel(price: convertPrice(price), value: price));
          }

          listItems.add(points);
        } else if (type == 2) {
          for (var year in [now.addMonth(-24).year, now.subtractMonths(12).year, now.year]) {
            final double price = getPrice(type, i.formula, year);
            values.add(price);
            points.add(ChartPointModel(price: convertPrice(price), value: price));
          }

          listItems.add(points);
        } else if (type == 3) {
          for (var date in dates) {
            final double price = getPriceByPeriod(date['id'], i.formula, chart: date);
            values.add(price);
            points.add(ChartPointModel(price: convertPrice(price), value: price));
          }

          listItems.add(points);
        }
      }

      if (chart.bottomLabels!.length >= 6) {
        int length = chart.bottomLabels!.length > 25 ? (30 / now.day).ceil() : (25 / now.month).ceil();
        scrolls.add(MapEntry(length, ScrollController()));
      }

      if (listItems.isNotEmpty && values.isNotEmpty) {
        final List<double> left = <double>[];
        double step = values.max / 5;
        final double min = values.min;

        if (min < 0) {
          step = (values.max - min) / 5;

          for (var i = 0; i < 5; i++) {
            left.add((min + (step * i)).toDouble());
          }
        } else {
          for (var i = 0; i < 5; i++) {
            left.add((i * step).toDouble());
          }
        }

        left.add(values.max.toDouble());
        chart.leftLabels!.addAll(left.reversed.map((e) => '${e.toStringAsFixed(2)}k').toList());
        items.add(listItems);
      }
    }
  }

  String getMonthName(int value) {
    String text = '';

    switch (value) {
      case 1:
        text = tr('text_month_short_1');
        break;
      case 2:
        text = tr('text_month_short_2');
        break;
      case 3:
        text = tr('text_month_short_3');
        break;
      case 4:
        text = tr('text_month_short_4');
        break;
      case 5:
        text = tr('text_month_short_5');
        break;
      case 6:
        text = tr('text_month_short_6');
        break;
      case 7:
        text = tr('text_month_short_7');
        break;
      case 8:
        text = tr('text_month_short_8');
        break;
      case 9:
        text = tr('text_month_short_9');
        break;
      case 10:
        text = tr('text_month_short_10');
        break;
      case 11:
        text = tr('text_month_short_11');
        break;
      case 12:
        text = tr('text_month_short_12');
        break;
    }

    return text;
  }

  String getView(int val, List<ChartFormulaResponseModel>? formulaList) {
    String item = '';

    if (getViewDay(formulaList)) {
      return 'text_day';
    }

    if (val == 0) {
      item = 'text_day';
    } else if (val == 1) {
      item = 'text_month';
    } else if (val == 2) {
      item = 'text_year';
    } else if (val == 3) {
      item = 'text_period_chart';
    }

    return item;
  }

  double getMaxY(List<List<FlSpot>> spots) {
    double item = 0;

    for (var spot in spots) {
      item += spot.map((e) => e.x).fold(0, (a, b) => a + b);
    }

    return item;
  }

  List<double> getValues(List<List<ChartPointModel>> spots) {
    List<double> item = <double>[];

    for (var spot in spots) {
      for (var s in spot) {
        item.add(double.tryParse(s.price.replaceAll(' ₽', '')) ?? 0.0);
      }
    }

    return [item.min, item.max];
  }

  double getMaxX(int type) {
    double item = 0;

    if (type == 0) {
      item = 5;
    } else if (type == 1) {
      item = 5;
    } else if (type == 2) {
      item = 2;
    } else if (type == 3) {
      item = 3;
    }

    return item;
  }

  bool getViewDay(List<ChartFormulaResponseModel>? formulaList) {
    if (formulaList != null) {
      for (var i in formulaList) {
        if (i.formula.contains('40') || i.formula.contains('41') || i.formula.contains('42') || i.formula.contains('43')) return true;
      }
    }

    return false;
  }

  void setView(BuildContext context, int id, int view) async {
    touchingGraph.value = true;

    for (var i in charts) {
      if (i.id == id) {
        i.type = view;

        for (var i2 in i.formulaList!) {
          i2.price = 0;
        }

        prefs?.setInt('chart_${i.id}_type', view);
        break;
      }
    }

    await getPoints().then((value) {
      WidgetsBinding.instance.addPostFrameCallback(scrollRight);
      Navigator.of(context).pop();
    });
  }

  String changeShort(int type, ChartFormulaResponseModel val) {
    int? value;

    if (type == 0) {
      value = now.day;
    } else if (type == 1) {
      value = now.month;
    } else if (type == 2) {
      value = now.year;
    }

    double price = 0.0;

    if (val.price != null && !touchingGraph.value) {
      price = val.price!;
    } else {
      price = getPrice(type, val.formula, value);
    }

    for (var (index, i) in charts.indexed) {
      if (i.id == val.chartId) {
        for (var i2 in i.formulaList!) {
          if (i2.id == val.id) {
            i2.price = price;

            if (index == charts.length - 1) {
              touchingGraph.value = false;
            }

            break;
          }
        }
      }
    }

    String item = val.formulaText.replaceAll("\n", ' ');
    item = item.replaceAll(tr('text_plan_1'), tr('text_plan_short'));
    item = item.replaceAll(tr('text_plan_2'), tr('text_plan_short'));
    item = item.replaceAll(tr('text_dop_1'), tr('text_dop_short'));
    item = item.replaceAll(tr('text_dop_2'), tr('text_dop_short'));
    item = item.replaceAll(tr('text_fact_1'), tr('text_fact_short'));
    item = item.replaceAll(tr('text_fact_2'), tr('text_fact_short'));
    return '$item: ${price.toDouble().toStringAsFixed(2)}k';
  }

  double getPriceByMonth(int month, String formula) {
    double price = 0.0;
    Map <String, int> variableMap = <String, int>{};

    variableMap.putIfAbsent('incomePlaned', () => periods
        .where((p0) => (p0.planning?.expenses ?? <ExpenseResponse>[]).where((e) => e.date.month == month && e.date.year == now.year).isNotEmpty)
        .map((e) => e.price)
        .fold(0, (a, b) => a + b));

    variableMap.putIfAbsent('incomeNotPlaned', () => incomes
        .where((p0) => periodIds.contains(p0.periodId) && p0.categoryId == 0 && !p0.unplanned && p0.date.month == month && p0.date.year == now.year)
        .map((e) => e.price)
        .fold(0, (a, b) => a + b));

    final double realCleanTotal = incomes.where((element) => periodIds.contains(element.periodId) && element.salary && element.categoryId == 0 && element.date.month == month && element.date.year == now.year).map((element) => element.price).fold(0, (a, b) => a + b);
    variableMap.putIfAbsent('spendingFact', () => realCleanTotal.toInt());

    final expensePlanedList = expenses.where((p0) => planningIds.contains(p0.planningId) && p0.date.month == month && p0.date.year == now.year);
    double expensePlanedTotal = 0;

    for (var expense in expensePlanedList) {
      expensePlanedTotal += ([6,7].contains(expense.categoryId) ? ((expense.price / 100) * periodPrices[expense.planningId]!) : expense.price);
    }

    variableMap.putIfAbsent('expensePlaned', () => expensePlanedTotal.toInt());

    variableMap.putIfAbsent('expenseNotPlaned', () => incomes
        .where((p0) => periodIds.contains(p0.periodId) && p0.categoryId != 0 && p0.expenseId == 0 && p0.unplanned && p0.date.month == month && p0.date.year == now.year)
        .map((e) => e.price)
        .fold(0, (a, b) => a + b));

    variableMap.putIfAbsent('expenseFact', () => incomes
        .where((p0) => periodIds.contains(p0.periodId) && p0.categoryId != 0 && p0.date.month == month && p0.date.year == now.year)
        .map((e) => e.price)
        .fold(0, (a, b) => a + b));

    final investPlanedList = expenses.where((p0) => planningIds.contains(p0.planningId) && p0.categoryId == 6 && p0.date.month == month && p0.date.year == now.year);
    double investPlanedTotal = 0;

    for (var invest in investPlanedList) {
      investPlanedTotal += ((invest.price / 100) * periodPrices[invest.planningId]!);
    }

    variableMap.putIfAbsent('investPlaned', () => investPlanedTotal.toInt());

    variableMap.putIfAbsent('investNotPlaned', () => incomes
        .where((p0) => periodIds.contains(p0.periodId) && p0.categoryId == 6 && p0.expenseId == 0 && p0.unplanned && p0.date.month == month && p0.date.year == now.year)
        .map((e) => e.price)
        .fold(0, (a, b) => a + b));

    variableMap.putIfAbsent('investFact', () => incomes
        .where((p0) => periodIds.contains(p0.periodId) && p0.categoryId == 6 && p0.date.month == month && p0.date.year == now.year)
        .map((e) => e.price)
        .fold(0, (a, b) => a + b));

    final moneyPlanedList = expenses.where((p0) => planningIds.contains(p0.planningId) && p0.categoryId == 7 && p0.date.month == month && p0.date.year == now.year);
    double moneyPlanedTotal = 0;

    for (var money in moneyPlanedList) {
      moneyPlanedTotal += ((money.price / 100) * periodPrices[money.planningId]!);
    }

    variableMap.putIfAbsent('moneyPlaned', () => moneyPlanedTotal.toInt());

    variableMap.putIfAbsent('moneyNotPlaned', () => incomes
        .where((p0) => periodIds.contains(p0.periodId) && p0.categoryId == 7 && p0.expenseId == 0 && p0.unplanned && p0.date.month == month && p0.date.year == now.year)
        .map((e) => e.price)
        .fold(0, (a, b) => a + b));

    variableMap.putIfAbsent('moneyFact', () => incomes
        .where((p0) => periodIds.contains(p0.periodId) && p0.categoryId == 7 && p0.date.month == month && p0.date.year == now.year)
        .map((e) => e.price)
        .fold(0, (a, b) => a + b));

    Map<String, String> map = searchFormula;
    String operationStr = '|$formula|';

    for (var item in formula.split('|')) {
      item = item.trim();

      if (!item.contains('+') && !item.contains('-') && !item.contains('*') && !item.contains('/')) {
        final int variable = int.tryParse('${variableMap[map[item] ?? '']}') ?? 0;
        operationStr = operationStr.replaceAll('|$item|', '$variable');
      }
    }

    Parser p = Parser();
    Expression exp = p.parse(operationStr);
    price = exp.evaluate(EvaluationType.REAL, ContextModel());

    return price / 1000;
  }

  double getPriceByYear(int year, String formula) {
    double price = 0.0;
    Map <String, int> variableMap = <String, int>{};

    variableMap.putIfAbsent('incomePlaned', () => periods
        .map((e) => e.price)
        .fold(0, (a, b) => a + b) * 12);

    variableMap.putIfAbsent('incomeNotPlaned', () => incomes
        .where((p0) => p0.categoryId == 0 && periodIds.contains(p0.periodId) && !p0.unplanned && p0.date.year == year)
        .map((e) => e.price)
        .fold(0, (a, b) => a + b));

    final double realCleanTotal = incomes.where((element) => periodIds.contains(element.periodId) && element.salary && element.categoryId == 0 && element.date.year == now.year).map((element) => element.price).fold(0, (a, b) => a + b);
    variableMap.putIfAbsent('spendingFact', () => realCleanTotal.toInt());

    final expensePlanedList = expenses.where((p0) => planningIds.contains(p0.planningId) && p0.date.year == year);
    double expensePlanedTotal = 0;

    for (var expense in expensePlanedList) {
      expensePlanedTotal += ([6,7].contains(expense.categoryId) ? ((expense.price / 100) * periodPrices[expense.planningId]!) : expense.price);
    }

    variableMap.putIfAbsent('expensePlaned', () => expensePlanedTotal.toInt());

    variableMap.putIfAbsent('expenseNotPlaned', () => incomes
        .where((p0) => periodIds.contains(p0.periodId) && p0.categoryId == 5 && p0.expenseId == 0 && p0.unplanned && p0.date.year == year)
        .map((e) => e.price)
        .fold(0, (a, b) => a + b));

    variableMap.putIfAbsent('expenseFact', () => incomes
        .where((p0) => periodIds.contains(p0.periodId) && p0.categoryId == 5 && p0.date.year == year)
        .map((e) => e.price)
        .fold(0, (a, b) => a + b));

    final investPlanedList = expenses.where((p0) => planningIds.contains(p0.planningId) && p0.categoryId == 6 && p0.date.month == year);
    double investPlanedTotal = 0;

    for (var invest in investPlanedList) {
      investPlanedTotal += ((invest.price / 100) * periodPrices[invest.planningId]!);
    }

    variableMap.putIfAbsent('investPlaned', () => investPlanedTotal.toInt());

    variableMap.putIfAbsent('investNotPlaned', () => incomes
        .where((p0) => periodIds.contains(p0.periodId) && p0.categoryId == 6 && p0.expenseId == 0 && p0.unplanned && p0.date.year == year)
        .map((e) => e.price)
        .fold(0, (a, b) => a + b));

    variableMap.putIfAbsent('investFact', () => incomes
        .where((p0) => periodIds.contains(p0.periodId) && p0.categoryId == 6 && p0.date.year == year)
        .map((e) => e.price)
        .fold(0, (a, b) => a + b));

    final moneyPlanedList = expenses.where((p0) => planningIds.contains(p0.planningId) && p0.categoryId == 7 && p0.date.month == year);
    double moneyPlanedTotal = 0;

    for (var money in moneyPlanedList) {
      moneyPlanedTotal += ((money.price / 100) * periodPrices[money.planningId]!);
    }

    variableMap.putIfAbsent('moneyPlaned', () => moneyPlanedTotal.toInt());

    variableMap.putIfAbsent('moneyNotPlaned', () => incomes
        .where((p0) => periodIds.contains(p0.periodId) && p0.categoryId == 7 && p0.expenseId == 0 && p0.unplanned && p0.date.year == year)
        .map((e) => e.price)
        .fold(0, (a, b) => a + b));

    variableMap.putIfAbsent('moneyFact', () => incomes
        .where((p0) => periodIds.contains(p0.periodId) && p0.categoryId == 7 && p0.date.year == year)
        .map((e) => e.price)
        .fold(0, (a, b) => a + b));

    Map<String, String> map = searchFormula;
    String operationStr = '|$formula|';

    for (var item in formula.split('|')) {
      item = item.trim();

      if (!item.contains('+') && !item.contains('-') && !item.contains('*') && !item.contains('/')) {
        final int variable = int.tryParse('${variableMap[map[item] ?? '']}') ?? 0;
        operationStr = operationStr.replaceAll('|$item|', '$variable');
      }
    }

    Parser p = Parser();
    Expression exp = p.parse(operationStr);
    price = exp.evaluate(EvaluationType.REAL, ContextModel());

    return price / 1000;
  }

  Future<void> getPeriod(int month) async {
    for (var (index, element) in periods.indexed) {
      if (index == 0) {
        DateTime startDate = DateTime(now.year, month, periods[periods.length-1].day).subtractMonths(1);
        String endDateStr = DateFormat('y-${'$month'.padLeft(2, '0')}-${'${element.day}'.padLeft(2, '0')}').format(now.toUtc());
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

        final start = DateFormat('dd.MM').format(startDate);
        final end = DateFormat('dd.MM').format(endDate);

        dates.add({'id': periods[periods.length-1].id, 'planning_id': element.planningId, 'period_price': element.price, 'period': '$start - $end', 'start': DateFormat('y-MM-dd').format(startDate), 'end': DateFormat('y-MM-dd').format(endDate), 'fix': fixStart || fixEnd});
      } else {
        DateTime startDate = DateTime.parse(dates[dates.length-1]['end']).addDays(1);
        String endDateStr = DateFormat('y-${'$month'.padLeft(2, '0')}-${'${element.day}'.padLeft(2, '0')}').format(now.toUtc());
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

        final start = DateFormat('dd.MM').format(startDate);
        final end = DateFormat('dd.MM').format(endDate);

        dates.add({'id': periods[index-1].id, 'planning_id': element.planningId, 'period_price': element.price, 'period': '$start - $end', 'start': DateFormat('y-MM-dd').format(startDate), 'end': DateFormat('y-MM-dd').format(endDate), 'fix': fixStart || fixEnd});
      }

      if (periods.length-1 == index && month == 12) {
        DateTime startDate = DateTime.parse(dates[dates.length-1]['end']).add(const Duration(days: 1));
        int addDay = 0;

        if (month == DateTime.february) {
          final bool isLeapYear = (now.year % 4 == 0) && (now.year % 100 != 0) || (now.year % 400 == 0);
          addDay = isLeapYear ? 1 : 0;
        } else {
          addDay = 1;
        }

        String endDateStr = DateFormat('y-MM-dd').format(startDate.add(Duration(days: DateTime.parse(dates[0]['end']).daysSince(DateTime.parse(dates[0]['start'])) + addDay)));

        DateTime endDate = DateTime.parse(endDateStr);

        if (element.ever && (startDate.weekday == 1 || endDate.weekday == 1)) {
          endDate = endDate.subtract(const Duration(days: 3));
        }

        dates.add({'id': element.id, 'planning_id': element.planningId, 'period_price': element.price, 'period': '${DateFormat('dd.MM').format(startDate)} - ${DateFormat('dd.MM').format(endDate)}', 'start': DateFormat('y-MM-dd').format(startDate), 'end': DateFormat('y-MM-dd').format(endDate)});
      }
    }
  }

  Future<void> getPeriodDate() async {
    dates.clear();

    for (var month in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]) {
      getPeriod(month);
    }
  }

  double getPriceByPeriod(int id, String formula, {Map<String, dynamic>? chart}) {
    double price = 0.0;
    Map <String, int> variableMap = <String, int>{};
    List<DateTime> periodDate = <DateTime>[];
    int periodId = id;

    if (chart == null) {
      for (var i in dates) {
        final List<String> splitStart = i['start'].toString().split('-');
        final List<String> splitEnd = i['end'].toString().split('-');
        final timeStart = DateTime(int.parse(splitStart[0]), int.parse(splitStart[1]), int.parse(splitStart[2])).toUtc();
        final timeEnd = DateTime(int.parse(splitEnd[0]), int.parse(splitEnd[1]), int.parse(splitEnd[2])).toUtc();

        if (now.toUtc().millisecondsSinceEpoch >= timeStart.millisecondsSinceEpoch && now.toUtc().millisecondsSinceEpoch <= timeEnd.millisecondsSinceEpoch) {
          periodId = i['id'];
          periodDate = [DateTime.parse(i['start']), DateTime.parse(i['end'])];
          break;
        }
      }
    } else {
      periodDate = [DateTime.parse(chart['start']), DateTime.parse(chart['end'])];
    }

    if (periodId == 0) return 0;

    variableMap.putIfAbsent('incomePlaned', () => periods
        .firstWhereOrNull((p0) => p0.id == periodId)?.price ?? 0);

    variableMap.putIfAbsent('incomeNotPlaned', () => incomes
        .where((p0) => !p0.salary && p0.categoryId == 0 && p0.periodId == periodId && !p0.unplanned && periodDate[0].isBeforeOrEqualTo(p0.date) && periodDate[1].isAfterOrEqualTo(p0.date))
        .map((e) => e.price)
        .fold(0, (a, b) => a + b));

    final double realCleanTotal = incomes.where((element) => element.periodId == periodId && element.salary && element.categoryId == 0 && periodDate[0].isBeforeOrEqualTo(element.date) && periodDate[1].isAfterOrEqualTo(element.date)).map((element) => element.price).fold(0, (a, b) => a + b);
    variableMap.putIfAbsent('spendingFact', () => realCleanTotal.toInt());

    final expensePlanedList = expenses.where((p0) => planningIds.contains(p0.planningId) && periodDate[0].isBeforeOrEqualTo(p0.date) && periodDate[1].isAfterOrEqualTo(p0.date));
    double expensePlanedTotal = 0;

    for (var expense in expensePlanedList) {
      expensePlanedTotal += ([6,7].contains(expense.categoryId) ? ((expense.price / 100) * periodPrices[expense.planningId]!) : expense.price);
    }

    variableMap.putIfAbsent('expensePlaned', () => expensePlanedTotal.toInt());

    variableMap.putIfAbsent('expenseNotPlaned', () => incomes
        .where((p0) => p0.periodId == periodId && p0.categoryId != 0 && p0.expenseId == 0 && p0.unplanned && periodDate[0].isBeforeOrEqualTo(p0.date) && periodDate[1].isAfterOrEqualTo(p0.date))
        .map((e) => e.price)
        .fold(0, (a, b) => a + b));

    variableMap.putIfAbsent('expenseFact', () => incomes
        .where((p0) => p0.periodId == periodId && p0.categoryId != 0 && periodDate[0].isBeforeOrEqualTo(p0.date) && periodDate[1].isAfterOrEqualTo(p0.date))
        .map((e) => e.price)
        .fold(0, (a, b) => a + b));

    final investPlanedList = expenses.where((p0) => planningIds.contains(p0.planningId) && p0.categoryId == 6 && periodDate[0].isBeforeOrEqualTo(p0.date) && periodDate[1].isAfterOrEqualTo(p0.date));
    double investPlanedTotal = 0;

    for (var invest in investPlanedList) {
      investPlanedTotal += ((invest.price / 100) * periodPrices[invest.planningId]!);
    }

    variableMap.putIfAbsent('investPlaned', () => investPlanedTotal.toInt());

    variableMap.putIfAbsent('investNotPlaned', () => incomes
        .where((p0) => p0.periodId == periodId && p0.categoryId == 6 && p0.expenseId == 0 && p0.unplanned && periodDate[0].isBeforeOrEqualTo(p0.date) && periodDate[1].isAfterOrEqualTo(p0.date))
        .map((e) => e.price)
        .fold(0, (a, b) => a + b));

    variableMap.putIfAbsent('investFact', () => incomes
        .where((p0) => p0.periodId == periodId && p0.categoryId == 6 && periodDate[0].isBeforeOrEqualTo(p0.date) && periodDate[1].isAfterOrEqualTo(p0.date))
        .map((e) => e.price)
        .fold(0, (a, b) => a + b));

    final moneyPlanedList = expenses.where((p0) => planningIds.contains(p0.planningId) && p0.categoryId == 7 && periodDate[0].isBeforeOrEqualTo(p0.date) && periodDate[1].isAfterOrEqualTo(p0.date));
    double moneyPlanedTotal = 0;

    for (var money in moneyPlanedList) {
      moneyPlanedTotal += ((money.price / 100) * periodPrices[money.planningId]!);
    }

    variableMap.putIfAbsent('moneyPlaned', () => moneyPlanedTotal.toInt());

    variableMap.putIfAbsent('moneyNotPlaned', () => incomes
        .where((p0) => p0.periodId == periodId && p0.categoryId == 7 && p0.expenseId == 0 && p0.unplanned && periodDate[0].isBeforeOrEqualTo(p0.date) && periodDate[1].isAfterOrEqualTo(p0.date))
        .map((e) => e.price)
        .fold(0, (a, b) => a + b));

    variableMap.putIfAbsent('moneyFact', () => incomes
        .where((p0) => p0.periodId == periodId && p0.categoryId == 7 && periodDate[0].isBeforeOrEqualTo(p0.date) && periodDate[1].isAfterOrEqualTo(p0.date))
        .map((e) => e.price)
        .fold(0, (a, b) => a + b));

    Map<String, String> map = searchFormula;
    String operationStr = '|$formula|';

    for (var item in formula.split('|')) {
      item = item.trim();

      if (!item.contains('+') && !item.contains('-') && !item.contains('*') && !item.contains('/')) {
        final int variable = int.tryParse('${variableMap[map[item] ?? '']}') ?? 0;
        operationStr = operationStr.replaceAll('|$item|', '$variable');
      }
    }

    Parser p = Parser();
    Expression exp = p.parse(operationStr);
    price = exp.evaluate(EvaluationType.REAL, ContextModel());

    return price / 1000;
  }

  List<double> getPlanningToDay(DateTime date) {
    List<double> items = [0, 0, 0, 0];
    DateTime startPeriod = DateTime.now();
    int periodId = 0;
    int planningId = 0;
    int periodDayCount = 0;
    int periodPrice = 0;

    for (var i in dates) {
      final List<String> splitStart = i['start'].toString().split('-');
      final List<String> splitEnd = i['end'].toString().split('-');
      final timeStart = DateTime(int.parse(splitStart[0]), int.parse(splitStart[1]), int.parse(splitStart[2])).toUtc();
      final timeEnd = DateTime(int.parse(splitEnd[0]), int.parse(splitEnd[1]), int.parse(splitEnd[2])).toUtc();

      if (date.toUtc().millisecondsSinceEpoch >= timeStart.millisecondsSinceEpoch && date.toUtc().millisecondsSinceEpoch <= timeEnd.millisecondsSinceEpoch) {
        final start = DateTime.parse(i['start']);
        final end = DateTime.parse(i['end']);

        startPeriod = start;
        periodId = i['id'];
        planningId = i['planning_id'];
        periodPrice = i['period_price'];
        periodDayCount = end.daysSince(start);
        break;
      }
    }

    if (periodId == 0) return items;

    final double expenseTotal = expenses.where((p0) => p0.planningId == planningId && p0.categoryId != 0).map((e) => [6,7].contains(e.categoryId) ? ((e.price / 100) * periodPrice) : e.price).fold(0, (a, b) => a + b);
    final double realIncome = incomes.where((element) => element.categoryId != 0 && element.periodId == periodId).map((element) => element.price).fold(0, (a, b) => a + b);
    final incomeSum = incomes.where((element) => element.categoryId == 0 && element.periodId == periodId).map((element) => element.price).fold(0, (a, b) => a + b);
    final double realCleanTotal = incomeSum - realIncome;
    final double cleanIncome = incomeSum - expenseTotal;
    double spendTotal = 0;
    final String now = DateFormat('dd.MM.y').format(DateTime.now());
    List<dynamic> prevList = <dynamic>[];
    var list = <List<dynamic>>[];
    List<double> spendingPrevPrice = <double>[];
    int index = 0;
    int index2 = 0;

    for (var i = 0; i < periodDayCount + 1; i++) {
      final DateTime format = startPeriod.add(Duration(days: i));
      double spendingToDay = spendingList.where((element) => element.date == DateFormat('dd.MM.y').format(format) && element.periodId == periodId && (element.type ?? false)).map((element) => element.price).fold(0, (a, b) => a + b);
      spendingToDay -= spendingList.where((element) => element.date == DateFormat('dd.MM.y').format(format) && element.periodId == periodId && !(element.type ?? false)).map((element) => element.price).fold(0, (a, b) => a + b);
      spendTotal += spendingToDay;
      double spendingPlanPrice = spendingPlanList.where((element) => element.date == DateFormat('dd.MM.y').format(format)).map((element) => element.price).fold(0, (a, b) => a + b);
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

      if (format == date) {
        index2 = index;
      }

      final arrList = [cell1, cell2, cell3, cell4, DateFormat('dd.MM.y').format(format)];

      list.add(arrList);
      prevList = arrList;
      index++;
    }

    return [list[index2][0], list[index2][1], list[index2][2], list[index2][3]];
  }

  double getPriceByDay(int day, String formula) {
    double price = 0.0;
    Map <String, double> variableMap = <String, double>{};

    final List<double> cells = getPlanningToDay(DateTime(now.year, now.month, day));

    variableMap.putIfAbsent('dayExpensePlaned', () => cells[2]);
    variableMap.putIfAbsent('dayExpenseFact', () => cells[0]);
    variableMap.putIfAbsent('dayExpenseSaldo', () => cells[3]);
    variableMap.putIfAbsent('dayExpenseAccumulate', () => cells[1]);

    Map<String, String> map = searchFormula;
    String operationStr = '|$formula|';

    for (var item in formula.split('|')) {
      item = item.trim();

      if (!item.contains('+') && !item.contains('-') && !item.contains('*') && !item.contains('/')) {
        final double variable = double.tryParse('${variableMap[map[item] ?? '']}') ?? 0.0;
        operationStr = operationStr.replaceAll('|$item|', '$variable');
      }
    }

    Parser p = Parser();
    Expression exp = p.parse(operationStr);
    price = exp.evaluate(EvaluationType.REAL, ContextModel());

    return price / 1000;
  }

  double getPrice(int type, String formula, int? value) {
    double price = 0.0;

    if (value == null) {
      price = getPriceByPeriod(value ?? 0, formula);
    } else if (type == 0) {
      price = getPriceByDay(value, formula);
    } else if (type == 1) {
      price = getPriceByMonth(value, formula);
    } else if (type == 2) {
      price = getPriceByYear(value, formula);
    }

    return price;
  }
}