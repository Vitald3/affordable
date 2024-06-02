import 'package:affordable/view/setting/category_edit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller/setting/planning_edit.dart';
import '../../model/category_response.dart';
import '../../model/expense_response.dart';
import '../../utils/constant.dart';
import '../../utils/extension.dart';

class PlanningEditView extends StatelessWidget {
  const PlanningEditView({super.key, this.id, this.periodId});

  final int? id;
  final int? periodId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlanningEditController>(
        init: PlanningEditController(id!, periodId!),
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
                            Text(
                              '${(controller.period?.name ?? '')}${controller.period?.price != null ? ' ${convertPrice(double.parse('${controller.period?.price}'))}' : ''}',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400
                              ),
                            )
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
            body: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                  child: Container(
                      padding: const EdgeInsets.only(left: 18, right: 18),
                      height: Get.height - (MediaQuery.of(context).padding.top) - Get.statusBarHeight,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 15),
                            if (controller.categories.isNotEmpty) Wrap(
                                runSpacing: 11,
                                children: List.generate(controller.categories.length, (index) {
                                  final CategoryResponse item = controller.categories[index];

                                  return Container(
                                      width: double.infinity,
                                      decoration: ShapeDecoration(
                                        color: Get.isDarkMode ? const Color(0xFF2B3034) : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(width: 1, color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFECF2F2)),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () => Get.to(() => CategoryEditView(id: controller.id, periodId: controller.periodId, selectCategoryId: item.id))?.then((value) => controller.getPeriod()),
                                            child: Container(
                                                width: double.infinity,
                                                height: 45,
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                decoration: BoxDecoration(
                                                    color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFECF2F2),
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFE4E8E9),
                                                            width: 1
                                                        )
                                                    ),
                                                    borderRadius: const BorderRadius.only(
                                                      topLeft: Radius.circular(20),
                                                      topRight: Radius.circular(20),
                                                    )
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      item.name,
                                                      style: TextStyle(
                                                          color: Get.isDarkMode ? Colors.white : const Color(0xFF4E4E4E),
                                                          fontSize: 18,
                                                          fontFamily: 'Poppins'
                                                      ),
                                                    ),
                                                    SvgPicture.asset('assets/icons/edit.svg', colorFilter: Get.isDarkMode ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null, semanticsLabel: 'Edit', width: 19, height: 18),
                                                  ],
                                                )
                                            ),
                                          ),
                                          if (controller.categoriesExpense.where((element) => element.id == item.id).isNotEmpty) Column(
                                            children: List.generate(controller.categoriesExpense.where((element) => element.id == item.id).first.expenses!.length, (index) {
                                              final expense = controller.categoriesExpense.where((element) => element.id == item.id).first.expenses![index];

                                              return Container(
                                                  color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFECF2F2),
                                                  padding: const EdgeInsets.symmetric(horizontal: 18),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFECF2F2),
                                                        border: item.expenses!.length-1 > index ? Border(
                                                            bottom: BorderSide(
                                                                color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFE4E8E9),
                                                                width: 1
                                                            )
                                                        ) : null,
                                                      ),
                                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                                      child: InkWell(
                                                          onTap: () => openExpenseSheet(context, controller, expense, item.percent, item.id),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    width: 9,
                                                                    height: 9,
                                                                    decoration: ShapeDecoration(
                                                                      color: getColors(++index, reset: true),
                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 11),
                                                                  Text(
                                                                    expense.name,
                                                                    style: TextStyle(
                                                                        fontSize: 14,
                                                                        color: Get.isDarkMode ? Colors.white : secondColor,
                                                                        fontWeight: FontWeight.w400
                                                                    )
                                                                  )
                                                                ]
                                                              ),
                                                              Text(
                                                                convertPrice(item.percent ? ((expense.price / 100) * controller.period!.price) : expense.price),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Get.isDarkMode ? Colors.white : secondColor,
                                                                    fontWeight: FontWeight.w400
                                                                )
                                                              )
                                                            ]
                                                          )
                                                      )
                                                  )
                                              );
                                            }),
                                          ),
                                          Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    'text_total',
                                                    style: TextStyle(
                                                        color: Get.isDarkMode ? Colors.white : const Color(0xFF4E4E4E),
                                                        fontSize: 14,
                                                        fontFamily: 'Poppins'
                                                    )
                                                  ).tr(),
                                                  Text(
                                                    convertPrice(double.tryParse('${item.expenses?.map((e) => item.percent ? ((e.price / 100) * controller.period!.price) : e.price).fold(0.0, (a, b) => a + b)}') ?? 0.0),
                                                    style: TextStyle(
                                                        color: Get.isDarkMode ? Colors.white : const Color(0xFF4E4E4E),
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600
                                                    )
                                                  )
                                                ]
                                              )
                                          ),
                                        ],
                                      )
                                  );
                                })
                            ),
                            const SizedBox(height: 24),
                            Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'text_total',
                                  style: TextStyle(
                                      color: Get.isDarkMode ? Colors.white : const Color(0xFF4E4E4E),
                                      fontSize: 18,
                                      fontFamily: 'Poppins'
                                  ),
                                ).tr(),
                                Text(
                                  convertPrice(controller.total.value),
                                  style: TextStyle(
                                      color: Get.isDarkMode ? Colors.white : const Color(0xFF4E4E4E),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ],
                            )),
                            const SizedBox(height: 10),
                            Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'text_today',
                                  style: TextStyle(
                                      color: Get.isDarkMode ? Colors.white : const Color(0xFF4E4E4E),
                                      fontSize: 18,
                                      fontFamily: 'Poppins'
                                  ),
                                ).tr(),
                                Text(
                                  convertPrice(controller.totalDay.value),
                                  style: TextStyle(
                                      color: Get.isDarkMode ? Colors.white : const Color(0xFF4E4E4E),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ],
                            )),
                            const SizedBox(height: 18)
                          ],
                        ),
                      )
                  )
              ),
            )
        ));
  }

  void openExpenseSheet(BuildContext context, PlanningEditController controller, ExpenseResponse item, bool percent, int selectedCategory) {
    controller.name.text = item.name;
    controller.textPrice.text = '${item.price}'.replaceAll('.0', '');
    controller.buttonSend.value = true;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        builder: (context) {
          return Container(
              padding: EdgeInsets.only(
                bottom: Get.mediaQuery.viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: Get.isDarkMode ? Colors.black : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Get.isDarkMode ? Colors.white : const Color(0x29000000),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Wrap(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
                      child: GestureDetector(
                          onTap: () => Get.back(),
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    controller.categories.where((element) => element.id == selectedCategory).firstOrNull?.name ?? tr('text_expense'),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400
                                    ),
                                  )
                                ],
                              ),
                              const Icon(Icons.arrow_back_ios, size: 16)
                            ],
                          )
                      )
                  ),
                  SizedBox(
                    width: Get.width,
                    child: TextFormField(
                        controller: controller.name,
                        focusNode: controller.focusName,
                        autocorrect: false,
                        validator: (val) {
                          if (val == '') {
                            return tr('error_required');
                          }

                          return null;
                        },
                        onChanged: (val) => controller.updateButton(),
                        decoration: InputDecoration(
                          labelText: tr('text_title'),
                          labelStyle: const TextStyle(
                              color: Color(0xFF828282),
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w300
                          ),
                          hintStyle: const TextStyle(
                              color: Color(0xFFF2F2F2),
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w300
                          ),
                          hintText: tr('text_title'),
                          fillColor: Colors.transparent,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 23),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFF2F2F2),
                                  width: 1
                              )
                          ),
                          focusedErrorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: dangerColor,
                                  width: 1
                              )
                          ),
                          errorBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                width: 1,
                                color: dangerColor,
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFF2F2F2),
                                  width: 1
                              )
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next
                    ),
                  ),
                  const SizedBox(height: 21),
                  SizedBox(
                    width: Get.width,
                    child: TextFormField(
                        controller: controller.textPrice,
                        focusNode: controller.focusPrice,
                        autocorrect: false,
                        validator: (val) {
                          if (val == '') {
                            return '${tr('text_enter')} ${percent ? tr('text_percent') : tr('text_sum')}';
                          } else if (val != '' && val!.length <= 3 && (int.tryParse(val) ?? 0) == 0.0) {
                            return percent ? tr('error_percent') : tr('error_sum');
                          } else if (val != '' && percent &&  (((int.tryParse(val!) ?? 0) > 100) || val.length > 3)) {
                            return tr('error_max_percent');
                          }

                          return null;
                        },
                        onChanged: (val) => controller.updateButton(),
                        decoration: InputDecoration(
                          suffixIcon: Padding(
                              padding: const EdgeInsets.only(top: 18),
                              child: Text(
                                percent ? '%' : '₽',
                                style: const TextStyle(
                                    color: Color(0xFF828282),
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300
                                ),
                              )
                          ),
                          labelText: percent ? tr('text_percent') : tr('text_sub_total'),
                          labelStyle: const TextStyle(
                              color: Color(0xFF828282),
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w300
                          ),
                          hintStyle: const TextStyle(
                              color: Color(0xFFF2F2F2),
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w300
                          ),
                          hintText: percent ? tr('text_percent') : tr('text_sub_total'),
                          fillColor: Colors.transparent,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 23),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFF2F2F2),
                                  width: 1
                              )
                          ),
                          focusedErrorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: dangerColor,
                                  width: 1
                              )
                          ),
                          errorBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                width: 1,
                                color: dangerColor,
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFF2F2F2),
                                  width: 1
                              )
                          ),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                    child: Obx(() => ElevatedButton(
                        onPressed: () {
                          controller.addExpense(item.id, percent, selectedCategory);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.buttonSend.value ? primaryColor : const Color(0xFFEFEFEF),
                          minimumSize: Size(Get.width, 60),
                          elevation: 0,
                          alignment: Alignment.center,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(width: 1, color: controller.buttonSend.value ? primaryColor : const Color(0xFFEFEFEF))
                          ),
                        ),
                        child: controller.buttonSubmit.value ? const SizedBox(
                            width: 26,
                            height: 26,
                            child: CircularProgressIndicator(color: Colors.white)
                        ) : const Text(
                          'text_save',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400
                          ),
                        ).tr()
                    )),
                  )
                ],
              )
          );
        });
  }
}