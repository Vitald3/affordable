import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/spending_response_model.dart';
import '../../network/dashboard/spending_plan.dart';
import '../../utils/extension.dart';

class SpendingPlanEditController extends GetxController {
  SpendingPlanEditController(String dateStr, int pId, double priceDouble) {
    periodId = pId;
    date.value = dateStr;
    pricePlan = priceDouble;
    price.text = priceDouble > 0 ? priceDouble.toStringAsFixed(0) : '';
    buttonVisible = (priceDouble > 0).obs;
    getSpending();

    if (priceDouble > 0 && dateStr != '') {
      buttonVisible.value = true;
    }
  }

  double pricePlan = 0;
  int periodId = 0;
  RxList<SpendingResponseModel> spendingList = <SpendingResponseModel>[].obs;
  RxString date = ''.obs;
  double height = (Get.height - ((MediaQuery.of(Get.context!).padding.top + kToolbarHeight) + Get.statusBarHeight + 130));
  final formKey = GlobalKey<FormState>();
  TextEditingController price = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  RxBool buttonVisible = false.obs;
  RxBool removeButton = false.obs;
  RxBool submitButton = false.obs;
  RxList<String> endSumStr = <String>[].obs;
  RxList<String> endSumStrCopy = <String>[].obs;
  RxDouble endSum = 0.0.obs;
  RxDouble endSumCopy = 0.0.obs;
  Rx<DateTime> selectDate = DateTime.now().obs;

  @override
  void onInit() {
    dateInput.text = date.value == '' ? DateFormat('dd.MM.y').format(DateTime.now()) : date.value;
    super.onInit();
  }

  void changeButton() {
    endSumStrCopy.clear();

    if (endSumStr.isNotEmpty && price.text != '') {
      final double priceD = double.parse(price.text);
      endSumCopy.value = priceD;
      endSumStrCopy.add(convertPrice(priceD));
    }

    if (formKey.currentState!.validate()) {
      buttonVisible.value = true;
    } else {
      buttonVisible.value = false;
    }
  }

  Future<void> getSpending() async {
    buttonVisible.value = false;

    if (date.value != '') {
      await SpendingPlanNetwork.getSpending(date.value).then((value) {
        spendingList.addAll(value);
        endSumStr.value = spendingList.map((element) => convertPrice(double.parse('${element.price}'))).toList();
        endSum.value = 0;

        for (var i in spendingList) {
          if (i.price > 0) {
            endSum.value += i.price;
          } else {
            endSum.value -= i.price;
          }
        }
      });
    }
  }

  Future<void> editSpending() async {
    submitButton.value = true;

    if (formKey.currentState!.validate()) {
      if (await SpendingPlanNetwork.editSpending({
        'price': price.text,
        'period_id': periodId,
        'date': date.value == '' ? DateFormat('dd.MM.y').format(DateTime.now()) : date.value
      })) {
        submitButton.value = false;
        Get.back();
      }
    }
  }

  Future<void> deleteSpending() async {
    removeButton.value = true;

    if (formKey.currentState!.validate()) {
      if (await SpendingPlanNetwork.deleteSpending(date.value == '' ? DateFormat('dd.MM.y').format(DateTime.now()) : date.value)) {
        removeButton.value = false;
        Get.back();
      }
    }
  }
}