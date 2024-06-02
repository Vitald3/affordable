import 'dart:io';
import 'package:affordable/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../controller/main_layout.dart';

class BottomNavigationView extends StatelessWidget {
  BottomNavigationView({super.key});

  final controller = Get.find<MainLayoutController>();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.black : Colors.white,
          boxShadow: [
            BoxShadow(
                color: Get.isDarkMode ? const Color(0xFFCECECE) : const Color(0x29000000),
                blurRadius: 18,
                offset: const Offset(0, 7),
                spreadRadius: 0
            )
          ],
        ),
        padding: EdgeInsets.only(top: 12, bottom: Platform.isIOS ? 0 : 12),
        child: BottomNavigationBar(
            selectedFontSize: 0,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/dashboard${controller.activeTab == 0 ? '' : '_gray'}.svg', colorFilter: Get.isDarkMode ? ColorFilter.mode(controller.activeTab == 0 ? Colors.white : secondColor, BlendMode.srcIn) : null, semanticsLabel: 'Dashboard', width: 33, height: 33),
                  label: ""
              ),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/${controller.activeTab == 1 ? 'income_3' : 'income_3_s'}.svg', colorFilter: Get.isDarkMode ? ColorFilter.mode(controller.activeTab == 1 ? Colors.white : secondColor, BlendMode.srcIn) : null, semanticsLabel: 'Setting', width: 33, height: 33),
                  label: ""
              ),
              BottomNavigationBarItem(
                  icon: Container(
                    alignment: Alignment.center,
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.only(bottom: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE33E34),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0x00000000).withAlpha(50),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                            spreadRadius: 0
                        )
                      ],
                    ),
                    child: const Text(
                      '+',
                      style: TextStyle(
                          color: Color(0xFFFCFCFC),
                          fontSize: 36,
                          fontWeight: FontWeight.w200
                      ),
                    ),
                  ),
                  label: ""
              ),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/calendar${controller.activeTab == 3 ? '' : '_gray'}.svg', colorFilter: Get.isDarkMode ? ColorFilter.mode(controller.activeTab == 3 ? Colors.white : secondColor, BlendMode.srcIn) : null, semanticsLabel: 'Category', width: 33, height: 33),
                  label: ""
              ),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/icons/cuboc${controller.activeTab == 4 ? '' : '_gray'}.svg', colorFilter: Get.isDarkMode ? ColorFilter.mode(controller.activeTab == 4 ? Colors.white : secondColor, BlendMode.srcIn) : null, semanticsLabel: 'Category', width: 33, height: 33),
                  label: ""
              )
            ],
            currentIndex: controller.activeTab,
            onTap: (int index) {
              controller.setActiveIndex(index);
            }
        )
    );
  }
}