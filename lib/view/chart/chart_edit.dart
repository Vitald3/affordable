import 'package:affordable/model/chart_response_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller/chart/chart_edit.dart';
import '../../model/chart_formula_response_model.dart';
import '../../utils/constant.dart';
import '../../utils/extension.dart';

class ChartEditView extends StatelessWidget {
  const ChartEditView({super.key, this.chart});

  final ChartResponseModel? chart;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChartEditController>(
        init: ChartEditController(chart),
        builder: (controller) => Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                scrolledUnderElevation: 0,
                title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'text_chart_add',
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
                )
            ),
            body: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                  child: Container(
                      height: Get.height - (MediaQuery.of(context).padding.top) - Get.statusBarHeight,
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        child: Obx(() => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 18, right: 18),
                              child: Form(
                                  key: controller.formKey,
                                  child: SizedBox(
                                    width: Get.width-50,
                                    child: TextFormField(
                                        controller: controller.nameEdit,
                                        autocorrect: false,
                                        onChanged: (val) => controller.changeButton(),
                                        validator: (val) {
                                          if (val == '') {
                                            return tr('field_required');
                                          }

                                          return null;
                                        },
                                        onEditingComplete: () {
                                          controller.changeNameChart();
                                        },
                                        onFieldSubmitted: (String val) {
                                          controller.changeNameChart();
                                        },
                                        decoration: InputDecoration(
                                          labelText: tr('text_chart_name'),
                                          labelStyle: TextStyle(
                                              color: Get.isDarkMode ? Colors.white : const Color(0xFF828282),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300
                                          ),
                                          hintStyle: TextStyle(
                                              color: Get.isDarkMode ? Colors.white : const Color(0xFFC9D3E0),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300
                                          ),
                                          hintText: tr('text_chart_name'),
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
                                        keyboardType: TextInputType.text
                                    ),
                                  )
                              ),
                            ),
                            const SizedBox(height: 24),
                            if (controller.chart?.formulaList != null && controller.chart!.formulaList!.isNotEmpty) Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      top: BorderSide(
                                          color: Color(0xFFF2F2F2),
                                          width: 1
                                      )
                                  )
                                ),
                                child: Column(children: List.generate(controller.chart!.formulaList!.length, (index) {
                                  final ChartFormulaResponseModel item = controller.chart!.formulaList![index];

                                  return Slidable(
                                      endActionPane: ActionPane(
                                        dragDismissible: false,
                                        extentRatio: 0.22,
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                              onPressed: (BuildContext context) {
                                                controller.deleteFormula(item.id);
                                              },
                                              spacing: 0,
                                              backgroundColor: dangerColor,
                                              foregroundColor: Colors.white,
                                              icon: Icons.delete
                                          ),
                                        ],
                                      ),
                                      child: InkWell(
                                          onTap: () => openChartSheet(context, controller, chart?.id ?? 0, item.id),
                                          child: Container(
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Color(0xFFF2F2F2),
                                                          width: 1
                                                      )
                                                  )
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 21),
                                              child: Row(
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
                                                      item.formulaText,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w400,
                                                          height: 1
                                                      )
                                                  )
                                                ],
                                              )
                                          )
                                      )
                                  );
                                }))
                            ),
                            if (controller.chart?.formulaList != null && controller.chart!.formulaList!.isNotEmpty) const SizedBox(height: 24),
                            if (chart != null) ElevatedButton(
                                onPressed: () {
                                  controller.removeChart();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: dangerColor,
                                  minimumSize: Size(Get.width-36, 60),
                                  elevation: 0,
                                  alignment: Alignment.center,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: const BorderSide(width: 1, color: dangerColor)
                                  ),
                                ),
                                child: controller.buttonDeleteSubmit.value ? const SizedBox(
                                    width: 26,
                                    height: 26,
                                    child: CircularProgressIndicator(color: Colors.white)
                                ) : const Text(
                                  'text_delete_chart',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400
                                  ),
                                ).tr()
                            ),
                            if (chart != null) const SizedBox(height: 24),
                            ElevatedButton(
                                onPressed: () {
                                  if (controller.formKey.currentState!.validate()) {
                                    openChartSheet(context, controller, controller.chart?.id ?? 0, 0);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: controller.buttonVisible.value ? primaryColor : const Color(0xFFEFEFEF),
                                  minimumSize: Size(Get.width-36, 60),
                                  elevation: 0,
                                  alignment: Alignment.center,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(width: 1, color: controller.buttonVisible.value ? primaryColor : const Color(0xFFEFEFEF))
                                  ),
                                ),
                                child: Text(
                                  'text_chart_button',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Get.isDarkMode && !controller.buttonVisible.value ? secondColor : Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400
                                  ),
                                ).tr()
                            )
                          ],
                        ))
                      )
                  )
              ),
            )
        ));
  }

  void openChartSheet(BuildContext context, ChartEditController controller, int id, int idFormula) {
    if (controller.chart?.formulaList != null && controller.chart!.formulaList!.isNotEmpty) {
      for (var i in controller.chart!.formulaList!) {
        if (i.id == idFormula) {
          controller.formula.value = i.formula.split('|');
          List<String> items = <String>[];

          for (var i in i.formulaText.split("\n")) {
            items.add(i.trim());
          }

          controller.formulaText.value = items;
          break;
        }
      }
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
                bottom: Get.mediaQuery.viewInsets.bottom
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
                  Obx(() => Column(
                    children: [
                      Container(
                          decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color(0xFFF2F2F2)))
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: () => Get.back(),
                                    child: const Icon(Icons.arrow_back_ios, size: 16)
                                ),
                                Visibility(
                                  visible: controller.formula.isNotEmpty,
                                  child: InkWell(
                                      onTap: () => controller.edit(id, idFormula),
                                      child: Text(
                                        idFormula == 0 ? 'text_add' : 'text_change',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            color: primaryColor 
                                        ),
                                      ).tr()
                                  )
                                )
                              ]
                          )
                      ),
                      const SizedBox(height: 21),
                      if (controller.formulaText.isNotEmpty) controller.formulaText.length > 6 ? SizedBox(
                        height: 300,
                        child: Scrollbar(
                            controller: controller.scrollControllerFormula,
                            thumbVisibility: true,
                            trackVisibility: true,
                            child: ListView(
                                controller: controller.scrollControllerFormula, 
                                children: List.generate(controller.formulaText.length, (index) => Obx(() => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        controller.formulaText[index],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                      if (!controller.searchPrefix(controller.formulaText[index])) InkWell(
                                          onTap: () => controller.removeFormula(index),
                                          child: SvgPicture.asset('assets/icons/card.svg', semanticsLabel: 'Card', width: 16, height: 18)
                                      )
                                    ],
                                  )
                                )))
                            )
                        )
                      ) : Wrap(
                          children: List.generate(controller.formulaText.length, (index) => Obx(() => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    controller.formulaText[index],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                  if (!controller.searchPrefix(controller.formulaText[index])) InkWell(
                                      onTap: () => controller.removeFormula(index),
                                      child: SvgPicture.asset('assets/icons/card.svg', semanticsLabel: 'Card', width: 16, height: 18)
                                  )
                                ],
                              )
                          )))
                      ),
                      if (controller.formulaText.isNotEmpty) const SizedBox(height: 11),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        height: 53,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFF2F2F2)),
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => controller.setOperation('+'),
                                child: Container(
                                  height: 53,
                                  width: (Get.width / 4) - 12.5,
                                  decoration: BoxDecoration(
                                    color: Color(controller.operation.value == '+' ? 0xFF2F79F6 : 0xFFFFFFFF),
                                    border: const Border(right: BorderSide(color: Color(0xFFF2F2F2))),
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('+', style: TextStyle(color: controller.operation.value == '+' ? Colors.white : secondColor)),
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.setOperation('-'),
                                child: Container(
                                  height: 53,
                                  width: (Get.width / 4) - 12.5,
                                  decoration: BoxDecoration(
                                      color: Color(controller.operation.value == '-' ? 0xFF2F79F6 : 0xFFFFFFFF),
                                      border: const Border(right: BorderSide(color: Color(0xFFF2F2F2)))
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('-', style: TextStyle(color: controller.operation.value == '-' ? Colors.white : secondColor)),
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.setOperation('/'),
                                child: Container(
                                  height: 53,
                                  width: (Get.width / 4) - 12.5,
                                  decoration: BoxDecoration(
                                      color: Color(controller.operation.value == '/' ? 0xFF2F79F6 : 0xFFFFFFFF),
                                      border: const Border(right: BorderSide(color: Color(0xFFF2F2F2)))
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('/', style: TextStyle(color: controller.operation.value == '/' ? Colors.white : secondColor)),
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.setOperation('*'),
                                child: Container(
                                  height: 53,
                                  width: (Get.width / 4) - 12.5,
                                  decoration: BoxDecoration(
                                      color: Color(controller.operation.value == '*' ? 0xFF2F79F6 : 0xFFFFFFFF),
                                      border: const Border(right: BorderSide(color: Color(0xFFF2F2F2))),
                                      borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('*', style: TextStyle(color: controller.operation.value == '*' ? Colors.white : secondColor)),
                                ),
                              )
                            ]
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Divider(height: .1, color: Color(0xFFF2F2F2)),
                      Container(
                          height: controller.getDayIncome() ? controller.section5.value ? 314 : 74 : 254,
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Scrollbar(
                              controller: controller.scrollController,
                              thumbVisibility: true,
                              trackVisibility: true,
                              child: ListView(
                                  controller: controller.scrollController,
                                  children: [
                                    if (!controller.getDayIncome()) Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () => controller.section.toggle(),
                                          child: Container(
                                              decoration: const BoxDecoration(
                                                  border: Border(bottom: BorderSide(color: Color(0xFFF2F2F2)))
                                              ),
                                              height: 60,
                                              padding: const EdgeInsets.symmetric(horizontal: 24),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                      children: [
                                                        Container(
                                                            width: 31,
                                                            height: 31,
                                                            alignment: Alignment.centerLeft,
                                                            child: SvgPicture.asset('assets/icons/income_2.svg', semanticsLabel: 'Income', width: 24, height: 26)
                                                        ),
                                                        const SizedBox(width: 17),
                                                        const Text(
                                                          'text_income',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontFamily: 'Poppins',
                                                              fontWeight: FontWeight.w300,
                                                              color: secondColor
                                                          ),
                                                        ).tr()
                                                      ]
                                                  ),
                                                  Icon(controller.section.value ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 26, color: secondColor)
                                                ],
                                              )
                                          ),
                                        ),
                                        Visibility(
                                            visible: controller.section.value,
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () => controller.setSection(0, 0),
                                                    child: Container(
                                                        height: 60,
                                                        width: double.infinity,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.only(left: 71, right: 24),
                                                        child: Row(
                                                            children: [
                                                              const Text(
                                                                'text_plan_income',
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.w300,
                                                                    color: secondColor
                                                                ),
                                                              ).tr()
                                                            ]
                                                        )
                                                    ),
                                                  ),
                                                  const Divider(color: Color(0xFFF2F2F2), height: 0.1),
                                                  InkWell(
                                                    onTap: () => controller.setSection(0, 1),
                                                    child: Container(
                                                        height: 60,
                                                        width: double.infinity,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.only(left: 71, right: 24),
                                                        child: Row(
                                                            children: [
                                                              const Text(
                                                                'text_dop_income',
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.w300,
                                                                    color: secondColor
                                                                ),
                                                              ).tr()
                                                            ]
                                                        )
                                                    ),
                                                  ),
                                                  const Divider(color: Color(0xFFF2F2F2), height: 0.1),
                                                  InkWell(
                                                    onTap: () => controller.setSection(0, 2),
                                                    child: Container(
                                                        height: 60,
                                                        width: double.infinity,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.only(left: 71, right: 24),
                                                        child: Row(
                                                            children: [
                                                              const Text(
                                                                'text_fact_income',
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.w300,
                                                                    color: secondColor
                                                                ),
                                                              ).tr()
                                                            ]
                                                        )
                                                    ),
                                                  )
                                                ]
                                            )
                                        )
                                      ],
                                    ),
                                    if (!controller.getDayIncome()) Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () => controller.section2.toggle(),
                                          child: Container(
                                              decoration: const BoxDecoration(
                                                  border: Border(bottom: BorderSide(color: Color(0xFFF2F2F2)))
                                              ),
                                              height: 60,
                                              padding: const EdgeInsets.symmetric(horizontal: 24),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                      children: [
                                                        Container(
                                                            width: 31,
                                                            height: 31,
                                                            alignment: Alignment.centerLeft,
                                                            child: SvgPicture.asset('assets/icons/expense.svg', fit: BoxFit.cover, semanticsLabel: 'Income', width: 24, height: 29)
                                                        ),
                                                        const SizedBox(width: 17),
                                                        const Text(
                                                          'text_expense',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontFamily: 'Poppins',
                                                              fontWeight: FontWeight.w300,
                                                              color: secondColor
                                                          ),
                                                        ).tr()
                                                      ]
                                                  ),
                                                  Icon(controller.section2.value ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 26, color: secondColor)
                                                ],
                                              )
                                          ),
                                        ),
                                        Visibility(
                                            visible: controller.section2.value,
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () => controller.setSection(1, 0),
                                                    child: Container(
                                                        height: 60,
                                                        width: double.infinity,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.only(left: 71, right: 24),
                                                        child: Row(
                                                            children: [
                                                              const Text(
                                                                'text_plan_expense',
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.w300,
                                                                    color: secondColor
                                                                ),
                                                              ).tr()
                                                            ]
                                                        )
                                                    ),
                                                  ),
                                                  const Divider(color: Color(0xFFF2F2F2), height: 0.1),
                                                  InkWell(
                                                    onTap: () => controller.setSection(1, 1),
                                                    child: Container(
                                                        height: 60,
                                                        width: double.infinity,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.only(left: 71, right: 24),
                                                        child: Row(
                                                            children: [
                                                              const Text(
                                                                'text_dop_expense',
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.w300,
                                                                    color: secondColor
                                                                ),
                                                              ).tr()
                                                            ]
                                                        )
                                                    ),
                                                  ),
                                                  const Divider(color: Color(0xFFF2F2F2), height: 0.1),
                                                  InkWell(
                                                    onTap: () => controller.setSection(1, 2),
                                                    child: Container(
                                                        height: 60,
                                                        width: double.infinity,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.only(left: 71, right: 24),
                                                        child: Row(
                                                            children: [
                                                              const Text(
                                                                'text_fact_expense',
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.w300,
                                                                    color: secondColor
                                                                ),
                                                              ).tr()
                                                            ]
                                                        )
                                                    ),
                                                  )
                                                ]
                                            )
                                        )
                                      ],
                                    ),
                                    if (!controller.getDayIncome()) Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () => controller.section3.toggle(),
                                          child: Container(
                                              decoration: const BoxDecoration(
                                                  border: Border(bottom: BorderSide(color: Color(0xFFF2F2F2)))
                                              ),
                                              height: 60,
                                              padding: const EdgeInsets.symmetric(horizontal: 24),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                      children: [
                                                        Container(
                                                            width: 31,
                                                            height: 31,
                                                            alignment: Alignment.centerLeft,
                                                            child: SvgPicture.asset('assets/icons/income_3.svg', semanticsLabel: 'Income', width: 24, height: 26)
                                                        ),
                                                        const SizedBox(width: 17),
                                                        const Text(
                                                          'text_investments',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontFamily: 'Poppins',
                                                              fontWeight: FontWeight.w300,
                                                              color: secondColor
                                                          ),
                                                        ).tr()
                                                      ]
                                                  ),
                                                  Icon(controller.section3.value ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 26, color: secondColor)
                                                ],
                                              )
                                          ),
                                        ),
                                        Visibility(
                                            visible: controller.section3.value,
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () => controller.setSection(2, 0),
                                                    child: Container(
                                                        height: 60,
                                                        width: double.infinity,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.only(left: 71, right: 24),
                                                        child: Row(
                                                            children: [
                                                              const Text(
                                                                'text_plan_invest',
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.w300,
                                                                    color: secondColor
                                                                ),
                                                              ).tr()
                                                            ]
                                                        )
                                                    ),
                                                  ),
                                                  const Divider(color: Color(0xFFF2F2F2), height: 0.1),
                                                  InkWell(
                                                    onTap: () => controller.setSection(2, 1),
                                                    child: Container(
                                                        height: 60,
                                                        width: double.infinity,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.only(left: 71, right: 24),
                                                        child: Row(
                                                            children: [
                                                              const Text(
                                                                'text_dop_invest',
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.w300,
                                                                    color: secondColor
                                                                ),
                                                              ).tr()
                                                            ]
                                                        )
                                                    ),
                                                  ),
                                                  const Divider(color: Color(0xFFF2F2F2), height: 0.1),
                                                  InkWell(
                                                    onTap: () => controller.setSection(2, 2),
                                                    child: Container(
                                                        height: 60,
                                                        width: double.infinity,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.only(left: 71, right: 24),
                                                        child: Row(
                                                            children: [
                                                              const Text(
                                                                'text_fact_invest',
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.w300,
                                                                    color: secondColor
                                                                ),
                                                              ).tr()
                                                            ]
                                                        )
                                                    ),
                                                  )
                                                ]
                                            )
                                        )
                                      ],
                                    ),
                                    if (!controller.getDayIncome()) Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () => controller.section4.toggle(),
                                          child: Container(
                                              decoration: const BoxDecoration(
                                                  border: Border(bottom: BorderSide(color: Color(0xFFF2F2F2)))
                                              ),
                                              height: 60,
                                              padding: const EdgeInsets.symmetric(horizontal: 24),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                      children: [
                                                        Container(
                                                            width: 31,
                                                            height: 31,
                                                            alignment: Alignment.centerLeft,
                                                            child: SvgPicture.asset('assets/icons/income_4.svg', semanticsLabel: 'Income', width: 24, height: 26)
                                                        ),
                                                        const SizedBox(width: 17),
                                                        const Text(
                                                          'text_money_box',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontFamily: 'Poppins',
                                                              fontWeight: FontWeight.w300,
                                                              color: secondColor
                                                          ),
                                                        ).tr()
                                                      ]
                                                  ),
                                                  Icon(controller.section4.value ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 26, color: secondColor)
                                                ],
                                              )
                                          ),
                                        ),
                                        Visibility(
                                            visible: controller.section4.value,
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () => controller.setSection(3, 0),
                                                    child: Container(
                                                        height: 60,
                                                        width: double.infinity,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.only(left: 71, right: 24),
                                                        child: Row(
                                                            children: [
                                                              const Text(
                                                                'text_plan_money_box',
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.w300,
                                                                    color: secondColor
                                                                ),
                                                              ).tr()
                                                            ]
                                                        )
                                                    ),
                                                  ),
                                                  const Divider(color: Color(0xFFF2F2F2), height: 0.1),
                                                  InkWell(
                                                    onTap: () => controller.setSection(3, 1),
                                                    child: Container(
                                                        height: 60,
                                                        width: double.infinity,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.only(left: 71, right: 24),
                                                        child: Row(
                                                            children: [
                                                              const Text(
                                                                'text_dop_money_box',
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.w300,
                                                                    color: secondColor
                                                                ),
                                                              ).tr()
                                                            ]
                                                        )
                                                    ),
                                                  ),
                                                  const Divider(color: Color(0xFFF2F2F2), height: 0.1),
                                                  InkWell(
                                                    onTap: () => controller.setSection(3, 2),
                                                    child: Container(
                                                        height: 60,
                                                        width: double.infinity,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.only(left: 71, right: 24),
                                                        child: Row(
                                                            children: [
                                                              const Text(
                                                                'text_fact_money_box',
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.w300,
                                                                    color: secondColor
                                                                ),
                                                              ).tr()
                                                            ]
                                                        )
                                                    ),
                                                  )
                                                ]
                                            )
                                        )
                                      ],
                                    ),
                                    if (controller.getDayIncome(type: true)) Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () => controller.section5.toggle(),
                                          child: Container(
                                              decoration: const BoxDecoration(
                                                  border: Border(bottom: BorderSide(color: Color(0xFFF2F2F2)))
                                              ),
                                              height: 60,
                                              padding: const EdgeInsets.symmetric(horizontal: 24),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                      children: [
                                                        Container(
                                                            width: 31,
                                                            height: 31,
                                                            alignment: Alignment.centerLeft,
                                                            child: SvgPicture.asset('assets/icons/24.svg', semanticsLabel: 'Income', width: 24, height: 26)
                                                        ),
                                                        const SizedBox(width: 17),
                                                        const Text(
                                                          'text_day_expense',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontFamily: 'Poppins',
                                                              fontWeight: FontWeight.w300,
                                                              color: secondColor
                                                          ),
                                                        ).tr()
                                                      ]
                                                  ),
                                                  Icon(controller.section5.value ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, size: 26, color: secondColor)
                                                ],
                                              )
                                          ),
                                        ),
                                        Visibility(
                                            visible: controller.section5.value,
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: () => controller.setSection(4, 0),
                                                    child: Container(
                                                        height: 60,
                                                        width: double.infinity,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.only(left: 71, right: 24),
                                                        child: Row(
                                                            children: [
                                                              const Text(
                                                                'text_plan_spending',
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.w300,
                                                                    color: secondColor
                                                                ),
                                                              ).tr()
                                                            ]
                                                        )
                                                    ),
                                                  ),
                                                  const Divider(color: Color(0xFFF2F2F2), height: 0.1),
                                                  InkWell(
                                                    onTap: () => controller.setSection(4, 1),
                                                    child: Container(
                                                        height: 60,
                                                        width: double.infinity,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.only(left: 71, right: 24),
                                                        child: Row(
                                                            children: [
                                                              const Text(
                                                                'text_fact_spending',
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.w300,
                                                                    color: secondColor
                                                                ),
                                                              ).tr()
                                                            ]
                                                        )
                                                    ),
                                                  ),
                                                  const Divider(color: Color(0xFFF2F2F2), height: 0.1),
                                                  InkWell(
                                                    onTap: () => controller.setSection(4, 2),
                                                    child: Container(
                                                        height: 60,
                                                        width: double.infinity,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.only(left: 71, right: 24),
                                                        child: Row(
                                                            children: [
                                                              const Text(
                                                                'text_saldo_spending',
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.w300,
                                                                    color: secondColor
                                                                ),
                                                              ).tr()
                                                            ]
                                                        )
                                                    ),
                                                  ),
                                                  const Divider(color: Color(0xFFF2F2F2), height: 0.1),
                                                  InkWell(
                                                    onTap: () => controller.setSection(4, 3),
                                                    child: Container(
                                                        height: 60,
                                                        width: double.infinity,
                                                        alignment: Alignment.center,
                                                        padding: const EdgeInsets.only(left: 71, right: 24),
                                                        child: Row(
                                                            children: [
                                                              const Text(
                                                                'text_nokop_spending',
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontFamily: 'Poppins',
                                                                    fontWeight: FontWeight.w300,
                                                                    color: secondColor
                                                                ),
                                                              ).tr()
                                                            ]
                                                        )
                                                    ),
                                                  )
                                                ]
                                            )
                                        )
                                      ],
                                    )
                                  ]
                              )
                          )
                      )
                    ],
                  ))
                ],
              )
          );
        }
    ).then((value) => controller.clear());
  }
}