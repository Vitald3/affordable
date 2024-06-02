import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller/auth/forgotten.dart';
import '../../utils/constant.dart';

class ForgottenView extends StatelessWidget {
  const ForgottenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgottenController>(
        init: ForgottenController(),
        builder: (controller) => Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                scrolledUnderElevation: 0,
                title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'text_forgotten_pass',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400
                                  ),
                                ).tr(),
                              ],
                            ),
                            const Icon(Icons.arrow_back_ios, size: 16)
                          ],
                        )
                    )
                )
            ),
            body: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(25),
                  child: Container(
                    height: (Get.height - ((MediaQuery.of(Get.context!).padding.top + kToolbarHeight) + Get.statusBarHeight + 130)),
                    alignment: Alignment.center,
                    child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: Get.width-50,
                              child: TextFormField(
                                  controller: controller.login,
                                  autocorrect: false,
                                  validator: (val) {
                                    if (val == '') {
                                      return tr('field_required');
                                    } else if (val != '' && !EmailValidator.validate(val!)) {
                                      return tr('error_email');
                                    }

                                    return null;
                                  },
                                  onChanged: (val) {
                                    if (val != '' && EmailValidator.validate(val)) {
                                      controller.formKey.currentState!.validate();
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    labelStyle: TextStyle(
                                        color: Get.isDarkMode ? Colors.white : const Color(0xFF828282),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300
                                    ),
                                    hintStyle: TextStyle(
                                        color: Get.isDarkMode ? Colors.white : const Color(0xFFC9D3E0),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300
                                    ),
                                    hintText: tr('text_enter_email'),
                                    fillColor: Get.isDarkMode ? Colors.black45 : Colors.white,
                                    filled: true,
                                    suffixIcon: IconButton(
                                      icon: SvgPicture.asset('assets/icons/email.svg', semanticsLabel: 'Email', width: 24, height: 15),
                                      onPressed: () {},
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
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                                onPressed: () async {
                                  controller.forgotten();
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
                                  'text_forgotten',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400
                                  ),
                                ).tr()
                            ),
                          ],
                        )
                    )
                  )
                ),
              ),
            )
        )
    );
  }
}