import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controller/main_layout.dart';

class MainLayoutView extends StatelessWidget {
  const MainLayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainLayoutController>(
        init: MainLayoutController(),
        builder: (controller) => Navigator(
          key: controller.navigatorKeys[controller.activeTab],
          onGenerateRoute: (RouteSettings settings) {
            return CupertinoPageRoute(builder: (_) => controller.widgetOptions.elementAt(controller.activeTab));
          },
        )
    );
  }
}