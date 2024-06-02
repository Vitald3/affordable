import 'dart:io';
import 'package:affordable/utils/extension.dart';
import 'package:affordable/view/auth/confirmation.dart';
import 'package:affordable/view/auth/forgotten.dart';
import 'package:affordable/view/auth/login.dart';
import 'package:affordable/view/main_layout.dart';
import 'package:affordable/view/auth/register.dart';
import 'package:affordable/view/auth/reset.dart';
import 'package:affordable/view/auth/success_register.dart';
import 'package:affordable/view/setting/category_edit.dart';
import 'package:affordable/view/setting/language.dart';
import 'package:affordable/view/setting/notifications.dart';
import 'package:affordable/view/setting/pay.dart';
import 'package:affordable/view/setting/period.dart';
import 'package:affordable/view/setting/period_edit.dart';
import 'package:affordable/view/setting/planning.dart';
import 'package:affordable/view/setting/planning_edit.dart';
import 'package:affordable/view/setting/share.dart';
import 'package:affordable/view/setting/theme.dart';
import 'package:app_links/app_links.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'model/pay_response_model.dart';
import 'network/setting/pay.dart';
import 'utils/constant.dart';

SharedPreferences? prefs;
PayResponseModel? pay;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Supabase.initialize(
      url: supBaseUrl,
      anonKey: publicKey,
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
      debug: true
  );
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final event = data.event;

    if (prefs?.getInt('share_id') == null && Get.currentRoute != '/login' && event == AuthChangeEvent.signedOut) {
      Get.offAllNamed('/login');
    }
  });
  prefs = await SharedPreferences.getInstance();
  final awardMonth = (prefs?.getInt('award_month') ?? 0) + 1;
  prefs?.setInt('award_month', awardMonth);
  final String langCode = languagesList.firstWhereOrNull((element) => element.id == (prefs?.getInt('languageId') ?? 1))?.code ?? 'ru';
  var appLinks = AppLinks();
  final appLink = await appLinks.getInitialAppLink();

  if (Platform.isIOS) {
    appLinks.uriLinkStream.listen((uri) {
      final String? url = getRouteNameTo(uri);

      if (url != null) {
        Get.offAllNamed('/$url');
      }
    });
  }

  pay = await PayNetwork.getPay();
  bool endPeriod = false;

  if (pay == null) {
    PayNetwork.setPay();
  } else {
    if (!pay!.pay && pay!.date.difference(DateTime.now()).inDays > pay!.day) {
      endPeriod = true;
    }
  }

  runApp(EasyLocalization(
    supportedLocales: const [Locale('ru'), Locale('en'), Locale('es')],
    path: 'assets/translations',
    startLocale: Locale(langCode),
    fallbackLocale: Locale(langCode),
    child: App(appLink: appLink, endPeriod: endPeriod)
  ));
}

class App extends StatelessWidget {
  const App({super.key, this.appLink, required this.endPeriod});

  final Uri? appLink;
  final bool endPeriod;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
              child: child!
          );
        },
        initialRoute: endPeriod ? 'pay' : getRouteName(appLink),
        getPages: [
          GetPage(name: '/', page: () => const MainLayoutView()),
          GetPage(name: '/login', page: () => const LoginView()),
          GetPage(name: '/register', page: () => const RegisterView()),
          GetPage(name: '/forgotten', page: () => const ForgottenView()),
          GetPage(name: '/reset', page: () => const ResetView()),
          GetPage(name: '/confirmation', page: () => const ConfirmationView()),
          GetPage(name: '/success_register', page: () => const SuccessRegisterView()),
          GetPage(name: '/period', page: () => const PeriodView()),
          GetPage(name: '/period_edit', page: () => PeriodEditView()),
          GetPage(name: '/planning', page: () => const PlanningView()),
          GetPage(name: '/planning_edit', page: () => const PlanningEditView()),
          GetPage(name: '/category_edit', page: () => const CategoryEditView()),
          GetPage(name: '/share', page: () => const ShareView()),
          GetPage(name: '/languages', page: () => const LanguageView()),
          GetPage(name: '/theme', page: () => const ThemeView()),
          GetPage(name: '/notifications', page: () => const NotificationsView()),
          GetPage(name: '/pay', page: () => PayView(endPeriod: endPeriod))
        ],
        onUnknownRoute: (settings) => CupertinoPageRoute(
            builder: (context) {
              return const MainLayoutView();
            }
        ),
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: themeLight,
        darkTheme: themeDark,
        themeMode: getThemeMode()
    );
  }
}