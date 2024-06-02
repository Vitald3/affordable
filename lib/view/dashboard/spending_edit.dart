import 'package:affordable/utils/extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller/dashboard/spending_edit.dart';
import '../../utils/constant.dart';

class SpendingEditView extends StatelessWidget {
  const SpendingEditView({super.key, required this.date, required this.priceToDay, required this.periodId});

  final String date;
  final double priceToDay;
  final int periodId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SpendingEditController>(
        init: SpendingEditController(date, periodId),
        builder: (controller) => Container(
            padding: const EdgeInsets.all(25),
            alignment: Alignment.center,
            child: Form(
                key: controller.formKey,
                child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                            controller: controller.dateInput,
                            autocorrect: false,
                            onChanged: (val) => controller.changeButton(),
                            readOnly: true,
                            validator: (val) {
                              if (val == '') {
                                return tr('field_required');
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: tr('text_table_5'),
                              labelStyle: TextStyle(
                                  color: Get.isDarkMode ? Colors.white : const Color(0xFF828282),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300
                              ),
                              hintStyle: const TextStyle(
                                  color: Color(0xFFC9D3E0),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300
                              ),
                              hintText: tr('enter_date'),
                              fillColor: Get.isDarkMode ? Colors.black45 : Colors.white,
                              filled: true,
                              suffixIcon: IconButton(
                                icon: SvgPicture.asset('assets/icons/date.svg', semanticsLabel: 'Dashboard', width: 26, height: 25),
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
                            keyboardType: TextInputType.datetime
                        ),
                      ),
                      const SizedBox(height: 38),
                      SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                            controller: controller.price,
                            autocorrect: false,
                            onChanged: (val) => controller.changeButton(),
                            validator: (val) {
                              if (val == '') {
                                return tr('field_required');
                              } else if (val != '' && (double.tryParse(val!) ?? 0) == 0) {
                                return tr('field_int');
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: tr('text_sub_total'),
                              labelStyle: TextStyle(
                                  color: Get.isDarkMode ? Colors.white : const Color(0xFF828282),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300
                              ),
                              hintStyle: const TextStyle(
                                  color: Color(0xFFC9D3E0),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300
                              ),
                              hintText: tr('text_enter_sum'),
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
                            keyboardType: const TextInputType.numberWithOptions(signed: true)
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                          children: [
                            Expanded(
                                child: Text(
                                  'text_add_sending',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Get.isDarkMode ? Colors.white : const Color(0xFF828282),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300
                                  ),
                                ).tr()
                            )
                          ]
                      ),
                      const SizedBox(height: 21),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'text_end_sum',
                              style: TextStyle(
                                  color: Get.isDarkMode ? Colors.white : const Color(0xFF4E4E4E),
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400
                              )
                          ).tr(),
                          Expanded(
                              child: Text(
                                controller.endSumStr.isNotEmpty ?
                                '${(controller.endSumStr.length > 1 ? controller.endSumStr.join(' + ').replaceAll('+ -', '- ') : controller.endSumStr.single)}${controller.endSumStrCopy.isNotEmpty ? ' + ${controller.endSumStrCopy.first}'.replaceAll('+ -', '- ') : ''}${controller.endSumStrCopy.isNotEmpty || controller.endSumStr.length > 1 ? ' = ${convertPrice(controller.endSum.value + controller.endSumCopy.value)}' : ''}'
                                    : '',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: Get.isDarkMode ? Colors.white : const Color(0xFF4E4E4E),
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500
                                ),
                              )
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              controller.spendingList.isEmpty ? 'text_to_day_sum' : 'text_to_day_ost',
                              style: TextStyle(
                                  color: Get.isDarkMode ? Colors.white : const Color(0xFF4E4E4E),
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400
                              )
                          ).tr(),
                          Text(
                            convertPrice(priceToDay),
                            style: TextStyle(
                                color: Get.isDarkMode ? Colors.white : const Color(0xFF4E4E4E),
                                fontSize: 18,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      if (controller.spendingList.isNotEmpty) ElevatedButton(
                          onPressed: () async {
                            controller.removeSpending();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: dangerColor,
                            minimumSize: Size(Get.width-40, 58),
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
                            'text_delete_last',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400
                            ),
                          ).tr()
                      ),
                      if (controller.spendingList.isNotEmpty) const SizedBox(height: 19),
                      ElevatedButton(
                          onPressed: () async {
                            controller.editSpending();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: controller.buttonVisible.value ? primaryColor : const Color(0xFFEFEFEF),
                            minimumSize: Size(Get.width-40, 58),
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
                            controller.spendingList.isNotEmpty ? 'text_save' : 'text_add',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Get.isDarkMode && !controller.buttonVisible.value ? secondColor : Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400
                            ),
                          ).tr()
                      )
                    ]
                ))
            )
        ));
  }
}