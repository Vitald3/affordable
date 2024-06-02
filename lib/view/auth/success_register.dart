import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../controller/auth/confirmation.dart';
import '../../main.dart';
import '../../network/award/award.dart';
import '../../utils/constant.dart';

class SuccessRegisterView extends StatelessWidget {
  const SuccessRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConfirmationController>(
        init: ConfirmationController(),
        builder: (controller) => Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      '${tr('text_welcome')} ${Supabase.instance.client.auth.currentUser != null ? Supabase.instance.client.auth.currentUser?.userMetadata!['username'] : ''}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Get.isDarkMode ? Colors.white : const Color(0xFF4E4E4E),
                          fontSize: 36,
                          fontWeight: FontWeight.w300
                      ),
                    ),
                    const SizedBox(height: 34),
                    Text(
                      'text_success_register',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Get.isDarkMode ? Colors.white : const Color(0xFF4E4E4E),
                        fontSize: 18,
                        fontWeight: FontWeight.w300
                      ),
                    ).tr(),
                    const SizedBox(height: 15),
                    Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${tr('text_app_instruction')} ',
                            style: TextStyle(
                                color: Get.isDarkMode ? Colors.white : const Color(0xFF4E4E4E),
                                fontSize: 18,
                                fontWeight: FontWeight.w300
                            ),
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()..onTap = () {

                            },
                            text: 'youtube.com',
                            style: const TextStyle(
                                color: primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w300
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        prefs?.setInt('award', 1);
                        AwardNetwork.setAward(1);
                        Get.offAllNamed('/period');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        minimumSize: Size(Get.width-30, 60),
                        elevation: 0,
                        alignment: Alignment.center,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(width: 1, color: primaryColor)
                        ),
                      ),
                      child: const Text(
                        'text_continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ).tr()
                    ),
                  ],
                ),
              ),
            ),
        )
    );
  }
}