import 'dart:async';
import 'package:affordable/utils/extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../../network/auth/confirmation.dart';

class ConfirmationController extends GetxController {
  String code = '';
  bool editing = false;
  int count = 60;
  String strCount = '60';
  Timer? timer;
  bool useCode = false;
  int shareId = 0;

  @override
  void onInit() {
    if ((prefs?.getInt('share_id') ?? 0) != 0) {
      shareId = prefs?.getInt('share_id') ?? 0;
    }

    useCode = Get.arguments != null && Get.arguments['useCode'] != null && Get.arguments['useCode'] == 1;

    if (!useCode) {
      startTimer();
    } else {
      reSend();
    }

    super.onInit();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      count--;

      if (count > 9) {
        strCount = '$count';
      } else {
        strCount = '0$count';
      }

      if (count == 0) {
        timer.cancel();
      }

      update();
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    useCode = false;
    super.onClose();
  }

  void setCode(String val) {
    code = val;

    if (code.length == 6) {
      confirm();
    }

    update();
  }

  void setEditing(bool val) {
    editing = val;
    update();
  }

  Future<void> reSend() async {
    final token = await ConfirmationNetwork.reSend(Get.arguments['email']!);

    if (token) {
      snackBar(text: tr('text_code_send'));
      code = '';
      editing = false;
      count = 60;
      strCount = '60';
      startTimer();
    }
  }

  Future<void> confirm() async {
    final token = await ConfirmationNetwork.confirm(code, Get.arguments?['email']!, shareId: shareId);

    if (token) {
      if (shareId > 0) {
        prefs?.remove('share_id');
      }

      Get.offAllNamed('/success_register');
    }
  }
}