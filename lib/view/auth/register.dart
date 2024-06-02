import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller/auth/register.dart';
import '../../utils/constant.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
        init: RegisterController(),
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
                        SizedBox(height: (Get.height - 510) / 2),
                        Container(
                            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
                            child: SingleChildScrollView(
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: Get.width-50,
                                        child: TextFormField(
                                            controller: controller.name,
                                            autocorrect: false,
                                            validator: (val) {
                                              if (val == '') {
                                                return tr('field_required');
                                              }

                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              labelText: tr('text_name'),
                                              labelStyle: const TextStyle(
                                                  color: Color(0xFF828282),
                                                  fontSize: 18,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w300
                                              ),
                                              hintStyle: const TextStyle(
                                                  color: Color(0xFFC9D3E0),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w300
                                              ),
                                              hintText: tr('enter_name'),
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
                                            keyboardType: TextInputType.emailAddress,
                                            textInputAction: TextInputAction.next
                                        ),
                                      ),
                                      const SizedBox(height: 22),
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
                                              } else if (val != '' && controller.unique) {
                                                return tr('error_account_unique');
                                              }

                                              return null;
                                            },
                                            onChanged: (val) {
                                              controller.setUnique(false);
                                            },
                                            decoration: InputDecoration(
                                              labelText: 'Email',
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
                                      const SizedBox(height: 22),
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
                                            } else if (val != '' && val!.length < 6) {
                                              return tr('error_password_min');
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
                                            controller.register();
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
                                            'text_register',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400
                                            ),
                                          ).tr()
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
                                            backgroundColor: Colors.white,
                                            minimumSize: Size(Get.width-44, 60),
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                              const SizedBox(width: 9),
                                              Expanded(
                                                  child: const Text(
                                                    'text_register_google',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Color(0xFF4E4E4E),
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w300
                                                    ),
                                                  ).tr()
                                              )
                                            ],
                                          )
                                      ),
                                      const SizedBox(height: 50),
                                      if (controller.shareId == 0) Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '${tr('text_yes_account')} ',
                                              style: TextStyle(
                                                  color: Get.isDarkMode ? Colors.white : const Color(0xFF4E4E4E),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300
                                              ),
                                            ),
                                            TextSpan(
                                              recognizer: TapGestureRecognizer()..onTap = () {
                                                Get.back();
                                              },
                                              text: tr('text_sign_in'),
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
                        )
                      ],
                    )
                  )
                )
              ),
            )
        )
    );
  }
}