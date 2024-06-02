import 'package:affordable/network/dashboard/spending.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/spending_response_model.dart';
import '../../utils/extension.dart';

class SpendingEditController extends GetxController {
  SpendingEditController(String dateStr, int pId) {
    periodId = pId;
    date.value = dateStr;
    getSpending();
  }

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
    price.text = '';
    super.onInit();
  }

  void changeButton() {
    endSumStrCopy.clear();

    if (endSumStr.isNotEmpty && price.text != '') {
      double priceD = 0;

      if (price.text.contains('-')) {
        priceD = -(double.tryParse(price.text.replaceAll('-', '').replaceAll('.', '')) ?? 0);
      } else {
        priceD = double.tryParse(price.text.replaceAll('-', '').replaceAll('.', '')) ?? 0;
      }

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
      spendingList.clear();

      await SpendingNetwork.getSpending(date.value).then((value) {
        spendingList.addAll(value);
        endSumStr.value = spendingList.map((element) => convertPrice(double.parse('${element.price}'))).toList();
        endSum.value = 0;

        for (var i in spendingList) {
          endSum.value += i.price;
        }
      });
    }
  }

  Future<void> editSpending() async {
    submitButton.value = true;

    if (formKey.currentState!.validate()) {
      if (await SpendingNetwork.editSpending({
        'price': price.text,
        'period_id': periodId,
        'date': date.value == '' ? DateFormat('dd.MM.y').format(DateTime.now()) : date.value
      })) {
        submitButton.value = false;
        Get.back();
      }
    }
  }

  Future<void> removeSpending() async {
    removeButton.value = true;

    if (await SpendingNetwork.deleteSpending(date.value)) {
      await getSpending();
      removeButton.value = false;
    }
  }
}