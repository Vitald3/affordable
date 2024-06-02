import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/category_response.dart';
import '../../model/expense_response.dart';
import '../../model/period_response_model.dart';
import '../../network/setting/planning.dart';
import '../../network/setting/planning_category.dart';

class CategoryEditController extends GetxController {
  CategoryEditController(int planningId, int pId, int selectId) {
    id = planningId;

    if (id == 0) {
      PlanningNetwork.getPeriod(pId, id: 0, addPlanning: true).then((value) {
        period = value;
        id = period?.planningId ?? 0;
      });
    }

    periodId = pId;
    selectCategoryId = selectId;
  }

  int id = 0;
  int periodId = 0;
  var periods = <PeriodResponseModel>[];
  PeriodResponseModel? period;
  int selectCategoryId = 0;
  var categories = <CategoryResponse>[];
  List<ExpenseResponse>? expenses;
  CategoryResponse? selectCategory;
  TextEditingController name = TextEditingController();
  FocusNode focusName = FocusNode();
  TextEditingController textPrice = TextEditingController();
  FocusNode focusPrice = FocusNode();
  RxDouble total = 0.0.obs;
  RxDouble dayTotal = 0.0.obs;
  RxBool buttonSend = false.obs;
  RxBool buttonSubmit = false.obs;
  RxBool borderBool = false.obs;
  double height = (Get.height - (MediaQuery.of(Get.context!).padding.top + kToolbarHeight) - Get.statusBarHeight);
  ScrollController scrollController = ScrollController();

  @override
  void onInit() async {
    getPeriod().then((value) {
      List<CategoryResponse> cats = period?.planning?.categories ?? <CategoryResponse>[];

      if (cats.isNotEmpty) {
        selectCategory = cats.where((element) => element.id == selectCategoryId).firstOrNull;
        expenses = selectCategory?.expenses ?? [];
        update();
      }

      PlanningNetwork.getPeriods().then((value) {
        periods = value;
        calculate();
        update();
      });

      PlanningNetwork.getCategories(id).then((value) {
        categories = value;

        if (selectCategory == null && selectCategoryId != 0) {
          selectCategory = categories.where((element) => element.id == selectCategoryId).firstOrNull;
          expenses = selectCategory?.expenses ?? [];
        }

        update();
      });
    });

    super.onInit();
  }

  @override
  void onClose() {
    period = null;
    name.clear();
    textPrice.clear();
    selectCategory = null;
    categories = [];
    expenses = [];
    scrollController.dispose();
    super.onClose();
  }

  Future<void> getPeriod() async {
    period = await PlanningNetwork.getPeriod(periodId, id: id);

    if ((period?.planning?.id ?? 0) > 0) {
      id = period!.planning!.id;
    }
  }

  void updateButton() {
    final String nameStr = name.text;
    final String price = textPrice.text;
    textPrice.text = textPrice.text.replaceAll(',', '.');

    if (nameStr != '' && (double.tryParse(price.replaceAll(',','.')) ?? 0) > 0.0) {
      buttonSend.value = true;
    } else {
      buttonSend.value = false;
    }
  }

  Future<void> getCategories() async {
    if (selectCategory != null) {
      expenses = await PlanningCategoryNetwork.getExpense(id, selectCategory!.id);
      calculate();
      update();
    }
  }

  void calculate() {
    total.value = 0.0;
    int daysCount = 0;

    if (period != null) {
      if (expenses != null && expenses!.isNotEmpty) {
        for (var expense in expenses!.where((element) => element.planningId == id)) {
          if (selectCategory?.percent ?? false) {
            total.value += ((expense.price / 100) * period!.price);
          } else {
            total.value += expense.price;
          }
        }
      }

      double totalValue = 0;

      final categoriesExpense = (period?.planning?.categories ?? <CategoryResponse>[]).where((e) => e.expenses != null && e.expenses!.isNotEmpty).toList();

      for (var category in categoriesExpense) {
        for (var expense in category.expenses ?? <ExpenseResponse>[]) {
          if (category.percent) {
            totalValue += ((expense.price / 100) * period!.price);
          } else {
            totalValue += expense.price;
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
        dayTotal.value = double.parse('${((period!.price - totalValue) / daysCount).ceil()}');
      }
    }
  }

  void setCategory(CategoryResponse val) {
    selectCategory = val;
    expenses = [];
    getCategories();
    Get.back();
  }

  void setBorder(bool val) {
    borderBool.value = val;
  }

  void deleteExpense(int id) async {
    if (await PlanningCategoryNetwork.deleteExpense(id)) {
      await getPeriod();
      getCategories();
    }
  }

  Future<void> addExpense(int? expenseId) async {
    if (buttonSubmit.value) {
      return;
    }

    final String nameStr = name.text;
    final String price = textPrice.text;
    bool priceError = false;

    if (price != '' && selectCategory!.percent && (((double.tryParse(price.replaceAll(',','.')) ?? 0) == 0.0) || ((double.tryParse(price.replaceAll(',','.')) ?? 0) > 100))) {
      priceError = true;
    }

    if (nameStr != '' && !priceError) {
      FocusScope.of(Get.context!).unfocus();
      buttonSubmit.value = true;

      if (await PlanningCategoryNetwork.addExpense({
        'name': nameStr,
        'price': price,
        'planning_id': id,
        'category_id': selectCategory!.id
      }, expenseId)) {
        await getPeriod();
        getCategories().then((value) {
          name.text = '';
          textPrice.text = '';
          buttonSend.value = false;
          buttonSubmit.value = false;
        });
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
}