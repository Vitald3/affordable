import 'package:affordable/utils/constant.dart';
import 'package:affordable/view/setting/menu.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller/award/award.dart';
import '../bottom_navigation_view.dart';

class AwardView extends StatelessWidget {
  const AwardView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AwardController>(
        init: AwardController(),
        builder: (controller) => Scaffold(
            key: controller.scaffoldKey,
            drawer: MenuView(scaffoldKey: controller.scaffoldKey, type: 4),
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
                                              child: SvgPicture.asset('assets/icons/setting2.svg', semanticsLabel: 'Setting', width: 31, height: 31)
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 9),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'text_award',
                                            style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.w400
                                            ),
                                          ).tr()
                                        ],
                                      )
                                    ],
                                  )
                              )
                          )
                      ),
                      SliverList(delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                        return Obx(() => controller.isLoading.value ? Padding(
                          padding: const EdgeInsets.only(left: 43, right: 43, top: 54, bottom: 18),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            runSpacing: 28,
                            spacing: 57,
                            children: List.generate(controller.items.length, (index) {
                              final Map<String, String> item = controller.items[index];
                              final bool active = controller.awards.firstWhereOrNull((element) => element.award == item['award']!) != null;

                              return SizedBox(
                                width: 118,
                                child: Column(
                                    children: [
                                      SvgPicture.asset('assets/icons/${item['award']}${active ? '_active' : ''}.svg', fit: BoxFit.cover, semanticsLabel: item['name'], width: 118, height: 108),
                                      const SizedBox(height: 19),
                                      Text(
                                        item['name']!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400
                                        ),
                                      )
                                    ]
                                )
                              );
                            })
                          )
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