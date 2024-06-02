import 'package:affordable/network/award/award.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../../model/category_response.dart';
import '../../model/period_response_model.dart';
import '../../network/setting/planning.dart';

class PlanningController extends GetxController {
  List<PeriodResponseModel> periods = <PeriodResponseModel>[];
  bool save = false;
  var categories = <CategoryResponse>[];

  @override
  void onInit() {
    getPeriods();
    super.onInit();
  }

  @override
  void onClose() {
    periods = [];
    super.onClose();
  }

  void nextOpen() {
    prefs?.setBool('level', true);
    prefs?.setInt('award', 2);
    AwardNetwork.setAward(2);
    Get.offAllNamed('/menu');
  }

  List<double> calculate(PeriodResponseModel period) {
    double total = 0.0;
    double dayTotal = 0.0;
    int daysCount = 0;

    if (period.planning?.categories != null) {
      for (var category in period.planning?.categories?.where((element) => element.expenses != null && element.expenses!.isNotEmpty) ?? <CategoryResponse>[]) {
        for (var expense in category.expenses!) {
          if (category.percent) {
            total += ((expense.price / 100) * period.price);
          } else {
            total += expense.price;
          }
        }
      }
    }

    for (var (index, element) in periods.indexed) {
      if (element.id == period.id) {
        if (index == 0) {
          daysCount = element.day;
        } else {
          daysCount = element.day - (periods[--index].day + 1);
        }

        break;
      }
    }

    if (daysCount > 0) {
      dayTotal = double.parse('${((period.price - total) / daysCount).ceil()}');
    }

    return [total, dayTotal];
  }

  List<double> calculateAll() {
    double total = 0.0;
    double dayTotal = 0.0;
    double periodPrice = 0.0;
    int daysCount = 0;

    for (var period in periods) {
      if (period.planning?.categories != null) {
        periodPrice += period.price;

        for (var category in period.planning?.categories?.where((element) => element.expenses != null && element.expenses!.isNotEmpty) ?? <CategoryResponse>[]) {
          for (var expense in category.expenses!) {
            if (category.percent) {
              total += ((expense.price / 100) * period.price);
            } else {
              total += expense.price;
            }
          }
        }
      }
    }

    for (var (index, element) in periods.indexed) {
      if (index == 0) {
        daysCount += element.day;
      } else {
        daysCount += (element.day - (periods[--index].day + 1));

        if (periods.length-1 == index && daysCount < daysInMonth(DateTime.now())) {
          daysCount = daysInMonth(DateTime.now()) - daysCount;
        }
      }
    }

    if (daysCount > 0 && total > 0) {
      dayTotal = double.parse('${((periodPrice - total) / daysCount).ceil()}');
    }

    return [total, dayTotal];
  }

  int daysInMonth(DateTime date) => DateTimeRange(start: DateTime(date.year, date.month, 1), end: DateTime(date.year, date.month + 1)).duration.inDays;

  Future<void> getPeriods() async {
    PlanningNetwork.getCategories(0).then((value) async {
      categories = value;
      periods = await PlanningNetwork.getPeriods(all: true);
      save = periods.where((e) => (e.planning?.categories?.where((element) => element.expenses != null && element.expenses!.isNotEmpty) ?? []).isNotEmpty).length == periods.length;
      update();
    });
  }
}