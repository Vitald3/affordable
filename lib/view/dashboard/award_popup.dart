import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../../utils/constant.dart';

Future<void> awardPopup(int award) async {
  String title = tr('text_award_1_title');
  String text = tr('text_award_1_text');

  if (award != 1) {
    title = tr('text_award_$award');
    text = tr('text_award_${award}_text');
  }

  List<String> awardList = prefs?.getStringList('awards') ?? <String>[];
  awardList.remove('$award');

  await showDialog(context: Get.context!, barrierColor: Colors.transparent, builder: (_) {
    return GestureDetector(
        onTap: () async {
          await prefs?.setInt('award', 0);
          await prefs?.setStringList('awards', awardList);
          Get.back();
        },
        child: SafeArea(
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Align(
                    alignment: Alignment.center,
                    child: DecoratedBox(
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x29000000),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: SizedBox(
                            width: Get.width-36,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 53),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 32),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SvgPicture.asset('assets/icons/stars.svg', semanticsLabel: 'Award', width: 225, height: 205),
                                        SvgPicture.asset('assets/icons/award_${award}_active.svg', semanticsLabel: 'Award', width: 215, height: 184)
                                      ]
                                    ),
                                    const SizedBox(height: 16),
                                    Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
                                    if (text != '') SizedBox(height: 21, width: Get.width-36),
                                    if (text != '') Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, color: Color(0xFF7E7D84))),
                                    const SizedBox(height: 12),
                                    InkWell(
                                        onTap: () async {
                                          await prefs?.setInt('award', 0);
                                          await prefs?.setStringList('awards', awardList);
                                          Get.back();
                                        },
                                        child: const Text('text_good', style: TextStyle(color: primaryColor)).tr()
                                    ),
                                    const SizedBox(height: 30)
                                  ],
                                )
                            )
                        )
                    )
                )
            )
        )
    );
  }).then((value) async {
    await prefs?.setInt('award', 0);
    await prefs?.setStringList('awards', awardList);
    Get.back();
  });
}