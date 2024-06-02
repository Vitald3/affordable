import 'package:affordable/model/income_response.dart';
import 'package:affordable/utils/constant.dart';
import 'package:affordable/view/dashboard/spending_plan_edit.dart';
import 'package:affordable/view/setting/menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller/dashboard/dashboard.dart';
import '../../model/category_response.dart';
import '../../model/expense_response.dart';
import '../../utils/extension.dart';
import '../bottom_navigation_view.dart';
import 'income_edit.dart';

class DashBoardView extends StatelessWidget {
  const DashBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
        init: DashboardController(),
        builder: (controller) => Scaffold(
            key: controller.scaffoldKey,
            drawer: MenuView(scaffoldKey: controller.scaffoldKey, type: 1),
            drawerEnableOpenDragGesture: false,
            body: SafeArea(
                child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                          automaticallyImplyLeading: false,
                          elevation: 0,
                          titleSpacing: 0,
                          scrolledUnderElevation: 0,
                          expandedHeight: 118,
                          floating: true,
                          flexibleSpace: FlexibleSpaceBar(
                              collapseMode: CollapseMode.pin,
                              background: Padding(
                                padding: const EdgeInsets.only(left: 18, right: 18, top: 18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              controller.scaffoldKey.currentState?.openDrawer();
                                            },
                                            child: SvgPicture.asset('assets/icons/setting2.svg', colorFilter: Get.isDarkMode ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null, semanticsLabel: 'Setting', width: 31, height: 31)
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 9),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'text_dashboard',
                                          style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w400
                                          ),
                                        ).tr(),
                                        Obx(() => InkWell(
                                            onTap: () {
                                              controller.setOpenAll();
                                            },
                                            child: Padding(
                                                padding: const EdgeInsets.only(right: 1.3),
                                                child: SvgPicture.asset('assets/icons/${controller.openAll.value ? 'open_all' : 'toarrow'}.svg', colorFilter: Get.isDarkMode ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null, semanticsLabel: 'Arrow', width: 27, height: 27)
                                            )
                                        ))
                                      ],
                                    ),
                                    Obx(() => Text(
                                      controller.periodDate.value,
                                      style: TextStyle(
                                          color: Get.isDarkMode ? Colors.white : const Color(0xFF7E7D84),
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w300,
                                          height: .6
                                      ),
                                    ))
                                  ],
                                )
                              )
                          )
                      ),
                      SliverList(delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                        return Obx(() => controller.isLoading.value ? Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 18, right: 18),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'text_to_day',
                                            style: TextStyle(
                                                color: Get.isDarkMode ? Colors.white : const Color(0xFF4A4A4A),
                                                fontSize: 22,
                                                fontFamily: 'Poppins'
                                            ),
                                          ).tr(),
                                          Text(
                                            convertPrice(controller.toDayPrice.value, char: ' '),
                                            style: TextStyle(
                                                color: controller.toDayPriceMin.value ? const Color(0xFFEE1F01) : const Color(0xFF0AA443),
                                                fontSize: 24,
                                                fontFamily: 'Poppins',
                                                fontWeight: controller.toDayPriceMin.value ? FontWeight.w400 : FontWeight.w500
                                            ),
                                          ),
                                        ],
                                      )
                                    ),
                                    const SizedBox(height: 19),
                                    Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Get.isDarkMode ? const Color(0xFF2B3034) : Colors.white,
                                            border: Border.all(
                                                color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFE4E8E9),
                                                width: 1
                                            ),
                                            borderRadius: const BorderRadius.all(Radius.circular(20))
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                        child: Column(
                                          children: [
                                            Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFECF2F2),
                                                child: InkWell(
                                                    onTap: () => Get.to(() => IncomeEditView(type: 1, incomes: controller.incomes, incomeId: 0, categoryId: 0, periodId: controller.periodId.value, planPrice: null, expenseId: 0, color: getColors(0), expenses: controller.expenses))?.then((value) => controller.initialize()),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                              'text_income',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Get.isDarkMode ? Colors.white : secondColor,
                                                                  fontFamily: 'Poppins'
                                                              ),
                                                            ).tr()
                                                        ),
                                                        Expanded(
                                                            child: Text(
                                                              convertPrice(controller.incomes.map((e) => e.categoryId == 0 ? e.price : 0).fold(0, (a, b) => a + b), char: ' '),
                                                              textAlign: TextAlign.right,
                                                              style: TextStyle(
                                                                  color: Get.isDarkMode ? Colors.white : const Color(0xFF4E4E4E),
                                                                  fontSize: 16,
                                                                  fontFamily: 'Poppins',
                                                                  fontWeight: FontWeight.w600
                                                              ),
                                                            )
                                                        )
                                                      ],
                                                    )
                                                )
                                            ),
                                            Container(
                                                color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFECF2F2),
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                child: Divider(thickness: 1, height: 1, color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFE4E8E9))
                                            ),
                                            Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 18),
                                                color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFECF2F2),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Get.isDarkMode ? Colors.transparent : const Color(0xFFECF2F2),
                                                        border: controller.incomeSalary.isNotEmpty ? Border(
                                                            bottom: BorderSide(
                                                                color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFE4E8E9),
                                                                width: 1
                                                            )
                                                        ) : null
                                                    ),
                                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                                    child: InkWell(
                                                        onTap: () => Get.to(() => IncomeEditView(incomes: controller.incomes, incomeId: controller.incomes.firstWhereOrNull((element) => element.salary)?.id ?? 0, categoryId: 0, periodId: controller.periodId.value, planPrice: double.parse('${controller.period?.value.price ?? 0}'), expenseId: controller.incomes.firstWhereOrNull((element) => element.salary)?.expenseId ?? 0, color: getColors(0), expenses: controller.expenses))?.then((value) => controller.initialize()),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              flex: 2,
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    width: 9,
                                                                    height: 9,
                                                                    decoration: ShapeDecoration(
                                                                      color: getColors(0),
                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 11),
                                                                  Expanded(
                                                                      child: Text(
                                                                        'text_salary',
                                                                        style: TextStyle(
                                                                            fontSize: 14,
                                                                            color: Get.isDarkMode ? Colors.white : secondColor,
                                                                            fontWeight: FontWeight.w400
                                                                        ),
                                                                      ).tr()
                                                                  )
                                                                ],
                                                              )
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                convertPrice(controller.salary.value, char: ' '),
                                                                textAlign: TextAlign.right,
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w400,
                                                                    color: controller.incomes.where((element) => element.salary == true).isNotEmpty ? Get.isDarkMode ? Colors.white : secondColor : const Color(0xFFC9D3E0)
                                                                ),
                                                              )
                                                            )
                                                          ],
                                                        )
                                                    )
                                                )
                                            ),
                                            Container(
                                              height: controller.incomeSalary.length * 49,
                                              color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFECF2F2),
                                              child: Column(
                                                children: List.generate(controller.incomeSalary.length, (index) {
                                                  final IncomeResponseModel item = controller.incomeSalary[index];

                                                  return Container(
                                                      color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFECF2F2),
                                                      padding: const EdgeInsets.symmetric(horizontal: 18),
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                            color: Get.isDarkMode ? Colors.transparent : const Color(0xFFECF2F2),
                                                            border: controller.incomeSalary.length-1 > index ? Border(
                                                                bottom: BorderSide(
                                                                    color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFE4E8E9),
                                                                    width: 1
                                                                )
                                                            ) : null,
                                                          ),
                                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                                          child: InkWell(
                                                              onTap: () => Get.to(() => IncomeEditView(incomes: controller.incomes, incomeId: item.id, categoryId: 0, periodId: controller.periodId.value, planPrice: double.parse('${item.price}'), expenseId: item.expenseId ?? 0, color: getColors(index, reset: true), expenses: controller.expenses))?.then((value) => controller.initialize()),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                      flex: 2,
                                                                      child: Row(
                                                                        children: [
                                                                          Container(
                                                                            width: 9,
                                                                            height: 9,
                                                                            decoration: ShapeDecoration(
                                                                              color: getColors(++index),
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(width: 11),
                                                                          Expanded(
                                                                              child: Text(
                                                                                item.name,
                                                                                style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    color: Get.isDarkMode ? Colors.white : secondColor,
                                                                                    fontWeight: FontWeight.w400
                                                                                ),
                                                                              )
                                                                          )
                                                                        ],
                                                                      )
                                                                  ),
                                                                  Expanded(
                                                                      child: Text(
                                                                        convertPrice(double.parse('${item.price}'), char: ' '),
                                                                        textAlign: TextAlign.right,
                                                                        style: const TextStyle(
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.w400
                                                                        ),
                                                                      )
                                                                  )
                                                                ],
                                                              )
                                                          )
                                                      )
                                                  );
                                                }),
                                              )
                                            ),
                                            Container(
                                                color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFECF2F2),
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                child: Divider(thickness: 1, height: 1, color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFE4E8E9))
                                            ),
                                            Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 18),
                                                decoration: BoxDecoration(
                                                    color: Get.isDarkMode ? const Color(0xFF2B3034) : const Color(0xFFECF2F2)
                                                ),
                                                child: Container(
                                                    color: Get.isDarkMode ? Colors.transparent : const Color(0xFFECF2F2),
                                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                                    height: 50,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          '${tr('text_plan')} ${convertPrice(double.parse('${controller.period?.value.price}'), char: ' ')}',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Get.isDarkMode ? Colors.white : secondColor,
                                                              fontWeight: FontWeight.w400
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            if (controller.incomes.where((element) => element.categoryId == 0 || element.salary).isNotEmpty || controller.planPercent.value < 0) Transform.rotate(
                                                                angle: controller.planPercent.value < 100 ? 22.01 : 0,
                                                                child: SvgPicture.asset('assets/icons/triangle.svg', colorFilter: ColorFilter.mode(controller.planPercent.value < 100 ? dangerColor : const Color(0xFF0AA443), BlendMode.srcIn), semanticsLabel: 'Triangel', width: 9, height: 10)
                                                            ),
                                                            const SizedBox(width: 4),
                                                            Text(
                                                              convertPrice(controller.planPercent.value, symbol: '%', char: ''),
                                                              style: TextStyle(
                                                                  color: controller.planPercent.value < 100 ? dangerColor : const Color(0xFF0AA443),
                                                                  fontSize: 14,
                                                                  fontFamily: 'Poppins',
                                                                  fontWeight: FontWeight.w400
                                                              ),
                                                            ),
                                                            if (controller.incomes.where((element) => element.categoryId == 0 && element.salary).isNotEmpty) const SizedBox(width: 4),
                                                            if (controller.incomes.where((element) => element.categoryId == 0 && element.salary).isNotEmpty) SizedBox(
                                                              width: 24,
                                                              height: 24,
                                                              child: InkWell(
                                                                  onTap: () {
                                                                    controller.sectionOpen(0);
                                                                  },
                                                                  child: SvgPicture.asset('assets/icons/${controller.openSection[0] ?? false ? 'arrow_down' : 'arrow_up'}.svg', colorFilter: Get.isDarkMode ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null, semanticsLabel: 'Arrow', width: 24, height: 24)
                                                              )
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                )
                                            ),
                                            Visibility(
                                              visible: controller.incomes.where((element) => element.salary == true).isNotEmpty && (controller.openSection[0] ?? false),
                                              child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 18),
                                                  child: Container(
                                                      color: Get.isDarkMode ? const Color(0xFF2B3034) : Colors.white,
                                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width: 9,
                                                                height: 9,
                                                                decoration: ShapeDecoration(
                                                                  color: getColors(0),
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                                ),
                                                              ),
                                                              const SizedBox(width: 11),
                                                              Text(
                                                                'text_salary',
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Get.isDarkMode ? Colors.white : secondColor,
                                                                    fontWeight: FontWeight.w400
                                                                ),
                                                              ).tr()
                                                            ],
                                                          ),
                                                          Text(
                                                            convertPrice(double.parse('${controller.period?.value.price ?? 0}'), char: ' '),
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w400,
                                                                color: Get.isDarkMode ? Colors.white : controller.incomes.where((element) => element.salary == true).isNotEmpty ? secondColor : const Color(0xFFC9D3E0)
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                  )
                                              )
                                            )
                                          ],
                                        )
                                    ),
                                    const SizedBox(height: 19),
                                    Wrap(
                                        runSpacing: 19,
                                        children: List.generate(controller.categories.length, (index) {
                                          final CategoryResponse category = controller.categories[index];
                                          List<ExpenseResponse> expenseList = <ExpenseResponse>[];
                                          List<IncomeResponseModel> incomeList = <IncomeResponseModel>[];

                                          if (controller.heightExpenses[category.id] == null) {
                                            expenseList = controller.expenses.where((e) => e.planningId == controller.period?.value.planningId && e.categoryId == category.id).toList();
                                            controller.heightExpenses.putIfAbsent(category.id, () => expenseList);
                                          } else {
                                            expenseList = controller.heightExpenses[category.id]!;
                                          }

                                          final double pricePlan = expenseList.map((e) => category.percent ? ((e.price / 100) * (controller.period?.value.price ?? 0)) : e.price).fold(0, (a, b) => a + b);
                                          final double percentDouble = controller.getPercent(category.id, pricePlan);
                                          final String percent = convertPrice(percentDouble, symbol: '%');
                                          bool percentBool = false;

                                          if (category.id == 5) {
                                            percentBool = percentDouble <= 100;
                                          } else if (category.id == 6) {
                                            percentBool = percentDouble >= 100;
                                          } else {
                                            percentBool = percentDouble >= 100;
                                          }

                                          if (!controller.colorBool.value) {
                                            controller.colorBool.value = percentBool;
                                          }

                                          if (controller.heightIncomes[category.id] == null) {
                                            incomeList = controller.incomes.where((element) => element.periodId == controller.period?.value.id && (element.expenseId ?? 0) == 0 && element.categoryId == category.id).toList();
                                            controller.heightIncomes.putIfAbsent(category.id, () => incomeList);
                                          } else {
                                            incomeList = controller.heightIncomes[category.id]!;
                                          }

                                          return Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Get.isDarkMode ? const Color(0xFF2B3034) : Colors.white,
                                                  border: Border.all(
                                                      color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFE4E8E9),
                                                      width: 1
                                                  ),
                                                  borderRadius: const BorderRadius.all(Radius.circular(20))
                                              ),
                                              clipBehavior: Clip.hardEdge,
                                              child: Column(
                                                children: [
                                                  Container(
                                                      width: double.infinity,
                                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                      color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFECF2F2),
                                                      child: InkWell(
                                                        onTap: () => Get.to(() => IncomeEditView(incomes: controller.incomes, incomeId: 0, categoryId: category.id, periodId: controller.periodId.value, planPrice: null, expenseId: 0, color: getColors(0), expenses: controller.expenses))?.then((value) => controller.initialize()),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Expanded(
                                                                flex: 2,
                                                                child: Text(
                                                                  category.name,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                      fontSize: 18,
                                                                      color: Get.isDarkMode ? Colors.white : secondColor,
                                                                      fontFamily: 'Poppins'
                                                                  ),
                                                                )
                                                            ),
                                                            Expanded(
                                                                child: Text(
                                                                  convertPrice(controller.incomes.map((e) => e.categoryId == category.id ? e.price : 0).fold(0, (a, b) => a + b), char: ' '),
                                                                  textAlign: TextAlign.right,
                                                                  style: TextStyle(
                                                                      color: Get.isDarkMode ? Colors.white : const Color(0xFF4E4E4E),
                                                                      fontSize: 16,
                                                                      fontFamily: 'Poppins',
                                                                      fontWeight: FontWeight.w600
                                                                  ),
                                                                )
                                                            )
                                                          ],
                                                        )
                                                      )
                                                  ),
                                                  if (pricePlan > 0 || expenseList.isNotEmpty || incomeList.isNotEmpty) Container(
                                                      color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFECF2F2),
                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                                      child: Divider(thickness: 1, height: 1, color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFE4E8E9))
                                                  ),
                                                  Column(
                                                    children: List.generate(expenseList.length, (index) {
                                                      final ExpenseResponse expense = expenseList[index];
                                                      final IncomeResponseModel? income = controller.incomes.firstWhereOrNull((element) => element.expenseId == expense.id);
                                                      final price = income?.price ?? (category.percent ? ((expense.price / 100) * (controller.period?.value.price ?? 1)) : expense.price);

                                                      return Container(
                                                          color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFECF2F2),
                                                          padding: const EdgeInsets.symmetric(horizontal: 18),
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Get.isDarkMode ? Colors.transparent : const Color(0xFFECF2F2),
                                                                border: expenseList.length-1 > index ? Border(
                                                                    bottom: BorderSide(
                                                                        color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFE4E8E9),
                                                                        width: 1
                                                                    )
                                                                ) : null,
                                                              ),
                                                              padding: const EdgeInsets.symmetric(vertical: 14),
                                                              child: InkWell(
                                                                  onTap: () => Get.to(() => IncomeEditView(incomes: controller.incomes, incomeId: income?.id ?? 0, categoryId: category.id, periodId: controller.periodId.value, expenseId: expense.id, planPrice: double.parse('${category.percent ? ((expense.price / 100) * (controller.period?.value.price ?? 0)) : expense.price}'), color: getColors(index, reset: true), expenses: controller.expenses))?.then((value) => controller.initialize()),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        flex: 2,
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
                                                                            Expanded(
                                                                                child: Text(
                                                                                  expense.name,
                                                                                  style: TextStyle(
                                                                                      fontSize: 14,
                                                                                      color: Get.isDarkMode ? Colors.white : secondColor,
                                                                                      fontWeight: FontWeight.w400
                                                                                  ),
                                                                                )
                                                                            )
                                                                          ],
                                                                        )
                                                                      ),
                                                                      Expanded(
                                                                        child: Text(
                                                                          convertPrice(double.parse('$price'), char: ' '),
                                                                          textAlign: TextAlign.right,
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Get.isDarkMode ? Colors.white : controller.incomes.where((element) => element.expenseId == expense.id).isNotEmpty ? secondColor : const Color(0xFFC9D3E0)
                                                                          ),
                                                                        )
                                                                      )
                                                                    ],
                                                                  )
                                                              )
                                                          )
                                                      );
                                                    }),
                                                  ),
                                                  if (incomeList.isNotEmpty) Container(
                                                      color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFECF2F2),
                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                                      child: Divider(thickness: 1, height: 1, color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFE4E8E9))
                                                  ),
                                                  Column(
                                                    children: List.generate(incomeList.length, (index) {
                                                      final IncomeResponseModel income = incomeList[index];
                                                      Color color = getColors(++index);

                                                      return Container(
                                                          color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFECF2F2),
                                                          padding: const EdgeInsets.symmetric(horizontal: 18),
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                color: Get.isDarkMode ? Colors.transparent : const Color(0xFFECF2F2),
                                                                border: expenseList.length-1 > index ? const Border(
                                                                    bottom: BorderSide(
                                                                        color: Color(0xFFE4E8E9),
                                                                        width: 1
                                                                    )
                                                                ) : null,
                                                              ),
                                                              padding: const EdgeInsets.symmetric(vertical: 14),
                                                              child: InkWell(
                                                                  onTap: () => Get.to(() => IncomeEditView(incomes: controller.incomes, incomeId: income.id, categoryId: category.id, periodId: controller.periodId.value, expenseId: income.expenseId ?? 0, planPrice: double.parse('${category.percent ? ((income.price / 100) * (controller.period?.value.price ?? 0)) : income.price}'), color: color, expenses: controller.expenses))?.then((value) => controller.initialize()),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        flex: 2,
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
                                                                            const SizedBox(width: 11),
                                                                            Expanded(
                                                                                child: Text(
                                                                                  income.name,
                                                                                  style: TextStyle(
                                                                                      fontSize: 14,
                                                                                      color: Get.isDarkMode ? Colors.white : secondColor,
                                                                                      fontWeight: FontWeight.w400
                                                                                  ),
                                                                                )
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child: Text(
                                                                          convertPrice(double.parse('${income.price}'), char: ' '),
                                                                          textAlign: TextAlign.right,
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Get.isDarkMode ? Colors.white : secondColor
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  )
                                                              )
                                                          )
                                                      );
                                                    }),
                                                  ),
                                                  if (pricePlan > 0) Container(
                                                      color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFECF2F2),
                                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                                      child: Divider(thickness: 1, height: 1, color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFE4E8E9))
                                                  ),
                                                  if (pricePlan > 0) Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 18),
                                                      decoration: BoxDecoration(
                                                          color: Get.isDarkMode ? const Color(0xFF2B3034) : const Color(0xFFECF2F2)
                                                      ),
                                                      height: 50,
                                                      child: Container(
                                                          color: Get.isDarkMode ? Colors.transparent : const Color(0xFFECF2F2),
                                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                  '${tr('text_plan')} ${convertPrice(pricePlan, char: ' ')}',
                                                                  style: TextStyle(
                                                                      fontSize: 14,
                                                                      color: Get.isDarkMode ? Colors.white : secondColor,
                                                                      fontWeight: FontWeight.w400
                                                                  )
                                                              ),
                                                              Row(
                                                                children: [
                                                                  if (controller.incomes.where((element) => element.categoryId == category.id && (element.expenseId ?? 0) != 0).isNotEmpty || percent.contains('-')) Transform.rotate(
                                                                      angle: !percentBool ? 22.01 : 0,
                                                                      child: SvgPicture.asset('assets/icons/triangle.svg', colorFilter: ColorFilter.mode(!percentBool ? dangerColor : const Color(0xFF0AA443), BlendMode.srcIn), semanticsLabel: 'Triangel', width: 9, height: 10)
                                                                  ),
                                                                  const SizedBox(width: 4),
                                                                  Text(
                                                                    percent,
                                                                    style: TextStyle(
                                                                        color: !percentBool ? dangerColor : const Color(0xFF0AA443),
                                                                        fontSize: 14,
                                                                        fontFamily: 'Poppins',
                                                                        fontWeight: FontWeight.w400
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 4),
                                                                  if (controller.incomes.where((element) => element.categoryId == category.id && (element.expenseId ?? 0) != 0).isNotEmpty) InkWell(
                                                                    onTap: () {
                                                                      controller.sectionOpen(category.id);
                                                                    },
                                                                    child: SvgPicture.asset('assets/icons/${(controller.openSection[category.id] ?? false) ? 'arrow_down' : 'arrow_up'}.svg', colorFilter: Get.isDarkMode ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null, semanticsLabel: 'Arrow', width: 24, height: 24)
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          )
                                                      )
                                                  ),
                                                  if (pricePlan > 0) Visibility(
                                                    visible: (controller.openSection[category.id] ?? false),
                                                    child: Column(
                                                      children: List.generate(controller.expenses.where((element) => element.categoryId == category.id).length, (index) {
                                                        final ExpenseResponse expense = controller.expenses.where((element) => element.categoryId == category.id).toList()[index];
                                                        int colorIndex = expenseList.lastIndexWhere((element) => element.id == expense.id);

                                                        if (controller.incomes.where((element) => element.expenseId == expense.id).isEmpty) {
                                                          return const SizedBox.shrink();
                                                        }

                                                        if (colorIndex < 0) {
                                                          colorIndex = 0;
                                                        }

                                                        final planPrice = (category.percent ? ((expense.price / 100) * (controller.period?.value.price ?? 1)) : expense.price);

                                                        return Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 18),
                                                            child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: Get.isDarkMode ? Colors.transparent : Colors.white,
                                                                  border: expenseList.length-1 > index ? const Border(
                                                                      bottom: BorderSide(
                                                                          color: Color(0xFFECF2F2),
                                                                          width: 1
                                                                      )
                                                                  ) : null,
                                                                ),
                                                                padding: const EdgeInsets.symmetric(vertical: 14),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          width: 9,
                                                                          height: 9,
                                                                          decoration: ShapeDecoration(
                                                                            color: getColors(colorIndex, reset: true),
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
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Text(
                                                                      convertPrice(double.parse('$planPrice'), char: ' '),
                                                                      style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w400,
                                                                          color: Get.isDarkMode ? Colors.white : controller.incomes.where((element) => element.expenseId == expense.id).isNotEmpty ? secondColor : const Color(0xFFC9D3E0)
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                            )
                                                        );
                                                      }),
                                                    ),
                                                  )
                                                ],
                                              )
                                          );
                                        })
                                    ),
                                    const SizedBox(height: 18)
                                  ],
                                )
                            ),
                            Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Get.isDarkMode ? Colors.transparent : Colors.white,
                                    border: Border.all(
                                        color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFE4E8E9),
                                        width: 1
                                    ),
                                    borderRadius: const BorderRadius.all(Radius.circular(20))
                                ),
                                margin: const EdgeInsets.symmetric(horizontal: 18),
                                clipBehavior: Clip.hardEdge,
                                child: Column(
                                  children: [
                                    Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFECF2F2),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: Text(
                                                  'text_plan_s',
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Get.isDarkMode ? Colors.white : secondColor
                                                  ),
                                                ).tr()
                                            ),
                                            Expanded(
                                                child: Text(
                                                  'text_fact_s',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      color: Get.isDarkMode ? Colors.white : secondColor,
                                                      fontSize: 18
                                                  ),
                                                ).tr()
                                            )
                                          ],
                                        )
                                    ),
                                    Container(
                                        color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFECF2F2),
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Divider(thickness: 1, height: 1, color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFE4E8E9))
                                    ),
                                    Container(
                                        color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFECF2F2),
                                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                        child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'text_total_expense',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Get.isDarkMode ? Colors.white : secondColor,
                                                        fontWeight: FontWeight.w300
                                                    ),
                                                  ).tr()
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    convertPrice(controller.realExpense.value, char: ' '),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Get.isDarkMode ? Colors.white : secondColor,
                                                        fontWeight: FontWeight.w600
                                                    ),
                                                  ),
                                                  Text(
                                                    convertPrice(controller.realIncome.value, char: ' '),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: controller.colorBool.value ? dangerColor : const Color(0xFF0AA443),
                                                        fontWeight: FontWeight.w600
                                                    ),
                                                  )
                                                ],
                                              )
                                            ]
                                        )
                                    ),
                                    Container(
                                        color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFECF2F2),
                                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                        child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'text_clean_income',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Get.isDarkMode ? Colors.white : secondColor,
                                                        fontWeight: FontWeight.w300
                                                    ),
                                                  ).tr()
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    convertPrice(controller.cleanIncome.value, char: ' '),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Get.isDarkMode ? Colors.white : secondColor,
                                                        fontWeight: FontWeight.w600
                                                    ),
                                                  ),
                                                  Text(
                                                    convertPrice(controller.realCleanTotal.value, char: ' '),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: controller.realCleanTotal.value < controller.cleanIncome.value ? dangerColor : const Color(0xFF0AA443),
                                                        fontWeight: FontWeight.w600
                                                    ),
                                                  )
                                                ],
                                              )
                                            ]
                                        )
                                    ),
                                    Container(
                                        color: Get.isDarkMode ? const Color(0xFF212427) : const Color(0xFFECF2F2),
                                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                        child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'text_today',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Get.isDarkMode ? Colors.white : secondColor,
                                                        fontWeight: FontWeight.w300
                                                    ),
                                                  ).tr()
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    convertPrice(controller.toDayPrice.value, char: ' '),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: controller.toDayPrice.value < 0 ? dangerColor : const Color(0xFF0AA443),
                                                        fontWeight: FontWeight.w600
                                                    ),
                                                  ),
                                                  Text(
                                                    convertPrice(controller.toDayRealPrice.value, char: ' '),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: controller.toDayRealPrice.value < controller.toDayPrice.value ? dangerColor : const Color(0xFF0AA443),
                                                        fontWeight: FontWeight.w600
                                                    ),
                                                  )
                                                ],
                                              )
                                            ]
                                        )
                                    )
                                  ],
                                )
                            ),
                            const SizedBox(height: 18),
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                      convertPrice(controller.expensePeriod.value, char: ' '),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: controller.cleanIncomeMin.value ? Get.isDarkMode ? Colors.white : const Color(0xFF91959E) : const Color(0xFF4E4E4E),
                                                          fontSize: 21,
                                                          fontFamily: 'Poppins',
                                                          fontWeight: FontWeight.w500
                                                      ),
                                                    )
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                      'text_expense_period',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: Get.isDarkMode ? Colors.white : const Color(0xFF91959E),
                                                          fontSize: 14,
                                                          fontFamily: 'Poppins',
                                                          fontWeight: FontWeight.w300
                                                      ),
                                                    ).tr()
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                    ),
                                    Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${controller.periodDayCount.value + 1}',
                                              style: TextStyle(
                                                  color: Get.isDarkMode ? Colors.white : controller.cleanIncomeMin.value ? const Color(0xFF91959E) : const Color(0xFF4E4E4E),
                                                  fontSize: 21,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w500
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                      'text_day_to_period',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: Get.isDarkMode ? Colors.white : const Color(0xFF91959E),
                                                          fontSize: 14,
                                                          fontFamily: 'Poppins',
                                                          fontWeight: FontWeight.w300
                                                      ),
                                                    ).tr()
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                    )
                                  ],
                                )
                            ),
                            const SizedBox(height: 18),
                            if (controller.tables.isNotEmpty) Container(
                              clipBehavior: Clip.hardEdge,
                              padding: const EdgeInsets.only(bottom: 18),
                              decoration: BoxDecoration(
                                  color: Get.isDarkMode ? Colors.transparent : Colors.white,
                              ),
                              child: Scrollbar(
                                controller: controller.scrollController,
                                child: SingleChildScrollView(
                                    reverse: true,
                                    controller: controller.scrollController,
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                        padding: const EdgeInsets.only(bottom: 18),
                                        width: (Get.width/4 * 5) + 10,
                                        child: Obx(() => Column(
                                            children: List.generate(controller.tables.length, (index) {
                                              final List<dynamic> items = controller.tables[index];

                                              return Slidable(
                                                  key: ValueKey(index),
                                                  enabled: index != 0 && items[8],
                                                  endActionPane: ActionPane(
                                                    extentRatio: 0.12,
                                                    motion: const ScrollMotion(),
                                                    children: [
                                                      CustomSlidableAction(
                                                          onPressed: (BuildContext context) => Get.to(() => SpendingPlanEditView(date: items[0], priceToDay: items[3], spendingPlanPrice: items[7], periodId: controller.periodId.value))?.then((value) => controller.initialize()),
                                                          padding: EdgeInsets.zero,
                                                          backgroundColor: const Color(0xFFE27919),
                                                          foregroundColor: Colors.white,
                                                          child: SvgPicture.asset('assets/icons/table.svg', semanticsLabel: 'Table', width: 18, height: 18)
                                                      ),
                                                    ],
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Get.to(() => IncomeEditView(date: items[0], priceToDay: items[3], incomes: controller.incomes, incomeId: 0, categoryId: null, periodId: controller.periodId.value, planPrice: null, expenseId: 0, color: getColors(0), expenses: controller.expenses))?.then((value) => controller.initialize());
                                                    },
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                bottom: BorderSide(
                                                                    color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFF2F2F2),
                                                                    width: 1
                                                                )
                                                            ),
                                                            color: index != 0 && items[7] > 0 ? const Color(0xFFFEFDF5) : index != 0 && items[5] == '1' ? const Color(0xFFF2FEF6) : Colors.transparent
                                                        ),
                                                        child: Row(children: List.generate(items.length-(index == 0 ? 0 : 4), (indexRow) {
                                                          return Container(
                                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                                              width: Get.width/4,
                                                              child: Stack(
                                                                alignment: Alignment.centerLeft,
                                                                children: [
                                                                  if (indexRow == 1 && index != 0 && items[6] != '' && items[7] == 0) Transform.translate(
                                                                      offset: const Offset(0, 0),
                                                                      child: Icon(items[6] == '1' ? Icons.arrow_downward : Icons.arrow_upward, color: Color(items[6] == '0' ? 0xFF548135 : 0xFFE33E34), size: 12)
                                                                  ),
                                                                  Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Expanded(
                                                                            child: Text(
                                                                              index == 0 || indexRow == 0 || indexRow == 1 || indexRow == 4 ? '${items[indexRow]}' : convertPrice(double.parse('${items[indexRow]}'), char: ',', symbol: ''),
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(
                                                                                  color: index > 0 && (indexRow == 1 || indexRow == 4) ? ('${items[indexRow]}'.contains('-') ? dangerColor : const Color(0xFF548135)) : Get.isDarkMode ? (index != 0 && items[5] == '1' ? secondColor : Colors.white) : const Color(0xFF4A4A4A),
                                                                                  fontSize: 12,
                                                                                  fontFamily: 'Poppins',
                                                                                  fontWeight: FontWeight.w300,
                                                                                  height: index == 0 ? 1.2 : 0
                                                                              ),
                                                                            )
                                                                        )
                                                                      ]
                                                                  )
                                                                ]
                                                              )
                                                          );
                                                        }))
                                                    )
                                                  )
                                              );
                                            })
                                        ))
                                    )
                                )
                              )
                            )
                          ],
                        ) : Container(
                            width: double.infinity,
                            height: Get.height/2-106,
                            alignment: Alignment.bottomCenter,
                            child: const SizedBox(
                                width: 26,
                                height: 26,
                                child: CircularProgressIndicator(color: primaryColor)
                            )
                        ));
                      }, childCount: 1))
                    ]
                )
            ),
            bottomNavigationBar: BottomNavigationView()
        ));
  }
}