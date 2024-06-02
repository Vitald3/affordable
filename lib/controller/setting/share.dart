import 'dart:io';
import 'package:affordable/utils/extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/share_response_model.dart';
import '../../network/setting/share.dart';
import '../../utils/constant.dart';

class ShareController extends GetxController {
  RxBool submitButton = false.obs;
  RxBool sendButton = false.obs;
  TextEditingController email = TextEditingController();
  RxList<ShareResponseModel> shareList = <ShareResponseModel>[].obs;
  double height = (Get.height - (MediaQuery.of(Get.context!).padding.top + kToolbarHeight) - Get.statusBarHeight);
  ScrollController scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    getShare();
    super.onInit();
  }

  @override
  void onClose() {
    email.dispose();
    super.onClose();
  }
  
  Future<void> getShare() async {
    final value = await ShareNetwork.getShare();

    shareList.clear();
    shareList.addAll(value);
    email.text = '';
    updateButton();
  }

  void updateButton() {
    if (email.text != '' && EmailValidator.validate(email.text)) {
      sendButton.value = true;
    } else {
      sendButton.value = false;
    }
  }

  Future<void> addShare() async {
    if (formKey.currentState!.validate()) {
      if (Supabase.instance.client.auth.currentUser!.email == email.text) {
        snackBar(text: tr('error_unique_email'), error: true);
      } else if (shareList.where((element) => element.email == email.text).isNotEmpty) {
        snackBar(text: tr('error_share'), error: true);
      } else {
        submitButton.value = true;
        final String emailStr = email.text;
        final value = await ShareNetwork.addShare(email.text);

        if (value) {
          await getShare();

          if (shareList.isNotEmpty) {
            sendEmail(emailStr, '<div style="font-size: 24px;font-weight: bold">${tr('email_subject')}</div><br><br><a href="https://affordable-app.com/open_app.php?share_id=${shareList.last.id}&platform=${Platform.isAndroid ? 'android' : 'ios'}">${tr('email_link_share')}</a>');
          }
        }

        submitButton.value = false;
      }
    }
  }

  Future<void> sendEmail(String email, String body) async {
    final smtpServer = SmtpServer(smtpServerStr, port: 465, ssl: true, username: emailAddress, password: emailPassword);

    final message = Message()
      ..from = Address(emailAddress, appName)
      ..recipients.add(email)
      ..subject = tr('email_subject')
      ..html = body;

    try {
      await send(message, smtpServer);
      snackBar(text: tr('text_success_send_share'));
    } catch (error) {
      snackBar(text: error.toString(), error: true);
    }
  }

  void deleteShare(int id) {
    ShareNetwork.deleteShare(id).then((value) => value ? getShare() : false);
  }
}