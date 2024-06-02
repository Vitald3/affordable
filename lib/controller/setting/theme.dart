import 'package:affordable/main.dart';
import 'package:get/get.dart';
import '../../utils/constant.dart';
import '../../utils/extension.dart';

class ThemeController extends GetxController {
  RxString theme = (prefs?.getString('theme') ?? 'system').obs;

  void setTheme(String val) async {
    theme.value = val;
    prefs?.setString('theme', val);

    if (val == 'system') {
      val = getSystemTheme();
    }

    if (val == 'dark') {
      Get.changeTheme(themeDark);
    } else if (val == 'light') {
      Get.changeTheme(themeLight);
    }

    await Get.forceAppUpdate();
  }
}