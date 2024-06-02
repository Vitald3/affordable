import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/setting/notifications.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsController>(
        init: NotificationsController(),
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
                              'text_notifications',
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
                        GestureDetector(
                          onTap: () => controller.setSwitchParam(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                            decoration: const BoxDecoration(
                                border: Border.symmetric(
                                    horizontal: BorderSide(
                                        color: Color(0xFFE4E8E9),
                                        width: .1
                                    )
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: const Text(
                                    'text_notify_1',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300
                                    ),
                                  ).tr(),
                                ),
                                Obx(() => CupertinoSwitch(
                                  activeColor: const Color(0xFF76C86C),
                                  thumbColor: Colors.white,
                                  trackColor: const Color(0xFF979797),
                                  value: controller.switchParam.value,
                                  onChanged: (value) => controller.setSwitchParam()
                                ))
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.setSwitchParam2(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                            decoration: const BoxDecoration(
                                border: Border.symmetric(
                                    horizontal: BorderSide(
                                        color: Color(0xFFE4E8E9),
                                        width: .1
                                    )
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: const Text(
                                    'text_notify_2',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300
                                    ),
                                  ).tr(),
                                ),
                                Obx(() => CupertinoSwitch(
                                  activeColor: const Color(0xFF76C86C),
                                  thumbColor: Colors.white,
                                  trackColor: const Color(0xFF979797),
                                  value: controller.switchParam2.value,
                                  onChanged: (value) => controller.setSwitchParam2()
                                ))
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.setSwitchParam3(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                            decoration: const BoxDecoration(
                                border: Border.symmetric(
                                    horizontal: BorderSide(
                                        color: Color(0xFFE4E8E9),
                                        width: .1
                                    )
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: const Text(
                                    'text_notify_3',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300
                                    ),
                                  ).tr(),
                                ),
                                Obx(() => CupertinoSwitch(
                                  activeColor: const Color(0xFF76C86C),
                                  thumbColor: Colors.white,
                                  trackColor: const Color(0xFF979797),
                                  value: controller.switchParam3.value,
                                  onChanged: (value) => controller.setSwitchParam3()
                                ))
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.setSwitchParam4(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                            decoration: const BoxDecoration(
                                border: Border.symmetric(
                                    horizontal: BorderSide(
                                        color: Color(0xFFE4E8E9),
                                        width: .1
                                    )
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: const Text(
                                    'text_notify_4',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300
                                    ),
                                  ).tr(),
                                ),
                                Obx(() => CupertinoSwitch(
                                  activeColor: const Color(0xFF76C86C),
                                  thumbColor: Colors.white,
                                  trackColor: const Color(0xFF979797),
                                  value: controller.switchParam4.value,
                                  onChanged: (value) => controller.setSwitchParam4()
                                ))
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                )
              ],
            )
        )
    );
  }
}