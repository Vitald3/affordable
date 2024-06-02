import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../../model/period_model.dart';
import '../../model/period_response_model.dart';
import '../../network/setting/period.dart';
import '../../view/dashboard/award_popup.dart';

class PeriodController extends GetxController {
  static PeriodController get to => Get.find();
  List<PeriodResponseModel> periods = <PeriodResponseModel>[];
  TextEditingController name = TextEditingController();
  final focusName = FocusNode();
  TextEditingController day = TextEditingController();
  final focusDay = FocusNode();
  TextEditingController price = TextEditingController();
  final focusPrice = FocusNode();
  RxBool submitButton = false.obs;
  RxBool switchParam = false.obs;
  RxBool buttonVisible = false.obs;
  RxInt edit = 0.obs;
  RxBool removeButton = false.obs;
  double size = 0.0;

  @override
  void onInit() {
    super.onInit();
    getPeriods();
  }

  @override
  void onClose() {
    name.dispose();
    day.dispose();
    price.dispose();
    super.onClose();
  }

  void clear() {
    name.clear();
    day.clear();
    price.clear();
    Get.back();
  }

  void getPeriods() async {
    periods = await PeriodNetwork.getPeriods();
    update();

    final int award = prefs?.getInt('award') ?? 0;

    if (award > 0) {
      awardPopup(award);
    }
  }

  void goEdit(PeriodResponseModel item) {
    name.text = item.name;
    day.text = '${item.day}';
    price.text = '${item.price}';
    switchParam.value = item.ever;
    edit.value = item.id;

    if (item.name != '' && item.day != 0 && (item.day) <= 31 && item.price != 0) {
      buttonVisible.value = true;
    }

    Get.toNamed('/period_edit')?.then((value) => getPeriods());
  }

  void changeButton() {
    final String nameStr = name.text;
    final int dayInt = int.tryParse(day.text) ?? 0;
    final int priceInt = int.tryParse(price.text) ?? 0;

    if (nameStr != '' && dayInt != 0 && (dayInt) <= 31 && priceInt != 0) {
      buttonVisible.value = true;
    } else {
      buttonVisible.value = false;
    }
  }

  Future<void> addPeriod() async {
    submitButton.value = false;
    final String nameStr = name.text;
    final int dayInt = int.tryParse(day.text) ?? 0;
    final int priceInt = int.tryParse(price.text) ?? 0;

    if (nameStr != '' && dayInt != 0 && (dayInt) <= 31 && priceInt != 0) {
      submitButton.value = true;
      final bool insert = await PeriodNetwork.addPeriod(PeriodModel(name: nameStr, day: dayInt, price: priceInt, ever: switchParam.value));

      if (insert) {
        name.clear();
        day.clear();
        price.clear();
        edit.value = 0;
        Get.back();
      }

      submitButton.value = false;
    } else {
      if (nameStr == '') {
        focusName.requestFocus();
      } else if (dayInt == 0) {
        focusDay.requestFocus();
      } else if (priceInt == 0) {
        focusPrice.requestFocus();
      }
    }
  }

  Future<void> editPeriod() async {
    final String nameStr = name.text;
    final int dayInt = int.tryParse(day.text) ?? 0;
    final int priceInt = int.tryParse(price.text) ?? 0;

    if (nameStr != '' && dayInt != 0 && (dayInt) <= 31 && priceInt != 0) {
      submitButton.value = true;
      final bool insert = await PeriodNetwork.editPeriod(edit.value, PeriodModel(name: nameStr, day: dayInt, price: priceInt, ever: switchParam.value));

      if (insert) {
        name.clear();
        day.clear();
        price.clear();
        edit.value = 0;
        Get.back();
      }

      submitButton.value = false;
    } else {
      if (nameStr == '') {
        focusName.requestFocus();
      } else if (dayInt == 0) {
        focusDay.requestFocus();
      } else if (priceInt == 0) {
        focusPrice.requestFocus();
      }
    }
  }

  Future<void> removePeriod() async {
    removeButton.value = true;
    final bool insert = await PeriodNetwork.removePeriod(edit.value);

    if (insert) {
      name.clear();
      day.clear();
      price.clear();
      edit.value = 0;
      Get.back();
    }

    removeButton.value = false;
  }
}