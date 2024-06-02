import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller/auth/login.dart';
import '../../utils/constant.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
        init: LoginController(),
        builder: (controller) => Scaffold(
            body: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                child: Form(
                  key: controller.formKey,
                  child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 50),
                                  Text(
                                    appName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 33,
                                        color: secondColor
                                    ),
                                  ),
                                  SizedBox(height: 18)
                                ]
                            ),
                            SizedBox(height: (Get.height - 566) / 2),
                            Container(
                                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
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
                                      const SizedBox(height: 25),
                                      SizedBox(
                                        width: Get.width-50,
                                        child: TextFormField(
                                          controller: controller.password,
                                          obscureText: controller.passwordHide,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          validator: (val) {
                                            if (val == '') {
                                              return tr('field_required');
                                            }

                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            labelText: tr('text_password'),
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
                                            controller.auth();
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
                                            'text_sign_in',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400
                                            ),
                                          ).tr()
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                Get.toNamed('/forgotten');
                                              },
                                              child: Text(
                                                'text_forgotten_link',
                                                style: TextStyle(
                                                  color: Get.isDarkMode ? Colors.white : const Color(0xFF2F79F6),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ).tr()
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: Get.width-90,
                                            height: 2,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage('assets/images/line.png'),
                                                    fit: BoxFit.fill
                                                )
                                            ),
                                          ),
                                          Container(
                                              width: 80,
                                              height: 32,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(color: Get.isDarkMode ? Colors.black : Colors.white),
                                              child: const Text(
                                                'text_or',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400
                                                ),
                                              ).tr()
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                          onPressed: () async {
                                            controller.googleSignIn();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(Get.width-44, 60),
                                            elevation: 0,
                                            alignment: Alignment.center,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                side: const BorderSide(width: 1, color: Color(0xFFB9B9BA))
                                            ),
                                          ),
                                          child: controller.submitGoogle ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(color: primaryColor)
                                          ) : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset('assets/images/google.png', width: 27, height: 27),
                                              const SizedBox(width: 19),
                                              const Text(
                                                'text_sign_in_google',
                                                style: TextStyle(
                                                    color: Color(0xFF4E4E4E),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w300
                                                ),
                                              ).tr()
                                            ],
                                          )
                                      ),
                                      const SizedBox(height: 70),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '${tr('text_not_account')} ',
                                              style: TextStyle(
                                                  color: Get.isDarkMode ? Colors.white : const Color(0xFF4E4E4E),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300
                                              ),
                                            ),
                                            TextSpan(
                                              recognizer: TapGestureRecognizer()..onTap = () {
                                                Get.toNamed('/register');
                                              },
                                              text: tr('text_register'),
                                              style: const TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]
                                )
                            )
                          ]
                      )
                  )
                )
              ),
            )
        )
    );
  }
}