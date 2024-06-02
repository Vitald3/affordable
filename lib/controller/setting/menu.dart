import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../../utils/constant.dart';

class MenuItemsController extends GetxController {
  RxString theme = (prefs?.getString('theme') ?? 'system').obs;
  RxString language = (languagesList.firstWhereOrNull((element) => element.id == (prefs?.getInt('languageId') ?? languagesList.first.id))?.name ?? languagesList.first.name).obs;

  void updateLanguage() {
    language.value = languagesList.firstWhereOrNull((element) => element.id == (prefs?.getInt('languageId') ?? languagesList.first.id))?.name ?? languagesList.first.name;
  }

  void updateTheme() {
    update();
  }

  String getThemeName() {
    String themeStr = tr('text_theme_system');

    if (theme.value == 'dark') {
      themeStr = tr('text_theme_dark');
    } else if (theme.value == 'light') {
      themeStr = tr('text_theme_light');
    }

    return themeStr;
  }
}