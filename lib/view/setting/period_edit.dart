import 'package:affordable/controller/setting/period.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/constant.dart';

class PeriodEditView extends StatelessWidget {
  PeriodEditView({super.key});

  final controller = Get.find<PeriodController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            scrolledUnderElevation: 0,
            title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'text_period_add',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400
                          ),
                        ).tr()
                      ],
                    ),
                    GestureDetector(
                        onTap: () {
                          controller.clear();
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
                  const SizedBox(height: 100),
                  SizedBox(
                    width: Get.width-50,
                    child: TextFormField(
                        controller: controller.name,
                        focusNode: controller.focusName,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (val) => controller.changeButton(),
                        autocorrect: false,
                        validator: (val) {
                          if (val == '') {
                            return tr('field_required');
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: tr('text_title'),
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
                          hintText: tr('enter_title'),
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
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: Get.width-50,
                    child: TextFormField(
                        controller: controller.day,
                        focusNode: controller.focusDay,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (val) => controller.changeButton(),
                        autocorrect: false,
                        validator: (val) {
                          if (val == '') {
                            return tr('field_required');
                          } else if ((int.tryParse(val!) ?? 0) > 31) {
                            return tr('error_max_t');
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: tr('text_get_day_d'),
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
                          hintText: tr('enter_day_d'),
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
                  const SizedBox(height: 22),
                  SizedBox(
                    width: Get.width-50,
                    child: TextFormField(
                        controller: controller.price,
                        focusNode: controller.focusPrice,
                        autocorrect: false,
                        onChanged: (val) => controller.changeButton(),
                        validator: (val) {
                          if (val == '') {
                            return tr('field_required');
                          } else if (val != '' && (int.tryParse(val!) ?? 0) == 0) {
                            return tr('field_int');
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: tr('text_size_d'),
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
                          hintText: tr('enter_size_d'),
                          fillColor: Get.isDarkMode ? Colors.black45 : Colors.white,
                          filled: true,
                          suffixIcon: IconButton(
                            icon: const Text(
                              '₽',
                              style: TextStyle(
                                  color: Color(0xFF979797),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300
                              ),
                            ),
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
                        keyboardType: TextInputType.number
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 235,
                        child: const Text(
                          'text_drag',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300
                          ),
                        ).tr()
                      ),
                      Obx(() => CupertinoSwitch(
                        activeColor: const Color(0xFF76C86C),
                        thumbColor: Colors.white,
                        trackColor: const Color(0xFF979797),
                        value: controller.switchParam.value,
                        onChanged: (value) => controller.switchParam.toggle().obs,
                      ))
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (controller.edit.value > 0) Obx(() => ElevatedButton(
                    onPressed: () async {
                      controller.removePeriod();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: dangerColor,
                      minimumSize: Size(Get.width-44, 60),
                      elevation: 0,
                      alignment: Alignment.center,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    child: controller.removeButton.value ? const SizedBox(
                        width: 26,
                        height: 26,
                        child: CircularProgressIndicator(color: Colors.white)
                    ) : const Text(
                      'text_delete',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400
                      ),
                    ).tr()
                  )),
                  if (controller.edit.value > 0) const SizedBox(height: 20),
                  Obx(() => ElevatedButton(
                    onPressed: () async {
                      if (controller.edit.value > 0) {
                        controller.editPeriod();
                      } else {
                        controller.addPeriod();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.buttonVisible.value ? primaryColor : const Color(0xFFEFEFEF),
                      minimumSize: Size(Get.width-44, 60),
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
                    ) : Text(
                      controller.edit.value > 0 ? 'text_change' : 'text_add',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Get.isDarkMode && !controller.buttonVisible.value ? secondColor : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400
                      ),
                    ).tr()
                  )),
                ],
              ),
            ),
          ),
        )
    );
  }
}