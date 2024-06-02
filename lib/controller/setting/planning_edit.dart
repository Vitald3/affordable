import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/category_response.dart';
import '../../model/expense_response.dart';
import '../../model/period_response_model.dart';
import '../../network/setting/planning.dart';
import '../../network/setting/planning_category.dart';

class PlanningEditController extends GetxController {
  PlanningEditController(int val, int pId) {
    id = val;
    periodId = pId;
  }

  int id = 0;
  int periodId = 0;
  var periods = <PeriodResponseModel>[];
  var categories = <CategoryResponse>[];
  var categoriesExpense = <CategoryResponse>[];
  PeriodResponseModel? period;
  RxDouble total = 0.0.obs;
  RxDouble totalDay = 0.0.obs;
  TextEditingController name = TextEditingController();
  FocusNode focusName = FocusNode();
  TextEditingController textPrice = TextEditingController();
  FocusNode focusPrice = FocusNode();
  RxBool buttonSend = false.obs;
  RxBool buttonSubmit = false.obs;

  @override
  void onInit() async {
    period = await PlanningNetwork.getPeriod(periodId, id: id, addPlanning: true);

    if (period?.planning?.id != null) {
      id = period!.planning!.id;
    }

    if (id > 0) {
      categories = await PlanningNetwork.getCategories(id);
    }

    categoriesExpense = (period?.planning?.categories ?? <CategoryResponse>[]).where((e) => e.expenses != null && e.expenses!.isNotEmpty).toList();
    update();

    PlanningNetwork.getPeriods().then((value) {
      periods = value;
      calculate();
      update();
    });

    super.onInit();
  }

  @override
  void onClose() {
    period = null;
    periods = [];
    categories = [];
    categoriesExpense = [];
    total = 0.0.obs;
    totalDay = 0.0.obs;
    name.clear();
    textPrice.clear();
    buttonSend.value = false;
    buttonSubmit.value = false;
    super.onClose();
  }

  void updateButton() {
    final String nameStr = name.text;
    final String price = textPrice.text;

    if (nameStr != '' && (double.tryParse(price) ?? 0) > 0.0) {
      buttonSend.value = true;
    } else {
      buttonSend.value = false;
    }
  }

  Future<void> addExpense(int? expenseId, bool percent, int selectCategory) async {
    if (buttonSubmit.value) {
      return;
    }

    final String nameStr = name.text;
    final String price = textPrice.text;
    bool priceError = false;

    if (price != '' && percent && ((price.length <= 3 && (int.tryParse(price) ?? 0) == 0.0) || ((int.tryParse(price) ?? 0) > 100) || price.length > 3)) {
      priceError = true;
    }

    if (nameStr != '' && !priceError) {
      FocusScope.of(Get.context!).unfocus();
      buttonSubmit.value = true;

      if (await PlanningCategoryNetwork.addExpense({
        'name': nameStr,
        'price': price,
        'planning_id': id,
        'category_id': selectCategory
      }, expenseId)) {
        buttonSubmit.value = false;
        getPeriod();
      }

      Get.back();
    } else {
      if (nameStr == '') {
        focusName.requestFocus();
      } else if ((double.tryParse(price) ?? 0) == 0.0) {
        focusPrice.requestFocus();
      } else if (priceError) {
        focusPrice.requestFocus();
      }
    }
  }

  void calculate() {
    total.value = 0.0;
    int daysCount = 0;

    if (period != null) {
      for (var category in categoriesExpense) {
        for (var expense in category.expenses ?? <ExpenseResponse>[]) {
          if (category.percent) {
            total.value += ((expense.price / 100) * period!.price);
          } else {
            total.value += expense.price;
          }
        }
      }

      for (var (index, element) in periods.indexed) {
        if (element.id == period!.id) {
          if (index == 0) {
            daysCount = element.day;
          } else {
            daysCount = element.day - (periods[--index].day + 1);
          }

          break;
        }
      }

      if (daysCount > 0) {
        totalDay.value = double.parse('${((period!.price - total.value) / daysCount).ceil()}');
      }
    }
  }

  void getPeriod() async {
    periods = await PlanningNetwork.getPeriods();
    period = await PlanningNetwork.getPeriod(periodId, id: id);
    categories = await PlanningNetwork.getCategories(id);

    if (period != null) {
      if (period?.planning?.id != null && (period?.planning?.id ?? 0) > 0) {
        id = period?.planning?.id ?? 0;
      }

      if (period?.id != null && (period?.id ?? 0) > 0) {
        periodId = period?.id ?? 0;
      }

      categoriesExpense = (period?.planning?.categories ?? <CategoryResponse>[]).where((e) => e.expenses != null && e.expenses!.isNotEmpty).toList();
    }

    calculate();
    update();
  }
}