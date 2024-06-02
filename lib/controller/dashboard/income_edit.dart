import 'package:affordable/model/expense_response.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../../model/award_response_model.dart';
import '../../model/income_response.dart';
import '../../network/award/award.dart';
import '../../network/dashboard/income.dart';
import '../../view/dashboard/spending_edit.dart';

class IncomeEditController extends GetxController {
  RxList<IncomeResponseModel> incomes = <IncomeResponseModel>[].obs;
  RxInt incomeId = 0.obs;
  RxInt categoryId = 0.obs;
  int periodId = 0;
  RxInt expenseId = 0.obs;
  ExpenseResponse? expense;
  RxBool buttonVisible = false.obs;
  double planFixPrice = 0.0;
  RxDouble planPrice = 0.0.obs;
  Widget? spendingWidget;
  RxString date = ''.obs;
  RxDouble priceToDay = 0.0.obs;

  IncomeEditController(String dateStr, double priceDouble, List<IncomeResponseModel> incomesList, int iId, int? cId, int pId, int eId, Color color, double plan, List<ExpenseResponse> listExpenses, int? type) {
    incomes.clear();
    incomes.addAll(incomesList);
    incomeId.value = iId;
    categoryId.value = cId ?? 0;
    periodId = pId;
    expenseId.value = eId;
    name.text = '';
    price.text = '';
    planFixPrice = plan;
    planPrice.value = plan;
    date.value = dateStr;
    priceToDay.value = priceDouble;

    if (cId == null) {
      title.value = tr('text_day_expense');
      activeIndex.value = 0;
      spendingWidget = SpendingEditView(date: date.value, priceToDay: priceToDay.value, periodId: periodId);
    } else if (cId == 0) {
      title.value = tr('text_income');
      activeIndex.value = 1;
    } else if (cId == 5) {
      title.value = tr('text_require_expense');
      activeIndex.value = 2;
    } else if (cId == 6) {
      title.value = tr('text_investments');
      activeIndex.value = 3;
    } else if (cId == 7) {
      title.value = tr('text_money_box');
      activeIndex.value = 4;
    }

    if (categoryId.value == 0) {
      sheetText.value = tr('text_unplanned_income');
    } else if (categoryId.value == 5) {
      sheetText.value = tr('text_unplanned_expense_2');
    } else if (categoryId.value == 6 || categoryId.value == 7) {
      sheetText.value = tr('text_unplanned_invest_2');
    } else {
      sheetText.value = tr('text_unplanned_income');
    }

    expenses.value = listExpenses;

    if (iId > 0) {
      income = incomes.firstWhere((element) => element.id == iId).obs;
      selectLabel.value = income!.value.name;
      name.text = income!.value.name;
      price.text = '${income!.value.price}';
      buttonVisible.value = true;
    } else {
      unplanned.value = true;

      if (categoryId.value == 0) {
        if (color == Colors.red && type == null) {
          selectLabel.value = tr('text_salary');
        } else {
          selectLabel.value = tr('text_unplanned_income');
        }

        sheetText.value = tr('text_unplanned_income');
      } else if (categoryId.value == 5) {
        selectLabel.value = tr('text_unplanned_expense');
        sheetText.value = tr('text_unplanned_expense_2');
      } else if (categoryId.value == 6 || categoryId.value == 7) {
        selectLabel.value = tr('text_unplanned_invest');
        sheetText.value = tr('text_unplanned_invest_2');
      } else {
        selectLabel.value = tr('text_salary');
        sheetText.value = tr('text_unplanned_income');
      }

      for (var i in listExpenses) {
        if (i.id == eId) {
          selectLabel.value = i.name;
        }
      }
    }
  }

  RxString title = ''.obs;
  RxInt activeIndex = 0.obs;
  double height = (Get.height - ((MediaQuery.of(Get.context!).padding.top + kToolbarHeight) + Get.statusBarHeight + 130));
  RxBool borderBool = false.obs;
  RxBool unplanned = false.obs;
  RxBool submitButton = false.obs;
  RxBool removeButton = false.obs;
  RxString selectLabel = ''.obs;
  RxString sheetText = ''.obs;
  TextEditingController price = TextEditingController();
  TextEditingController name = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Rx<IncomeResponseModel>? income;
  final ScrollController scrollController = ScrollController();
  RxList<ExpenseResponse> expenses = <ExpenseResponse>[].obs;

  void changeButton() {
    if (formKey.currentState!.validate()) {
      buttonVisible.value = true;
    } else {
      buttonVisible.value = false;
    }
  }

