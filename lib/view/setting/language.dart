import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller/setting/language.dart';
import '../../model/language_model.dart';
import '../../utils/constant.dart';

class LanguageView extends StatelessWidget {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(
        init: LanguageController(),
        builder: (controller) => Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                scrolledUnderElevation: 0,
                title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'text_select_language',
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
              children: [
                const SizedBox(height: 45),
                Divider(color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFF2F2F2), height: .1),
                Expanded(
                    child: ListView.separated(itemCount: languagesList.length, itemBuilder: (context, index) {
                      final LanguageModel item = languagesList[index];

                      return Column(
                        children: [
                          InkWell(
                              onTap: () => controller.setLanguage(context, item.id),
                              child: Obx(() => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w300
                                        ),
                                      ),
                                      if (item.id == controller.languageId.value) SvgPicture.asset('assets/icons/check.svg', semanticsLabel: 'Check', width: 24, height: 17),
                                    ],
                                  )
                              ))
                          ),
                          if (languagesList.length-1 == index) Divider(color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFF2F2F2), height: .1),
                        ],
                      );
                    }, separatorBuilder: (BuildContext context, int index) {
                      return Divider(color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFF2F2F2), height: .1);
                    })
                )
              ],
            )
        )
    );
  }
}