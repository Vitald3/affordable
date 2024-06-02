import 'package:affordable/main.dart';
import 'package:affordable/utils/constant.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  RxInt languageId = (prefs?.getInt('languageId') ?? languagesList.first.id).obs;

  void setLanguage(BuildContext context, int id) async {
    languageId.value = id;
    prefs?.setInt('languageId', id);
    await context.setLocale(Locale(languagesList.firstWhereOrNull((element) => element.id == id)?.code ?? languagesList.first.code));
    await Get.updateLocale(Locale(languagesList.firstWhereOrNull((element) => element.id == id)?.code ?? languagesList.first.code));
  }
}