import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller/setting/category_edit.dart';
import '../../model/category_response.dart';
import '../../model/expense_response.dart';
import '../../utils/constant.dart';
import '../../utils/extension.dart';

class CategoryEditView extends StatelessWidget {
  const CategoryEditView({super.key, this.id, this.periodId, this.selectCategoryId});

  final int? id;
  final int? periodId;
  final int? selectCategoryId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryEditController>(
        init: CategoryEditController(id ?? 0, periodId ?? 0, selectCategoryId ?? 0),
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
            resizeToAvoidBottomInset: true,
            body: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Container(
                      height: controller.height,
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: GestureDetector(
                              onTap: () {
                                if (controller.categories.isEmpty) {
                                  return;
                                }

                                controller.setBorder(true);
                                
                                showModalBottomSheet(context: context, barrierColor: Colors.transparent, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))), backgroundColor: Get.isDarkMode ? Colors.transparent : Colors.transparent, builder: (context) {
                                  return Container(
                                      decoration: BoxDecoration(
                                        color: Get.isDarkMode ? const Color(0xFF26292F) : Colors.white,
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Get.isDarkMode ? Colors.transparent : const Color(0x29000000),
                                              blurRadius: 18,
                                              offset: const Offset(0, 7),
                                              spreadRadius: 0
                                          )
                                        ]
                                      ),
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
                                          SizedBox(
                                              height: controller.categories.length > 4 ? 300 : controller.categories.length * 70,
                                              child: ListView.separated(itemCount: controller.categories.length, itemBuilder: (context, index) {
                                                final CategoryResponse item = controller.categories[index];

                                                return InkWell(
                                                    onTap: () => controller.setCategory(item),
                                                    child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                                                        child: Row(
                                                          children: [
                                                            item.icon.contains('.svg') ?
                                                            SvgPicture.asset(item.icon, colorFilter: Get.isDarkMode ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null, semanticsLabel: 'Category', width: 24, height: 24) :
                                                            Image.network(item.icon, width: 24, height: 24),
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
                                          ),
                                          Transform.translate(
                                              offset: const Offset(0, -17),
                                              child: Divider(thickness: 1, color: Get.isDarkMode ? const Color(0xFF303841) : const Color(0xFFF2F2F2))
                                          )
                                        ],
                                      )
                                  );
                                }).then((value) => controller.setBorder(false));
                              },
                              child: Stack(
                                children: [
                                  Obx(() => Container(
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
                                      mainAxisAlignment: controller.categories.isNotEmpty ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                                      children: [
                                        if (controller.categories.isNotEmpty) controller.selectCategory == null ? const Text(
                                          'text_select_category',
                                          style: TextStyle(
                                              color: Color(0xFFD8D8D8),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300
                                          ),
                                        ).tr() : Row(
                                          children: [
                                            controller.selectCategory!.icon.contains('.svg') ?
                                            SvgPicture.asset(controller.selectCategory!.icon, colorFilter: Get.isDarkMode ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null, semanticsLabel: 'Category', width: 24, height: 24) :
                                            Image.network(controller.selectCategory!.icon, width: 24, height: 24),
                                            const SizedBox(width: 6),
                                            Text(
                                              controller.selectCategory!.name,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w300
                                              ),
                                            ),
                                          ],
                                        ),
                                        controller.categories.isNotEmpty ? SvgPicture.asset('assets/icons/select_arrow.svg', colorFilter: Get.isDarkMode ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null, semanticsLabel: 'Edit', width: 8, height: 17) :
                                        const SizedBox(
                                            width: 26,
                                            height: 26,
                                            child: CircularProgressIndicator(color: primaryColor)
                                        ),
                                      ],
                                    ),
                                  )),
                                  Transform.translate(
                                    offset: const Offset(11, -10),
                                    child: Container(
                                      color: Get.isDarkMode ? Colors.black : Colors.white,
                                      width: 88,
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'text_category',
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
                          const SizedBox(height: 24),
                          if (controller.expenses != null && controller.expenses!.isNotEmpty) Container(
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Get.isDarkMode ? const Color(0xFF303841) : const Color(0xFFF2F2F2),
                                        width: 1
                                    ),
                                    top: BorderSide(
                                        color: Get.isDarkMode ? const Color(0xFF303841) : const Color(0xFFF2F2F2),
                                        width: 1
                                    )
                                ),
                              ),
                              margin: const EdgeInsets.only(bottom: 18),
                              height: controller.expenses!.length * 65 > controller.height - 218 ? controller.height - 234 : controller.expenses!.length * 65,
                              child: Scrollbar(
                                controller: controller.scrollController,
                                thumbVisibility: true,
                                trackVisibility: true,
                                child: ListView.separated(controller: controller.scrollController, itemCount: controller.expenses!.length, itemBuilder: (context, index) {
                                  final ExpenseResponse item = controller.expenses![index];

                                  return Slidable(
                                      endActionPane: ActionPane(
                                        dragDismissible: false,
                                        extentRatio: 0.22,
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                              onPressed: (BuildContext context) {
                                                controller.deleteExpense(item.id);
                                              },
                                              spacing: 0,
                                              backgroundColor: dangerColor,
                                              foregroundColor: Colors.white,
                                              icon: Icons.delete
                                          ),
                                        ],
                                      ),
                                      child: InkWell(
                                        onTap: () => openExpenseSheet(context, controller, item: item),
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 21),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 9,
                                                      height: 9,
                                                      decoration: ShapeDecoration(
                                                        color: getColors(index),
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 11),
                                                    Text(
                                                      item.name,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w400
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  convertPrice((controller.selectCategory?.percent ?? false) ? ((item.price / 100) * controller.period!.price) : item.price),
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                              ],
                                            )
                                        )
                                      )
                                  );
                                }, separatorBuilder: (BuildContext context, int index) {
                                  return const Divider(color: Color(0xFFF2F2F2), height: 1);
                                })
                              )
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: Column(
                                children: [
                                  if (controller.selectCategory != null) Obx(() => Column(
                                    children: [
                                      Row(
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
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'text_today',
                                            style: TextStyle(
                                                color: Get.isDarkMode ? Colors.white : const Color(0xFF4E4E4E),
                                                fontSize: 18
                                            ),
                                          ).tr(),
                                          Text(
                                            convertPrice(controller.dayTotal.value),
                                            style: TextStyle(
                                                color: Get.isDarkMode ? Colors.white : const Color(0xFF4E4E4E),
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                    ],
                                  )),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (controller.selectCategory != null) {
                                        openExpenseSheet(context, controller);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: controller.selectCategory == null ? const Color(0xFFEFEFEF) : primaryColor,
                                      minimumSize: Size(Get.width, 53),
                                      elevation: 0,
                                      alignment: Alignment.center,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          side: BorderSide(width: 1, color: controller.selectCategory == null ? const Color(0xFFEFEFEF) : primaryColor)
                                      ),
                                    ),
                                    child: const Text(
                                      'text_add_expense',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400
                                      ),
                                    ).tr()
                                  ),
                                ],
                              )
                          )
                        ],
                      ),
                    )
                ),
              ),
            )
        ));
  }

  void openExpenseSheet(BuildContext context, CategoryEditController controller, {ExpenseResponse? item}) {
    if (item != null) {
      controller.name.text = item.name;
      controller.textPrice.text = '${item.price}'.replaceAll('.0', '');
      controller.buttonSend.value = true;
    } else {
      controller.name.text = '';
      controller.textPrice.text = '';
    }

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
                  color: Get.isDarkMode ? const Color(0xFF26292F) : Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Get.isDarkMode ? Colors.transparent : const Color(0x29000000),
                        blurRadius: 18,
                        offset: const Offset(0, 7),
                        spreadRadius: 0
                    )
                  ]
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
                                    controller.selectCategory?.name ?? tr('text_expense'),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
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
                            return tr('enter_name');
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
                              color: Color(0xFFC9D3E0),
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
                            return '${tr('text_enter')} ${controller.selectCategory!.percent ? tr('text_percent') : tr('text_sum')}';
                          } else if (val != '' && val!.length <= 3 && (double.tryParse(val.replaceAll(',','.')) ?? 0) == 0.0) {
                            return controller.selectCategory!.percent ? tr('error_percent') : tr('error_sum');
                          } else if (val != '' && controller.selectCategory!.percent &&  ((double.tryParse(val!.replaceAll(',','.')) ?? 0) > 100)) {
                            return tr('error_max_percent');
                          }

                          return null;
                        },
                        onChanged: (val) => controller.updateButton(),
                        decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(top: 18),
                            child: Text(
                              controller.selectCategory!.percent ? '%' : '₽',
                              style: const TextStyle(
                                  color: Color(0xFF828282),
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w300
                              ),
                            )
                          ),
                          labelText: controller.selectCategory!.percent ? tr('text_percent') : tr('text_sub_total'),
                          labelStyle: const TextStyle(
                              color: Color(0xFF828282),
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w300
                          ),
                          hintStyle: const TextStyle(
                              color: Color(0xFFC9D3E0),
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w300
                          ),
                          hintText: controller.selectCategory!.percent ? tr('text_percent') : tr('text_sub_total'),
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
                        controller.addExpense(item?.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.buttonSend.value ? primaryColor : const Color(0xFFEFEFEF),
                        minimumSize: Size(Get.width, 53),
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
                      ) : Text(
                        item != null ? 'text_save' : 'text_add',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Get.isDarkMode && !controller.buttonSend.value ? secondColor : Colors.white,
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