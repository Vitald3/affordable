import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller/dashboard/income_edit.dart';
import '../../model/expense_response.dart';
import '../../model/income_response.dart';
import '../../utils/constant.dart';
import '../../utils/extension.dart';

class IncomeEditView extends StatelessWidget {
  const IncomeEditView({super.key, this.date, this.priceToDay, required this.incomes, required this.incomeId, this.categoryId, required this.periodId, required this.planPrice, required this.expenseId, required this.color, required this.expenses, this.type});

  final String? date;
  final double? priceToDay;
  final List<IncomeResponseModel> incomes;
  final int incomeId;
  final int? categoryId;
  final int periodId;
  final double? planPrice;
  final int expenseId;
  final Color color;
  final List<ExpenseResponse> expenses;
  final int? type;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: GetBuilder<IncomeEditController>(
            init: IncomeEditController(date ?? '', priceToDay ?? 0, incomes, incomeId, categoryId, periodId, expenseId, color, planPrice ?? 0, expenses, type),
            builder: (controller) => Scaffold(
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
                                Obx(() => Text(
                                  controller.title.value,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400
                                  ),
                                ))
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
                resizeToAvoidBottomInset: true,
                body: SafeArea(
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: controller.spendingWidget != null ? controller.spendingWidget! : Container(
                          alignment: Alignment.center,
                          child: Form(
                              key: controller.formKey,
                              child: Obx(() => Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 25),
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.setBorder(true);

                                          showModalBottomSheet(context: context, barrierColor: Colors.transparent, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))), backgroundColor: Get.isDarkMode ? Colors.transparent : Colors.transparent, builder: (context) {
                                            final incomesList = incomes.reversed.where((element) => element.periodId == controller.periodId && element.categoryId == controller.categoryId.value).toList();
                                            final int indexColor = colorList.indexWhere((element) => element == color);

                                            return Container(
                                                decoration: BoxDecoration(
                                                  color: Get.isDarkMode ? const Color(0xFF26292F) : Colors.white,
                                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Get.isDarkMode ? const Color(0xFFCECECE) : const Color(0x29000000),
                                                      blurRadius: 8,
                                                      offset: Get.isDarkMode ? const Offset(0, 7) : const Offset(0, 2),
                                                      spreadRadius: 0
                                                    )
                                                  ],
                                                ),
                                                padding: const EdgeInsets.only(bottom: 15),
                                                child: Wrap(
                                                  runSpacing: 8,
                                                  children: [
                                                    Container(
                                                        decoration: BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                                color: Get.isDarkMode ? const Color(0xFF303841) : const Color(0xFFF2F2F2),
                                                                width: 1
                                                            ),
                                                          ),
                                                        ),
                                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
                                                        child: InkWell(
                                                            onTap: () => Get.back(),
                                                            child: Stack(
                                                              alignment: Alignment.centerLeft,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    const Text(
                                                                      'text_select_category',
                                                                      style: TextStyle(
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight.w400
                                                                      ),
                                                                    ).tr()
                                                                  ],
                                                                ),
                                                                const Icon(Icons.arrow_back_ios, size: 16)
                                                              ],
                                                            )
                                                        )
                                                    ),
                                                    if (incomesList.isNotEmpty) SizedBox(
                                                        height: incomesList.length > 4 ? 300 : incomesList.length * 60,
                                                        child: Scrollbar(
                                                            controller: controller.scrollController,
                                                            thumbVisibility: true,
                                                            trackVisibility: true,
                                                            child: ListView.separated(controller: controller.scrollController, itemCount: incomesList.length, itemBuilder: (context, index) {
                                                              final IncomeResponseModel item = incomesList[index];

                                                              return InkWell(
                                                                  onTap: () => controller.setIncome(item.id),
                                                                  child: Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                                                                      child: Row(
                                                                        children: [
                                                                          Container(
                                                                            width: 9,
                                                                            height: 9,
                                                                            decoration: ShapeDecoration(
                                                                              color: getColors(indexColor > index ? indexColor - (index + 1) : index, reset: true),
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(width: 10),
                                                                          Text(
                                                                            item.name,
                                                                            style: const TextStyle(
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.w300
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                  )
                                                              );
                                                            }, separatorBuilder: (BuildContext context, int index) {
                                                              return Divider(thickness: 1, color: Get.isDarkMode ? const Color(0xFF303841) : const Color(0xFFF2F2F2));
                                                            })
                                                        )
                                                    ),
                                                    if (incomesList.isNotEmpty) Divider(thickness: 1, height: 1, color: Get.isDarkMode ? const Color(0xFF303841) : const Color(0xFFF2F2F2)),
                                                    InkWell(
                                                        onTap: () => controller.setIncome(0),
                                                        child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  controller.sheetText.value,
                                                                  style: const TextStyle(
                                                                      fontSize: 18,
                                                                      fontWeight: FontWeight.w300
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                        )
                                                    ),
                                                    Divider(thickness: 1, color: Get.isDarkMode ? const Color(0xFF303841) : const Color(0xFFF2F2F2))
                                                  ],
                                                )
                                            );
                                          }).then((value) => controller.setBorder(false));
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 53,
                                              padding: const EdgeInsets.symmetric(horizontal: 18),
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(width: 1, color: Color(controller.borderBool.value ? 0xFF2F79F6 : 0xFFC9D3E0)),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 9,
                                                            height: 9,
                                                            decoration: ShapeDecoration(
                                                              color: color,
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 6),
                                                          Expanded(
                                                              child: Text(
                                                                  controller.selectLabel.value,
                                                                  style: const TextStyle(
                                                                      fontSize: 18,
                                                                      fontWeight: FontWeight.w300,
                                                                      height: 1
                                                                  )
                                                              )
                                                          )
                                                        ],
                                                      )
                                                  ),
                                                  Row(
                                                    children: [
                                                      if (controller.planPrice > 0) Text(
                                                        convertPrice(controller.planPrice.value),
                                                        style: TextStyle(
                                                            color: Get.isDarkMode ? Colors.white : const Color(0xFF4A4A4A),
                                                            fontSize: 18,
                                                            fontFamily: 'Poppins',
                                                            fontWeight: FontWeight.w300
                                                        ),
                                                      ),
                                                      const SizedBox(width: 17),
                                                      SvgPicture.asset('assets/icons/select_arrow.svg', colorFilter: Get.isDarkMode ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null, semanticsLabel: 'Edit', width: 8, height: 17)
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Transform.translate(
                                              offset: const Offset(11, -10),
                                              child: Container(
                                                  color: Get.isDarkMode ? Colors.black : Colors.white,
                                                  width: 140,
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    'text_category_income',
                                                    style: TextStyle(
                                                        color: Color(0xFFD8D8D8),
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w300
                                                    ),
                                                  ).tr()
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 36),
                                    if (controller.expenseId.value == 0 && controller.selectLabel.value != tr('text_salary')) SizedBox(
                                      width: Get.width-50,
                                      child: TextFormField(
                                          controller: controller.name,
                                          autocorrect: false,
                                          onChanged: (val) => controller.changeButton(),
                                          validator: (val) {
                                            if (val == '') {
                                              return tr('field_required');
                                            }

                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            labelText: tr('text_category_name'),
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
                                            hintText: tr('text_select_category'),
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
                                          keyboardType: TextInputType.text
                                      ),
                                    ),
                                    if (controller.expenseId.value == 0 && controller.selectLabel.value != tr('text_salary')) const SizedBox(height: 36),
                                    SizedBox(
                                      width: Get.width-50,
                                      child: TextFormField(
                                          controller: controller.price,
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
                                            hintText: tr('text_enter_total'),
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
                                    const SizedBox(height: 19),
                                    if (controller.incomeId > 0) ElevatedButton(
                                        onPressed: () async {
                                          controller.removeIncome(controller.incomeId.value);
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
                                          'text_delete',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400
                                          ),
                                        ).tr()
                                    ),
                                    if (controller.incomeId > 0) const SizedBox(height: 19),
                                    ElevatedButton(
                                        onPressed: () async {
                                          if (controller.incomeId > 0) {
                                            controller.editIncome(controller.incomeId.value);
                                          } else {
                                            controller.editIncome(0);
                                          }
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
                                          controller.incomeId > 0 ? 'text_change' : 'text_add',
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
                      )
                  ),
                ),
                bottomNavigationBar: SafeArea(child: Container(
                    height: 93,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Get.isDarkMode ? const Color(0xFFCECECE) : const Color(0x29000000),
                            blurRadius: 18,
                            offset: const Offset(0, 7),
                            spreadRadius: 0
                        )
                      ],
                    ),
                    child: Obx(() => BottomNavigationBar(
                        selectedFontSize: 3,
                        elevation: 0,
                        type: BottomNavigationBarType.fixed,
                        items: <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                              icon: SvgPicture.asset('assets/icons/24.svg', colorFilter: ColorFilter.mode(Get.isDarkMode && controller.activeIndex.value == 0 ? Colors.white : (controller.activeIndex.value == 0 ? secondColor : const Color(0xFFB9B9BA)), BlendMode.srcIn), semanticsLabel: 'Day expense', width: 31, height: 31),
                              label: ""
                          ),
                          BottomNavigationBarItem(
                              icon: SvgPicture.asset('assets/icons/${controller.activeIndex.value == 1 ? 'income_2' : 'income_2_s'}.svg', colorFilter: Get.isDarkMode ? ColorFilter.mode(controller.activeIndex.value == 1 ? Colors.white : secondColor, BlendMode.srcIn) : null, semanticsLabel: 'Income', width: 35, height: 31),
                              label: ""
                          ),
                          BottomNavigationBarItem(
                              icon: SvgPicture.asset('assets/icons/${controller.activeIndex.value == 2 ? 'income_2' : 'income_2_s'}.svg', colorFilter: Get.isDarkMode ? ColorFilter.mode(controller.activeIndex.value == 2 ? Colors.white : secondColor, BlendMode.srcIn) : null, semanticsLabel: 'Income', width: 35, height: 31),
                              label: ""
                          ),
                          BottomNavigationBarItem(
                              icon: SvgPicture.asset('assets/icons/${controller.activeIndex.value == 3 ? 'income_3' : 'income_3_s'}.svg', colorFilter: Get.isDarkMode ? ColorFilter.mode(controller.activeIndex.value == 3 ? Colors.white : secondColor, BlendMode.srcIn) : null, semanticsLabel: 'Investment', width: 32, height: 30),
                              label: ""
                          ),
                          BottomNavigationBarItem(
                              icon: SvgPicture.asset('assets/icons/${controller.activeIndex.value == 4 ? 'income_4' : 'income_4_s'}.svg', colorFilter: Get.isDarkMode ? ColorFilter.mode(controller.activeIndex.value == 4 ? Colors.white : secondColor, BlendMode.srcIn) : null, semanticsLabel: 'Money box', width: 34, height: 30),
                              label: ""
                          )
                        ],
                        currentIndex: controller.activeIndex.value,
                        onTap: (int index) {
                          controller.goTo(index);
                        }
                    ))
                ))
            ))
    );
  }
}