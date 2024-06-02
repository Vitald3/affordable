import 'package:affordable/controller/main_layout.dart';
import 'package:affordable/network/award/award.dart';
import 'package:affordable/utils/extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../../model/award_response_model.dart';
import '../../model/category_response.dart';
import '../../model/expense_response.dart';
import '../../model/income_response.dart';
import '../../model/period_response_model.dart';
import '../../model/spending_response_model.dart';
import '../../network/dashboard/dashboard.dart';
import '../../network/dashboard/spending_plan.dart';
import '../../network/setting/planning.dart';
import '../../view/dashboard/award_popup.dart';

class DashboardController extends GetxController {
  RxList<PeriodResponseModel> periods = <PeriodResponseModel>[].obs;
  RxList<IncomeResponseModel> incomes = <IncomeResponseModel>[].obs;
  RxList<ExpenseResponse> expenses = <ExpenseResponse>[].obs;
  List<CategoryResponse> categories = <CategoryResponse>[].obs;
  List<SpendingResponseModel> spendings = <SpendingResponseModel>[].obs;
  List<SpendingResponseModel> spendingPlan = <SpendingResponseModel>[].obs;
  List<List<dynamic>> tables = <List<dynamic>>[].obs;
  RxList<AwardResponseModel> awards = <AwardResponseModel>[].obs;
  Rx<PeriodResponseModel>? period;
  RxString periodDate = ''.obs;
  RxBool isLoading = false.obs;
  RxDouble toDayPrice = 0.0.obs;
  RxDouble toDayRealPrice = 0.0.obs;
  RxBool toDayPriceMin = false.obs;
  RxBool colorBool = false.obs;
  RxInt periodId = 0.obs;
  RxDouble salary = 0.0.obs;
  RxBool openAll = false.obs;
  RxBool cleanIncomeMin = false.obs;
  RxMap<int, bool> openSection = <int, bool>{}.obs;
  RxDouble planPercent = 0.0.obs;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  RxList<IncomeResponseModel> incomeSalary = <IncomeResponseModel>[].obs;
  RxDouble cleanIncome = 0.0.obs;
  RxDouble expensePeriod = 0.0.obs;
  RxDouble realIncome = 0.0.obs;
  RxDouble realExpense = 0.0.obs;
  RxDouble realCleanTotal = 0.0.obs;
  RxMap<int, List<IncomeResponseModel>> heightIncomes = <int, List<IncomeResponseModel>>{}.obs;
  RxMap<int, List<ExpenseResponse>> heightExpenses = <int, List<ExpenseResponse>>{}.obs;
  RxInt periodDayCount = 0.obs;
  final ScrollController scrollController = ScrollController();
  final mainLayoutController = Get.find<MainLayoutController>();
  RxString startPeriod = ''.obs;
  List<int> awardInts = <int>[];
  final DateTime nowView = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    initialize();
  }
  
  void initialize() async {
    mainLayoutController.setController(this);
    await getPeriods();
    await setPeriodDate();
    await getIncomes();
    await getSpendings();
    await getTables();
    categories = await DashboardNetwork.getCategories();
    heightIncomes.clear();
    heightExpenses.clear();
    isLoading.value = true;
    getAwards();
  }

  void getAwards() async {
    final List<String> awardList = prefs?.getStringList('awards') ?? <String>[];

    for (var i in awardList) {
      awardInts.add(int.parse(i));
    }

    if (awards.isNotEmpty) {
      final String award_5 = DateFormat('dd.MM.y').format(DateTime.now().subtract(const Duration(days: 1)));
      final DateTime award_6 = DateTime.now().subtract(const Duration(days: 7));
      int countAward_6 = 0;
      int countAward_7 = 0;

      for (var (index, i) in tables.indexed) {
        if (index == 0) continue;

        final List<String> split = i[0].toString().split('.');
        final DateTime day = DateTime(int.parse(split[2]), int.parse(split[1]), int.parse(split[0]));

        if (awards.where((element) => element.award == 'award_5').isEmpty && i[0] == award_5 && i[4] > 0) {
          awardInts.add(5);
          break;
        }

        if (day.isBefore(award_6) && i[4] > 0) {
          countAward_6 += 1;
          break;
        }

        if (i[4] > 0) {
          countAward_7 += 1;
        }
      }

      if (awards.where((element) => element.award == 'award_6').isEmpty && countAward_6 >= 7) {
        awardInts.add(6);
      }

      if (awards.where((element) => element.award == 'award_7').isEmpty && countAward_7 == periodDayCount.value) {
        awardInts.add(7);
      }

      if (awards.where((element) => element.award == 'award_8').isEmpty && (prefs?.getInt('award_month') ?? 0) >= 30) {
        awardInts.add(8);
      }

      if (awards.where((element) => element.award == 'award_9').isEmpty && (prefs?.getInt('award_month') ?? 0) >= 356) {
        awardInts.add(9);
      }
    }

    for (var i in awardInts) {
      if (awardList.where((element) => element == '$i').isEmpty) {
        AwardNetwork.setAward(i);
      }

      await awardPopup(i);
    }

    awardInts.clear();
  }

  double getPercent(int id, double priceB) {
    if (id == 0) return 0.0;

    double priceA = 0;

    for (var i in incomes.where((element) => element.categoryId == id)) {
      priceA += i.price;
    }

    double price = 0.0;

    if (priceA > 0) {
      if (priceB > 0) {
        price = (priceA / priceB) * 100;
      } else {
        price = priceA;
      }
    } else {
      price = 0;
    }

    if (price.isNaN || price.isInfinite) {
      return 0.0;
    }

    return price.roundToDouble();
  }

  Future<void> getIncomes() async {
    incomes.clear();
    incomes.addAll(await DashboardNetwork.getIncomes(periodId.value));
    calculate();

    incomeSalary.value = incomes.where((element) => element.categoryId == 0 && (element.expenseId ?? 0) == 0 && !element.salary).toList();

    awards.addAll(await AwardNetwork.getAwards());

    Map<int, int> countPeriods = {5: 0, 6: 0, 7: 0};
    Map<int, int> countMonth = <int, int>{};

    for (var i in incomes) {
      countMonth[i.date.month] = 1;

      if (countPeriods[i.categoryId] != null) {
        countPeriods[i.categoryId] = countPeriods[i.categoryId]! + 1;
      }
    }

    if (awards.where((element) => element.award == 'award_12').isEmpty && countPeriods[5]! > 0 && countPeriods[6]! > 0 && countPeriods[7]! > 0) {
      awardInts.add(12);
    }

    if (awards.where((element) => element.award == 'award_16').isEmpty && countMonth.length >= 6) {
      awardInts.add(16);
    }
  }

  void calculate() {
    int price = 0;
    double cleanIncomePrice = 0;
    double expenseTotal = 0;

    for (var i in periods) {
      if (i.planning?.categories != null) {
        for (var category in i.planning?.categories?.where((element) => element.expenses != null && element.expenses!.isNotEmpty) ?? <CategoryResponse>[]) {
          for (var expense in category.expenses!.where((element) => element.categoryId != 0 && element.planningId == period?.value.planningId)) {
            if (category.percent) {
              expenseTotal += ((expense.price / 100) * i.price);
            } else {
              expenseTotal += expense.price;
            }
          }
        }
      }
    }

    if (incomes.isNotEmpty) {
      for (var i in incomes) {
        if (i.salary) {
          salary.value = double.parse('${i.price}');
        }

        if (i.categoryId == 0) {
          price += i.price;
        }
      }

      if (salary.value > 0) {
        cleanIncomePrice = salary.value - expenseTotal;
      }
    }

    if (cleanIncomePrice >= 0) {
      cleanIncome.value = cleanIncomePrice;
      cleanIncomeMin.value = false;
    } else {
      cleanIncomeMin.value = true;
    }

    if (price > 0) {
      planPercent.value = ((price / (period?.value.price ?? 0) * 100)).toDouble();
    } else {
      planPercent.value = 0;
    }

    if (salary.value == 0) {
      salary.value = double.parse('${period?.value.price ?? 0}');
    }
  }

  void setOpenAll() {
    openSection.clear();
    openAll.toggle();

    if (openAll.value) {
      sectionOpen(0, fix: true);

      for (var i in categories) {
        sectionOpen(i.id, fix: true);
      }
    }
  }

  int daysInMonth(DateTime date) => DateTimeRange(start: DateTime(date.year, date.month, 1), end: DateTime(date.year, date.month + 1)).duration.inDays;

  void sectionOpen(int id, {bool? fix = false}) {
    if (openSection.isEmpty) {
      openSection.value = {id: true};
    } else {
      if (openSection[id] != null) {
        openSection.remove(id);
      } else {
        openSection[id] = true;
      }

      List<int> ids = [];

      for (var i in incomes.where((p0) => (!p0.unplanned || p0.salary))) {
        if (!ids.contains(i.categoryId)) {
          ids.add(i.categoryId);
        }
      }

      if (openAll.value && (openSection.length == 1 || ids.length == openSection.length) && !(openSection[id] ?? (fix ?? false))) {
        openAll.value = false;
        openSection.clear();
      }
    }
  }

  Future<void> setPeriodDate() async {
    final now = DateTime.now();
    List<Map<String, dynamic>> dates = [];

    for (var (index, element) in periods.indexed) {
      if (index == 0) {
        DateTime startDate = DateTime(now.year, now.month, periods[periods.length-1].day).toUtc().subtractMonths(1).add(const Duration(days: 1));
        String endDateStr = DateFormat('y-MM-${'${element.day}'.padLeft(2, '0')}').format(now.toUtc());
        DateTime endDate = DateTime.parse(endDateStr);
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
        String endDateStr = DateFormat('y-MM-${'${element.day}'.padLeft(2, '0')}').format(now.toUtc());
        DateTime endDate = DateTime.parse(endDateStr);
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

        if (now.month == DateTime.february) {
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

        dates.add({'id': element.id, 'start': DateFormat('y-MM-dd').format(startDate), 'end': DateFormat('y-MM-dd').format(endDate)});
      }
    }

    for (var i in dates) {
      final List<String> splitStart = i['start'].toString().split('-');
      final List<String> splitEnd = i['end'].toString().split('-');

      final timeStart = DateTime(int.parse(splitStart[0]), int.parse(splitStart[1]), int.parse(splitStart[2])).toLocal();
      final timeEnd = DateTime(int.parse(splitEnd[0]), int.parse(splitEnd[1]), int.parse(splitEnd[2])).add(const Duration(days: 1)).toLocal();

      if (now.toLocal().millisecondsSinceEpoch >= timeStart.millisecondsSinceEpoch && now.toLocal().millisecondsSinceEpoch <= timeEnd.millisecondsSinceEpoch) {
        final start = DateTime.parse(i['start']);
        final end = DateTime.parse(i['end']);

        startPeriod.value = i['start'];
        periodDate.value = '${DateFormat('dd.MM.y').format(start)} - ${DateFormat('dd.MM.y').format(end)}';
        periodId.value = i['id'];
        period = periods.firstWhereOrNull((element) => element.id == i['id'])!.obs;
        periodDayCount.value = end.daysSince(start);
        break;
      }
    }
  }

  Future<void> getTables() async {
    tables.clear();
    expensePeriod.value = 0;
    var list = <List<dynamic>>[];
    final double expenseTotal = expenses.where((p0) => p0.planningId == period?.value.planningId && p0.categoryId != 0).map((e) => [6,7].contains(e.categoryId) ? ((e.price / 100) * (period?.value.price ?? 0)) : e.price).fold(0, (a, b) => a + b);
    final DateTime startDay = DateTime.parse(startPeriod.value);
    final String now = DateFormat('dd.MM.y').format(DateTime.now());
    realExpense.value = expenseTotal;
    realIncome.value = incomes.where((element) => element.categoryId != 0 && element.periodId == periodId.value).map((element) => element.price).fold(0, (a, b) => a + b);
    final incomeSum = incomes.where((element) => element.categoryId == 0 && element.periodId == periodId.value).map((element) => element.price).fold(0, (a, b) => a + b);
    realCleanTotal.value = incomeSum - realIncome.value;
    cleanIncome.value = incomeSum - expenseTotal;
    double spendTotal = 0;
    toDayRealPrice.value = realCleanTotal.value / (periodDayCount.value + 1);

    List<dynamic> prevList = <dynamic>[];
    List<double> spendingPrevPrice = <double>[];

    for (var i = 0; i < periodDayCount.value + 1; i++) {
      final DateTime date = DateTime(startDay.year, startDay.month, startDay.day, DateTime.now().hour).add(Duration(days: i));
      double spendingToDay = spendings.where((element) => element.date == DateFormat('dd.MM.y').format(date) && element.periodId == periodId.value && (element.type ?? false)).map((element) => element.price).fold(0, (a, b) => a + b);
      spendingToDay -= spendings.where((element) => element.date == DateFormat('dd.MM.y').format(date) && element.periodId == periodId.value && !(element.type ?? false)).map((element) => element.price).fold(0, (a, b) => a + b);
      final String cell1Str = spendingToDay > 0 ? convertPrice(spendingToDay, char: ',', symbol: '') : '';
      double spendingPlanPrice = spendingPlan.where((element) => element.date == DateFormat('dd.MM.y').format(date)).map((element) => element.price).fold(0, (a, b) => a + b);
      String upDown = '';
      expensePeriod.value += spendingToDay > 0 ? spendingToDay : 0.0;
      spendTotal += spendingToDay;

      // доход
      double income = 0.0;

      double cell2 = 0.0;
      double cell3 = 0.0;
      double cell4 = 0.0;

      if (i > 0) {
        if (expenseTotal > realIncome.value) {
          income = cleanIncome.value;
          cell2 = (cleanIncome.value / (periodDayCount.value + 1)) + prevList[4];
        } else {
          income = realCleanTotal.value;
          cell2 = (realCleanTotal.value / (periodDayCount.value + 1)) + prevList[4];
        }

        if (prevList[1] == '') {
          if (spendingPrevPrice.isNotEmpty) {
            cell3 = spendingPrevPrice.last;
          } else {
            cell3 = prevList[3];
          }
        } else {
          cell3 = ((income - spendTotal) / ((periodDayCount.value + 1) - (i + 1) + 1));
        }

        if (spendingPlanPrice > 0) {
          spendingPrevPrice.add(cell3);
          double changeCell3 = 0;
          int dateNowIndex = 0;

          for (var index = 0; index < i; index++) {
            if (now == list[index][0]) {
              dateNowIndex = index;
            }
          }

          if (spendingPlanPrice > cell3) {
            upDown = '1';
            changeCell3 = (spendingPlanPrice - cell3) / (list.length - 1);

            for (var index = dateNowIndex; index < i; index++) {
              list[index][3] = (double.tryParse('${list[index][2]}') ?? 0) - changeCell3;
              list[index][6] = '1';
            }
          } else {
            upDown = '0';
            changeCell3 = (cell3 - spendingPlanPrice) / (list.length - 1);

            for (var index = dateNowIndex; index < i; index++) {
              list[index][3] = (double.tryParse('${list[index][2]}') ?? 0) + changeCell3;
              list[index][6] = '0';
            }
          }

          cell3 = spendingPlanPrice;
        }

        cell4 = cell2 - spendingToDay;
      } else {
        if (expenseTotal > realIncome.value) {
          cell2 = (cleanIncome.value / (periodDayCount.value + 1));
        } else {
          cell2 = (realCleanTotal.value / (periodDayCount.value + 1));
        }

        cell3 = spendingPlanPrice == 0.0 ? cell2 : spendingPlanPrice;
        cell4 = cell2 - spendingToDay;
      }

      if (now == DateFormat('dd.MM.y').format(date)) {
        toDayPrice.value = cell3;

        if (toDayPrice.value < 0) {
          toDayPriceMin.value = true;
        } else {
          toDayPriceMin.value = false;
        }
      }

      final arrList = [DateFormat('dd.MM.y').format(date), cell1Str, cell2, cell3, cell4.ceil(), date.weekday == 6 || date.weekday == 7 ? '1' : '', upDown, spendingPlanPrice, date.toLocal().millisecondsSinceEpoch > DateTime.now().toLocal().millisecondsSinceEpoch];

      list.add(arrList);
      prevList = arrList;
    }

    list.insert(0, [tr('text_table_5'), tr('text_table_1'), tr('text_table_2'), tr('text_table_3'), tr('text_table_4')]);

    tables.addAll(list);

    for (var i in tables) {
      if (i[0] == DateFormat('dd.MM.y').format(DateTime.now())) {
        toDayPrice.value = i[3];

        if (toDayPrice.value < 0) {
          toDayPriceMin.value = true;
        } else {
          toDayPriceMin.value = false;
        }
      }
    }
  }

  Future<void> getSpendings() async {
    spendings.clear();
    spendings.addAll(await DashboardNetwork.getSpendings(periodId.value));
    spendingPlan.clear();
    spendingPlan.addAll(await SpendingPlanNetwork.getSpendingById(periodId.value));
  }

  Future<void> getPeriods() async {
    periods.clear();
    periods.addAll(await PlanningNetwork.getPeriods(all: true));
    salary.value = 0.0;

    if (periods.isNotEmpty) {
      expenses.clear();

      for (var i in periods) {
        if (i.planning?.expenses != null) {
          expenses.addAll(i.planning!.expenses!.toList());
        }
      }
    } else {
      Get.offAllNamed('/period');
    }
  }
}