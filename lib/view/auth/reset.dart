import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller/auth/reset.dart';
import '../../utils/constant.dart';

class ResetView extends StatelessWidget {
  const ResetView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResetController>(
        init: ResetController(),
        builder: (controller) => Scaffold(
            body: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        appName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFF4E4E4E),
                            fontSize: 36,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 90),
                      SizedBox(
                        width: Get.width-50,
                        child: TextFormField(
                          controller: controller.code,
                          focusNode: controller.focusCode,
                          autocorrect: false,
                          validator: (val) {
                            if (val == '') {
                              return tr('field_required');
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: tr('text_temp_code'),
                            labelStyle: const TextStyle(
                                color: Color(0xFF828282),
                                fontSize: 18,
                                fontWeight: FontWeight.w300
                            ),
                            hintStyle: const TextStyle(
                                color: Color(0xFFC9D3E0),
                                fontSize: 18,
                                fontWeight: FontWeight.w300
                            ),
                            hintText: tr('enter_temp_code'),
                            fillColor: Get.isDarkMode ? Colors.black45 : Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 23),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: dangerColor,
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: dangerColor,
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Color(0xFFC9D3E0),
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: Get.width-50,
                        child: TextFormField(
                          controller: controller.password,
                          obscureText: controller.passwordHide,
                          enableSuggestions: false,
                          focusNode: controller.focusPassword,
                          autocorrect: false,
                          validator: (val) {
                            if (val == '') {
                              return tr('field_required');
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: tr('text_password'),
                            labelStyle: const TextStyle(
                                color: Color(0xFF828282),
                                fontSize: 18,
                                fontWeight: FontWeight.w300
                            ),
                            hintStyle: const TextStyle(
                                color: Color(0xFFC9D3E0),
                                fontSize: 18,
                                fontWeight: FontWeight.w300
                            ),
                            hintText: tr('enter_password'),
                            fillColor: Get.isDarkMode ? Colors.black45 : Colors.white,
                            filled: true,
                            suffixIcon: IconButton(
                              icon: SvgPicture.asset('assets/icons/glas.svg', semanticsLabel: 'Show Password', width: 23, height: 15),
                              onPressed: () {
                                controller.setPasswordHide();
                              },
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 23),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: dangerColor,
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: dangerColor,
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Color(0xFFC9D3E0),
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          controller.reset();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          minimumSize: Size(Get.width-44, 60),
                          elevation: 0,
                          alignment: Alignment.center,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(width: 1, color: primaryColor)
                          ),
                        ),
                        child: controller.submitButton ? const SizedBox(
                            width: 26,
                            height: 26,
                            child: CircularProgressIndicator(color: Colors.white)
                        ) : const Text(
                          'text_reset',
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
        )
    );
  }
}