import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/calendar/calendar.dart';
import '../dashboard/spending_plan_edit.dart';

Padding buildCalendarInPadding({required CalendarController controller, required DateTime now, required List<MapEntry<String, List<List<MapEntry<String, Map<String, dynamic>>>>>> calendar, }) {

  DateTime realNow = DateTime.now();

  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: LayoutBuilder(
        builder: (context, constraint) {
          return Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 28,
              spacing: 57,
              children: List.generate(calendar.length, (x) {
                final MapEntry<String, List<List<MapEntry<String, Map<String, dynamic>>>>> item = calendar[x];
                bool boxStart = false;
                bool boxEnd = false;
                int boxInt = 0;

                return Column(
                    key: (now.year == realNow.year && now.month - 1 == x) ? controller.dataKey : null,
                    children: [
                      paintMonthHeader(item),
                      const SizedBox(height: 31),
                      paintDaysWeekHeader(),
                      const SizedBox(height: 14),
                      paintDaysInMonth(item, boxInt, boxStart, boxEnd, controller, constraint)
                    ]
                );
              })
          );
        },
      )
  );
}

Column paintDaysInMonth(MapEntry<String, List<List<MapEntry<String, Map<String, dynamic>>>>> item, int boxInt, bool boxStart, bool boxEnd, CalendarController controller, BoxConstraints constraint) {
  return Column(children: List.generate(item.value.length, (index) {
    final row = item.value[index];

    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        alignment: Alignment.center,
        child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (rowIndex) {
                    BorderRadius? radius;
                    final itemRow = row[rowIndex];

                    bool start = (itemRow.value['start'] ?? false);
                    bool end = (itemRow.value['end'] ?? false);

                    if (!end && rowIndex + 1 <= row.length - 1) {
                      end = row[rowIndex + 1].value['start'] ?? false;
                    }

                    if (!start && rowIndex - 1 >= 0) {
                      start = row[rowIndex - 1].value['end'] ?? false;
                    }

                    if (start) {
                      boxInt = int.tryParse(itemRow.key) ?? 0;
                      boxStart = true;
                      boxEnd = false;
                    }

                    if (boxStart) {
                      boxEnd = boxInt == controller.periodDays.last;
                      boxInt = 0;
                    }

                    if (boxEnd) {
                      boxStart = false;
                    }

                    if (rowIndex == 0 || (rowIndex - 1 > 0 && row[rowIndex - 1].key == '') || (rowIndex == 1 && row[0].key == '') || (start && !end)) {
                      if (rowIndex == 6) {
                        radius = const BorderRadius.all(Radius.circular(36));
                      } else {
                        radius = const BorderRadius.only(topLeft: Radius.circular(36), bottomLeft: Radius.circular(36));
                      }
                    } else if (rowIndex == 6 || (rowIndex + 1 <= row.length - 1 && (row[rowIndex + 1].key == '' || end))) {
                      radius = const BorderRadius.only(topRight: Radius.circular(36), bottomRight: Radius.circular(36));
                    }

                    if (rowIndex == 0 && (end || row[rowIndex + 1].key == '')) {
                      radius = const BorderRadius.all(Radius.circular(36));
                    }

                    if (boxEnd && !boxStart) {
                      boxEnd = false;
                    }

                    return Container(
                        width: ((constraint.maxWidth - 36) / 7) - (start || end ? 4 : 0),
                        height: 40,
                        margin: EdgeInsets.only(left: start ? 4 : 0, right: end ? 4 : 0),
                        alignment: Alignment.center,
                        decoration: itemRow.key != '' ? BoxDecoration(
                            color: boxStart || (!boxStart && boxEnd) ?
                            Get.isDarkMode ? const Color(0xFF232C35) : const Color(0xFFE1F5E4).withOpacity(.7) :
                            Get.isDarkMode ? const Color(0xFF252524) : const Color(0xFFECF2F2),
                            borderRadius: radius
                        ) : null
                    );
                  })
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (rowIndex) {
                        final itemRow = row[rowIndex];
                        final bool start = (itemRow.value['start'] ?? false);
                        final List<Color> bottom = itemRow.value['bottom'] ?? [];

                        return InkWell(
                            onTap: () {
                              if (itemRow.key != '') {
                                Get.to(() => SpendingPlanEditView(date: itemRow.value['date'], priceToDay: itemRow.value['priceToDay'] ?? 0, spendingPlanPrice: itemRow.value['spendingPlanPrice'] ?? 0.0, periodId: itemRow.value['periodId']))?.then((value) => controller.initializeMy(scroll: true));
                              }
                            },
                            borderRadius: const BorderRadius.all(Radius.circular(36)),
                            hoverColor: itemRow.key == '' ? Colors.transparent : null,
                            child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                      width: 36,
                                      height: 36,
                                      alignment: Alignment.center,
                                      decoration: ShapeDecoration(
                                        color: itemRow.value['background'],
                                        shape: OvalBorder(
                                            side: (itemRow.value['spendingPlanPrice'] ?? 0) > 0 ? const BorderSide(color: Color(0xFFFFBB00), width: 2) : const BorderSide(width: 0, color: Colors.transparent)
                                        ),
                                      ),
                                      child: Text(
                                        itemRow.key,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            decoration: start ? TextDecoration.underline : null,
                                            decorationColor: itemRow.value['color'],
                                            color: Get.isDarkMode ? Colors.white : itemRow.value['color'],
                                            fontSize: 16
                                        ),
                                      )
                                  ),
                                  if (bottom.isNotEmpty) Row(
                                      children: List.generate(bottom.length, (indexColor) => Container(
                                        width: 4,
                                        height: 4,
                                        margin: const EdgeInsets.only(bottom: 4.5),
                                        decoration: ShapeDecoration(
                                            color: bottom[indexColor],
                                            shape: const OvalBorder()
                                        ),
                                      ))
                                  )
                                ]
                            )
                        );
                      })
                  )
              )
            ]
        )
    );
  }));
}

Padding paintDaysWeekHeader() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) => SizedBox(
            width: 36,
            child: Text(
              'text_day_$index',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Get.isDarkMode ? Colors.white : const Color(0xFF4E4E4E),
                  fontSize: 16
              ),
            ).tr()
        ))
    ),
  );
}

Stack paintMonthHeader(MapEntry<String, List<List<MapEntry<String, Map<String, dynamic>>>>> item) {
  return Stack(
    alignment: Alignment.center,
    children: [
      LayoutBuilder(builder: (context, constraint) {
        return Container(
          width: constraint.maxWidth-15,
          margin: const EdgeInsets.symmetric(horizontal: 22),
          height: 2.5,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/line2.png'),
                  fit: BoxFit.fill
              )
          ),
        );
      }),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Get.isDarkMode ? Colors.black : Colors.white),
                child: Text(
                  item.key,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400
                  ),
                )
            )
          ]
      )
    ],
  );
}