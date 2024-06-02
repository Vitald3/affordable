import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';
import 'constant.dart';
import 'package:intl/intl.dart' as intl;

extension ToMaterialColor on Color {
  MaterialColor get asMaterialColor {
    Map<int, Color> shades = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900]
        .asMap()
        .map((key, value) => MapEntry(value, withOpacity(1 - (1 - (key + 1) / 10))));

    return MaterialColor(value, shades);
  }
}

Size textSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

void snackBar({String text = '', String title = '', bool error = false, Function? callback}) {
  showDialog(context: Get.context!, barrierColor: Colors.transparent, builder: (_) {
    return GestureDetector(onTap: () {
      Get.back();
    },
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Align(
                alignment: Alignment.center,
                child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x29000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: SizedBox(
                      width: Get.width-36,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 16),
                            Text(error ? 'error' : (title != '' ? title : 'success'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)).tr(),
                            SizedBox(height: 20, width: Get.width-36),
                            SelectableText(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black, fontSize: 15)),
                            const SizedBox(height: 12),
                            InkWell(
                                onTap: () {
                                  if (callback != null) {
                                    callback();
                                  } else {
                                    Get.back();
                                  }
                                },
                                child: const Text('text_continue', style: TextStyle(color: primaryColor)).tr()
                            ),
                            const SizedBox(height: 16),
                          ],
                        )
                      )
                    )
                )
            )
        )
      )
    );
  }).then((value) {
    if (callback != null) {
      callback();
    }
  });
}

String convertPrice(double price, {symbol = '₽', char = ' '}) {
  return '${intl.NumberFormat.decimalPattern().format(double.parse(price.toStringAsFixed(0).trim())).replaceAll(',', char)}${symbol != '' ? ' $symbol' : ''}';
}

int indexColors = 0;

Color getColors(int index, {bool reset = false}) {
  if (reset) {
    return colorList[index];
  }

  indexColors++;

  if (indexColors > colorList.length-1 || index == 0) {
    indexColors = 0;
  }

  return colorList[indexColors];
}

extension DateTimeExt on DateTime {
  int daysSince(DateTime date) => difference(date).inDays;
}

String getSystemTheme() {
  String str = 'light';

  if (Get.theme.brightness == Brightness.dark) {
    str = 'dark';
  }

  return str;
}

ThemeMode getThemeMode() {
  String theme = prefs?.getString('theme') ?? 'system';
  var themeData = ThemeMode.light;

  if (theme == 'dark') {
    themeData = ThemeMode.dark;
  }

  return themeData;
}

String getRouteName(Uri? url) {
  final List<String> items = (prefs?.getStringList('share_success_id') ?? []);
  String str = (prefs?.getBool('level') ?? false) && Supabase.instance.client.auth.currentUser != null ? '/' : (Supabase.instance.client.auth.currentUser != null ? '/' : '/login');
  String id = '';

  if (url != null && url.query.contains('share_id=') && int.tryParse('${url.queryParameters['share_id']}') != null) {
    id = url.queryParameters['share_id'] ?? '';
  }

  if (id != '' && (items.isEmpty || items.where((element) => element != id).isNotEmpty)) {
    prefs?.setInt('share_id', int.parse('${url!.queryParameters['share_id']}'));
    Supabase.instance.client.auth.signOut();
    str = 'register';
  }

  return str;
}

String? getRouteNameTo(Uri? url) {
  final List<String> items = (prefs?.getStringList('share_success_id') ?? []);
  String id = '';

  if (url != null && url.query.contains('share_id=') && int.tryParse('${url.queryParameters['share_id']}') != null) {
    id = url.queryParameters['share_id'] ?? '';
  }

  if (id != '' && (items.isEmpty || items.where((element) => element != id).isNotEmpty)) {
    String str = (prefs?.getBool('level') ?? false) && Supabase.instance.client.auth.currentUser != null ? '/' : (Supabase.instance.client.auth.currentUser != null ? '/' : '/login');

    if (url != null && url.query.contains('share_id=') && int.tryParse('${url.queryParameters['share_id']}') != null) {
      prefs?.setInt('share_id', int.parse('${url.queryParameters['share_id']}'));
      Supabase.instance.client.auth.signOut();
      str = 'register';
    }

    return str;
  }

  return null;
}

extension DateTimeExtension on DateTime {
  DateTime subtractMonths(int count) {
    var y = count ~/ 12;
    var m = count - y * 12;

    if (m > month) {
      y += 1;
      m = month - m;
    }

    return DateTime(year - y, month - m, day);
  }

  DateTime addMonth(int month) {
    final expectedMonth = (this.month + month) % 12;
    DateTime result = DateTime(year, this.month + month, day, hour, minute, second, millisecond, microsecond);
    final isOverflow = expectedMonth < result.month;
    if (isOverflow) {
      return DateTime(result.year, result.month, 1, result.hour, result.minute, result.second, result.millisecond, result.microsecond)
          .add(const Duration(days: -1));
    } else {
      return result;
    }
  }

  DateTime addDays(int days) => DateTime(year, month, day + days, hour, minute);

  bool isAfterOrEqualTo(DateTime dateTime) {
    final date = this;
    final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
    return isAtSameMomentAs | date.isAfter(dateTime);
  }

  bool isBeforeOrEqualTo(DateTime dateTime) {
    final date = this;
    final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
    return isAtSameMomentAs | date.isBefore(dateTime);
  }

  bool isBetween(DateTime fromDateTime, DateTime toDateTime,) {
    final date = this;
    final isAfter = date.isAfterOrEqualTo(fromDateTime);
    final isBefore = date.isBeforeOrEqualTo(toDateTime);
    return isAfter && isBefore;
  }
}

int getDaysInMonth(int year, int month) {
  if (month == DateTime.february) {
    final bool isLeapYear = (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
    return isLeapYear ? 29 : 28;
  }

  const List<int> daysInMonth = <int>[31, -1, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  return daysInMonth[month - 1];
}