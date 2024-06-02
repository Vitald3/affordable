import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller/setting/theme.dart';

class ThemeView extends StatelessWidget {
  const ThemeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
        init: ThemeController(),
        builder: (controller) => Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'text_select_theme',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400
                              ),
                            ).tr()
                          ],
                        ),
                        GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                                height: 40,
                                width: 40,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                                alignment: Alignment.center,
                                child: const Icon(Icons.arrow_back_ios, size: 16)
                            )
                        )
                      ],
                    )
                )
            ),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: ListView(
                      children: [
                        const SizedBox(height: 45),
                        const Divider(color: Color(0xFFF2F2F2), height: .1),
                        InkWell(
                            onTap: () => controller.setTheme('system'),
                            child: Obx(() => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'text_theme_system',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300
                                      ),
                                    ).tr(),
                                    if (controller.theme.value == 'system') SvgPicture.asset('assets/icons/check.svg', semanticsLabel: 'Check', width: 24, height: 17),
                                  ]
                                )
                            ))
                        ),
                        Divider(color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFF2F2F2), height: .1),
                        InkWell(
                            onTap: () => controller.setTheme('light'),
                            child: Obx(() => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'text_theme_light',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300
                                      ),
                                    ).tr(),
                                    if (controller.theme.value == 'light') SvgPicture.asset('assets/icons/check.svg', semanticsLabel: 'Check', width: 24, height: 17),
                                  ],
                                )
                            ))
                        ),
                        const Divider(color: Color(0xFFF2F2F2), height: .1),
                        InkWell(
                            onTap: () => controller.setTheme('dark'),
                            child: Obx(() => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'text_theme_dark',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w300
                                      ),
                                    ).tr(),
                                    if (controller.theme.value == 'dark') SvgPicture.asset('assets/icons/check.svg', semanticsLabel: 'Check', width: 24, height: 17),
                                  ],
                                )
                            ))
                        ),
                        const Divider(color: Color(0xFFF2F2F2), height: .1),
                      ],
                    )
                )
              ],
            )
        )
    );
  }
}