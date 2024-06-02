import 'package:affordable/utils/constant.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/setting/pay.dart';
import '../../main.dart';

class PayView extends StatelessWidget {
  const PayView({super.key, this.endPeriod});

  final bool? endPeriod;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PayController>(
        init: PayController(),
        builder: (controller) => Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: !(endPeriod ?? false) ? AppBar(
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
                              'text_pay',
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
            ) : null,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Obx(() => Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      children: [
                        const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'text_update_premium',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20)
                              )
                            ]
                        ),
                        const SizedBox(height: 20),
                        const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  'text_premium',
                                  textAlign: TextAlign.center
                              )
                            ]
                        ),
                        const SizedBox(height: 50),
                        GestureDetector(
                            onTap: () {
                              controller.setPay(false);
                            },
                            child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: ShapeDecoration(
                                    color: Get.isDarkMode ? const Color(0xFF212427) : Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(width: 1, color: !controller.free.value ? primaryColor : Colors.grey),
                                        borderRadius: BorderRadius.circular(10)
                                    )
                                ),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text.rich(
                                                TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: '${tr('text_one_year')} ',
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w300
                                                        ),
                                                      ),
                                                      const TextSpan(
                                                          text: '3000 ',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w600
                                                          )
                                                      ),
                                                      const TextSpan(
                                                          text: '₽',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w400
                                                          )
                                                      )
                                                    ]
                                                )
                                            ),
                                            const SizedBox(height: 6),
                                            Text.rich(
                                                TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                          text: '250 ₽ ',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w400
                                                          )
                                                      ),
                                                      TextSpan(
                                                          text: tr('text_in_month'),
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w400
                                                          )
                                                      )
                                                    ]
                                                )
                                            )
                                          ]
                                      ),
                                      Container(
                                          width: 20,
                                          height: 20,
                                          decoration: ShapeDecoration(
                                              color: !controller.free.value ? Colors.green : Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(width: 1, color: !controller.free.value ? Colors.green : Colors.grey),
                                                  borderRadius: BorderRadius.circular(20)
                                              )
                                          )
                                      )
                                    ]
                                )
                            )
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                            onTap: () {
                              controller.setPay(true);
                            },
                            child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: ShapeDecoration(
                                    color: Get.isDarkMode ? const Color(0xFF212427) : Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(width: 1, color: controller.free.value ? primaryColor : Colors.grey),
                                        borderRadius: BorderRadius.circular(10)
                                    )
                                ),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text.rich(
                                                TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: '${pay?.day ?? 7} ${tr('text_days')} ',
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w300
                                                        ),
                                                      ),
                                                      TextSpan(
                                                          text: tr('text_day_free'),
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w600
                                                          )
                                                      )
                                                    ]
                                                )
                                            ),
                                            const SizedBox(height: 6),
                                            Text.rich(
                                                TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                          text: '301 ₽ ',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w400
                                                          )
                                                      ),
                                                      TextSpan(
                                                          text: tr('text_in_month'),
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w400
                                                          )
                                                      )
                                                    ]
                                                )
                                            )
                                          ]
                                      ),
                                      Container(
                                          width: 20,
                                          height: 20,
                                          decoration: ShapeDecoration(
                                              color: controller.free.value ? Colors.green : Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(width: 1, color: controller.free.value ? Colors.green : Colors.grey),
                                                  borderRadius: BorderRadius.circular(20)
                                              )
                                          )
                                      )
                                    ]
                                )
                            )
                        )
                      ]
                  ),
                  SizedBox(height: Get.height > 500 ? Get.height - 510 : 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            controller.go();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            minimumSize: Size(Get.width, 58),
                            elevation: 0,
                            alignment: Alignment.center,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                          child: controller.submitButton.value ? const SizedBox(
                              width: 26,
                              height: 26,
                              child: CircularProgressIndicator(color: Colors.white)
                          ) : const Text(
                            'text_continue',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400
                            ),
                          ).tr()
                      ),
                      const SizedBox(height: 34),
                      const Text(
                          'text_cancel_pay',
                          style: TextStyle(fontSize: 14)
                      )
                    ]
                  )
                ]
              ))
            )
        )
    );
  }
}