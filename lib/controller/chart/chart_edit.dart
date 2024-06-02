import 'dart:async';
import 'package:affordable/utils/extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../../model/chart_response_model.dart';
import '../../network/chart/chart.dart';

class ChartEditController extends GetxController {
  ChartEditController(ChartResponseModel? item) {
    nameEdit.text = item?.name ?? '';
    chart = item;
    buttonVisible.value = nameEdit.text != '';
  }

  RxBool isLoading = false.obs;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  ChartResponseModel? chart;
  TextEditingController nameEdit = TextEditingController();
  final formKey = GlobalKey<FormState>();
  RxBool buttonSubmit = false.obs;
  RxBool buttonVisible = false.obs;
  RxBool buttonDeleteSubmit = false.obs;
  RxBool section = false.obs;
  RxBool section2 = false.obs;
  RxBool section3 = false.obs;
  RxBool section4 = false.obs;
  RxBool section5 = false.obs;
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollControllerFormula = ScrollController();
  final ScrollController scrollControllerFormulaList = ScrollController();
  RxList<String> formulaText = <String>[].obs;
  RxList<String> formula = <String>[].obs;
  RxBool prefix = false.obs;
  RxString operation = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  void changeNameChart() {
    if (chart != null && nameEdit.text != '') {
      ChartNetwork.changeNameChart(chart!, nameEdit.text);
    }
  }

  void clear() {
    section.value = false;
    section2.value = false;
    section3.value = false;
    section4.value = false;
    formula.clear();
    formulaText.clear();
  }

  void initialize() async {
    isLoading.value = true;
  }

  void removeChart() async {
    if (!buttonDeleteSubmit.value) {
      buttonDeleteSubmit.value = true;

      await ChartNetwork.removeChart(chart?.id ?? 0).then((value) {
        if (value) {
          prefs?.remove('chart_${chart?.id ?? 0}_type');
          chart = null;
          update();
          Get.back();
        }
      });
    }

    buttonDeleteSubmit.value = false;
  }

  void deleteFormula(int id) async {
    final int length = chart?.formulaList?.length ?? 0;

    await ChartNetwork.deleteFormula(id).then((value) {
      chart = value;

      if (length == 1) {
        prefs?.remove('chart_${value?.id ?? 0}_type');
      }

      update();
    });
  }

  void setOperation(String val) {
    if (prefix.value && formula.isNotEmpty) {
      formulaText.removeLast();
      formula.removeLast();
      prefix.value = false;
    } else if (searchPrefix(val) && searchPrefix(formula.last)) {
      formulaText.removeLast();
      formula.removeLast();
      prefix.value = false;
    }

    if (formulaText.isNotEmpty) {
      operation.value = val;
      prefix.value = true;
      formula.add(val);
      formulaText.add(val);
    } else {
      prefix.value = false;
      snackBar(error: true, text: tr('error_formula_select'));
    }
  }

  void changeButton() {
    if (formKey.currentState!.validate()) {
      buttonVisible.value = true;
    } else {
      buttonVisible.value = false;
    }
  }

  bool searchPrefix(String val) {
    return val.contains('+') || val.contains('-') || val.contains('/') || val.contains('*');
  }

  void removeFormula(int index) async {
    if (formula.length - 1 >= index + 1) {
      formula.removeAt(index + 1);
      formulaText.removeAt(index + 1);
    }

    formula.removeAt(index);
    formulaText.removeAt(index);

    if (formula.isNotEmpty) {
      operation.value = formula.last;
      prefix.value = false;
    }
  }

  void setSection(int index, int param) {
    operation.value = '';
    List<List<String>> list = [
      [tr('text_plan_income'), tr('text_dop_income'), tr('text_fact_income')],
      [tr('text_plan_expense'), tr('text_dop_expense'), tr('text_fact_expense')],
      [tr('text_plan_invest'), tr('text_dop_invest'), tr('text_fact_invest')],
      [tr('text_plan_money_box'), tr('text_dop_money_box'), tr('text_fact_money_box')],
      [tr('text_plan_spending'), tr('text_fact_spending'), tr('text_saldo_spending'), tr('text_nokop_spending')]
    ];

    if (!prefix.value && formulaText.isNotEmpty) {
      formula.removeLast();
      formulaText.removeLast();
    }

    prefix.value = false;

    formulaText.add(list[index][param]);
    formula.add('$index$param');

    if (scrollControllerFormula.hasClients) {
      Timer.periodic(const Duration(milliseconds: 100), (timer) {
        scrollControllerFormula.jumpTo(scrollControllerFormula.position.maxScrollExtent);
        timer.cancel();
      });
    }
  }

  bool getDayIncome({bool type = false}) {
    List<String> items = <String>[];

    for (var i in formula) {
      items.add(i);
    }

    if (chart != null && chart!.formulaList != null && chart!.formulaList!.isNotEmpty) {
      for (var i in chart!.formulaList!) {
        items.add(i.formula);
      }
    }

    bool item = items.contains('40') || items.contains('41') || items.contains('42') || items.contains('43');

    if (!type) {
      return item;
    } else {
      return items.isEmpty || items.isNotEmpty && item;
    }
  }

  Future<void> edit(int id, int idFormula) async {
    if (!searchPrefix(formulaText.last)) {
      if (!buttonSubmit.value && formKey.currentState!.validate()) {
        buttonSubmit.value = true;

        if (id == 0) {
          await ChartNetwork.addChart(nameEdit.text, formula.join('|'), formulaText.join("\r\n")).then((value) {
            chart = value;
            update();
            Get.back();
          });
        } else {
          await ChartNetwork.editChart(id, idFormula, nameEdit.text, formula.join('|'), formulaText.join("\r\n")).then((value) {
            chart = value;
            update();
            Get.back();
          });
        }
      }

      buttonSubmit.value = false;
    } else {
      snackBar(error: true, text: tr('error_formula'));
    }
  }
}