import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../controller/award/award.dart';
import '../../controller/calendar/calendar.dart';
import '../../controller/dashboard/dashboard.dart';
import '../../controller/setting/menu.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key, required this.scaffoldKey, required this.type});

  final GlobalKey<ScaffoldState> scaffoldKey;
  final int type;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuItemsController>(
        init: MenuItemsController(),
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
                            const Text(
                              'text_setting',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400
                              ),
                            ).tr()
                          ],
                        ),
                        GestureDetector(
                            onTap: () {
                              scaffoldKey.currentState?.openEndDrawer();

                              if (type == 3) {
                                final itemController = Get.find<CalendarController>();
                                itemController.initialize();
                              } else if (type == 4) {
                                final itemController = Get.find<AwardController>();
                                itemController.initialize();
                              } else {
                                final itemController = Get.find<DashboardController>();
                                itemController.initialize();
                              }
                            },
                            child: Container(
                              height: 30,
                              width: 30,
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
            body: SafeArea(
                child: Container(
                    color: Get.isDarkMode ? Colors.black : Colors.white,
                    width: Get.width,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                                onTap: () => Get.toNamed('/period', arguments: {'title': true}),
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 18, right: 18, top: 20, bottom: 24),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                width: 24,
                                                child: SvgPicture.asset('assets/icons/set_period.svg', semanticsLabel: 'Period view', width: 27, height: 25),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                  child: const Text(
                                                    'text_period',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w300
                                                    ),
                                                  ).tr()
                                              )
                                            ],
                                          ),
                                        ),
                                        SvgPicture.asset('assets/icons/next.svg', semanticsLabel: 'Next', width: 10, height: 19),
                                      ],
                                    )
                                )
                            ),
                            Divider(color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFF2F2F2), height: .1),
                            InkWell(
                                onTap: () => Get.toNamed('/planning', arguments: {'title': true}),
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 18, right: 18, top: 20, bottom: 24),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                width: 24,
                                                child: SvgPicture.asset('assets/icons/planning.svg', colorFilter: Get.isDarkMode ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null, semanticsLabel: 'Planning view', width: 24, height: 25),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                  child: const Text(
                                                    'text_planning',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w300
                                                    ),
                                                  ).tr()
                                              )
                                            ],
                                          ),
                                        ),
                                        SvgPicture.asset('assets/icons/next.svg', semanticsLabel: 'Next', width: 10, height: 19),
                                      ],
                                    )
                                )
                            ),
                            Divider(color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFF2F2F2), height: .1),
                            InkWell(
                                onTap: () => Get.toNamed('/share'),
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 18, right: 18, top: 20, bottom: 24),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                width: 24,
                                                child: SvgPicture.asset('assets/icons/share.svg', colorFilter: Get.isDarkMode ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null, semanticsLabel: 'Share view', width: 24, height: 25),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                  child: const Text(
                                                    'text_share',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w300
                                                    ),
                                                  ).tr()
                                              )
                                            ],
                                          ),
                                        ),
                                        SvgPicture.asset('assets/icons/next.svg', semanticsLabel: 'Next', width: 10, height: 19),
                                      ],
                                    )
                                )
                            ),
                            Divider(color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFF2F2F2), height: .1),
                            InkWell(
                                onTap: () => Get.toNamed('/theme')?.then((value) => controller.updateTheme()),
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 18, right: 18, top: 20, bottom: 24),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                width: 24,
                                                child: SvgPicture.asset('assets/icons/shape.svg', colorFilter: Get.isDarkMode ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null, semanticsLabel: 'Shape view', width: 24, height: 25),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                  child: Obx(() => Text(
                                                    '${tr('text_theme')} ${controller.getThemeName()}',
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w300
                                                    ),
                                                  ))
                                              )
                                            ],
                                          ),
                                        ),
                                        SvgPicture.asset('assets/icons/next.svg', semanticsLabel: 'Next', width: 10, height: 19),
                                      ],
                                    )
                                )
                            ),
                            Divider(color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFF2F2F2), height: .1),
                            /*InkWell(
                                onTap: () => Get.toNamed('/notifications'),
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 18, right: 18, top: 20, bottom: 24),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                width: 24,
                                                child: SvgPicture.asset('assets/icons/notify.svg', colorFilter: Get.isDarkMode ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null, semanticsLabel: 'Notification view', width: 24, height: 25),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                  child: const Text(
                                                    'text_notify',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w300
                                                    ),
                                                  ).tr()
                                              )
                                            ],
                                          ),
                                        ),
                                        SvgPicture.asset('assets/icons/next.svg', semanticsLabel: 'Next', width: 10, height: 19),
                                      ],
                                    )
                                )
                            ),
                            Divider(color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFF2F2F2), height: .1),*/
                            InkWell(
                                onTap: () => Get.toNamed('/languages')?.then((value) => controller.updateLanguage()),
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 18, right: 18, top: 20, bottom: 24),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                width: 24,
                                                child: SvgPicture.asset('assets/icons/global.svg', colorFilter: Get.isDarkMode ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null, semanticsLabel: 'Languages view', width: 24, height: 25),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                  child: Obx(() => Text(
                                                    '${tr('text_languages')} ${controller.language}',
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w300
                                                    ),
                                                  ))
                                              )
                                            ],
                                          ),
                                        ),
                                        SvgPicture.asset('assets/icons/next.svg', semanticsLabel: 'Next', width: 10, height: 19),
                                      ],
                                    )
                                )
                            ),
                            Divider(color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFF2F2F2), height: .1),
                            InkWell(
                                onTap: () => Get.toNamed('/pay')?.then((value) => controller.updateLanguage()),
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 18, right: 18, top: 20, bottom: 24),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                width: 24,
                                                child: SvgPicture.asset('assets/icons/global.svg', colorFilter: Get.isDarkMode ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null, semanticsLabel: 'Languages view', width: 24, height: 25),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                  child: const Text(
                                                    'text_pay',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.w300
                                                    ),
                                                  ).tr()
                                              )
                                            ],
                                          ),
                                        ),
                                        SvgPicture.asset('assets/icons/next.svg', semanticsLabel: 'Next', width: 10, height: 19),
                                      ],
                                    )
                                )
                            ),
                            Divider(color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFF2F2F2), height: .1),
                            InkWell(
                                onTap: () => Supabase.instance.client.auth.signOut(),
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 18, right: 18, top: 20, bottom: 24),
                                    child: Row(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width: 24,
                                          child: SvgPicture.asset('assets/icons/logout.svg', colorFilter: Get.isDarkMode ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null, semanticsLabel: 'Logout', width: 24, height: 25),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                            child: const Text(
                                              'text_logout',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w300
                                              ),
                                            ).tr()
                                        )
                                      ],
                                    ),
                                )
                            ),
                            Divider(color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFF2F2F2), height: .1)
                          ]
                      ),
                    )
                )
            ))
    );
  }
}