  Future<void> editIncome(int id) async {
    submitButton.value = true;

    if (formKey.currentState!.validate()) {
      if (await IncomeNetwork.editIncome(id, {
        'name': name.text != '' ? name.text : selectLabel.value,
        'price': price.text.replaceAll('+', '').replaceAll('.', '').replaceAll('-', '').replaceAll('_', ''),
        'period_id': periodId,
        'salary': selectLabel.value == tr('text_salary'),
        'category_id': categoryId.value,
        'expense_id': expenseId.value,
        'unplanned': unplanned.value
      })) {
        final List<AwardResponseModel> awards = await AwardNetwork.getAwards();
        List<String> list = <String>[];

        if (incomes.isEmpty) {
          list.add('3');
        } else if (awards.where((element) => element.award == 'award_4').isEmpty && unplanned.value && incomes.where((p0) => p0.unplanned).isEmpty) {
          list.add('4');
        } else if (awards.where((element) => element.award == 'award_10').isEmpty && categoryId.value == 6 && incomes.where((p0) => p0.categoryId == 6).isEmpty) {
          list.add('10');
        } else if (awards.where((element) => element.award == 'award_11').isEmpty && categoryId.value == 7 && incomes.where((p0) => p0.categoryId == 7).isEmpty) {
          list.add('11');
        } else if (awards.where((element) => element.award == 'award_15').isEmpty && incomes.where((p0) => p0.categoryId == 6).length > 3) {
          list.add('15');
        } else if (id == 0 && categoryId.value == 5) {
          list.add('17');
        } else if (!(prefs?.getBool('downIncome') ?? false)) {
          prefs?.setBool('downIncome', true);
          list.add('14');
        }

        for (var i in list) {
          AwardNetwork.setAward(int.parse(i));
        }

        prefs?.setStringList('awards', list);

        submitButton.value = false;
        Get.back();
      }
    } else {
      submitButton.value = false;
    }
  }

  Future<void> removeIncome(int id) async {
    removeButton.value = true;

    if (await IncomeNetwork.deleteIncome(id)) {
      prefs?.setInt('award', 14);
      AwardNetwork.setAward(14);
      removeButton.value = false;
      Get.back();
    }
  }

  void setIncome(int id) {
    unplanned.value = false;
    name.text = '';
    price.text = '';

    if (id > 0) {
      income = incomes.firstWhere((element) => element.id == id).obs;
      incomeId.value = income!.value.id;
      expenseId.value = income!.value.expenseId ?? 0;
      selectLabel.value = income!.value.name;
      name.text = income!.value.name;
      price.text = '${income!.value.price}';
    } else {
      expenseId.value = 0;
      incomeId.value = 0;
      unplanned.value = true;

      if (categoryId.value == 0) {
        selectLabel.value = tr('text_unplanned_income');
      } else if (categoryId.value == 5) {
        selectLabel.value = tr('text_unplanned_expense');
      } else if (categoryId.value == 6 || categoryId.value == 7) {
        selectLabel.value = tr('text_unplanned_invest');
      } else {
        selectLabel.value = tr('text_salary');
      }
    }

    buttonVisible.value = name.text != '' && price.text != '';

    Get.back();
  }

  void goTo(int index) {
    activeIndex.value = index;
    unplanned.value = true;
    incomeId.value = 0;
    planPrice.value = 0.0;

    if (spendingWidget != null) {
      spendingWidget = null;
      update();
    }

    if (index == 0) {
      spendingWidget = SpendingEditView(date: '', priceToDay: 0, periodId: periodId);
      title.value = tr('text_day_expense');
      update();
    } else if (index == 1) {
      title.value = tr('text_income');
      categoryId.value = 0;
      selectLabel.value = tr('text_unplanned_income');
      sheetText.value = tr('text_unplanned_income');
    } else if (index == 2) {
      title.value = tr('text_require_expense');
      categoryId.value = 5;
      selectLabel.value = tr('text_unplanned_expense');
      sheetText.value = tr('text_unplanned_expense_2');
    } else if (index == 3) {
      title.value = tr('text_investments');
      categoryId.value = 6;
      selectLabel.value = tr('text_unplanned_invest');
      sheetText.value = tr('text_unplanned_invest_2');
    } else if (index == 4) {
      title.value = tr('text_money_box');
      categoryId.value = 7;
      selectLabel.value = tr('text_unplanned_invest');
      sheetText.value = tr('text_unplanned_invest_2');
    }

    name.text = '';
    price.text = '';

    if (income?.value.categoryId == categoryId.value) {
      incomeId.value = income!.value.id;
      planPrice.value = planFixPrice;
      selectLabel.value = income!.value.name;
      name.text = income!.value.name;
      price.text = '${income!.value.price}';
      unplanned.value = false;
    }

    buttonVisible.value = name.text != '' && price.text != '';
  }

  void setBorder(bool val) {
    borderBool.value = val;
  }
}