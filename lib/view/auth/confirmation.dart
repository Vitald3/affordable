import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:get/get.dart';
import '../../controller/auth/confirmation.dart';
import '../../utils/constant.dart';

class ConfirmationView extends StatelessWidget {
  const ConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConfirmationController>(
        init: ConfirmationController(),
        builder: (controller) => Scaffold(
            body: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40, width: Get.width),
                      Text(
                        '${tr('text_welcome')} ${Get.arguments?['name'] ?? ''}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w300
                        ),
                      ),
                      const SizedBox(height: 72),
                      SizedBox(
                        width: 281,
                        child: const Text(
                          'text_send_code_email',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w300
                          ),
                        ).tr(),
                      ),
                      const SizedBox(height: 58),
                      VerificationCode(
                        textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor),
                        keyboardType: TextInputType.number,
                        length: 6,
                        itemSize: 38,
                        underlineColor: primaryColor,
                        underlineUnfocusedColor: const Color(0xFFD2D2D2),
                        cursorColor: primaryColor,
                        fillColor: const Color(0xFFEFEFEF),
                        fullBorder: true,
                        margin: const EdgeInsets.all(6),
                        onCompleted: (String value) {
                          controller.setCode(value);
                        },
                        onEditing: (bool value) {
                          controller.setEditing(value);
                          if (!controller.editing) FocusScope.of(context).unfocus();
                        },
                      ),
                      const SizedBox(height: 29),
                      SizedBox(
                        width: 281,
                        child: controller.count > 0 && !controller.useCode ? Text(
                          '${tr('text_retry_code')} ${controller.strCount} с',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Color(0xFFD2D2D2),
                              fontSize: 19,
                              fontWeight: FontWeight.w300
                          ),
                        ) : InkWell(
                            onTap: () {
                              controller.reSend();
                            },
                            child: Text(
                              'text_send_new_code',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Get.isDarkMode ? Colors.white : primaryColor,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w300
                              ),
                            ).tr()
                        )
                      ),
                    ],
                  ),
                ),
              ),
            )
        )
    );
  }
}