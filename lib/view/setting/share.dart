import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller/setting/share.dart';
import '../../model/share_response_model.dart';
import '../../utils/constant.dart';
import '../../utils/extension.dart';

class ShareView extends StatelessWidget {
  const ShareView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShareController>(
        init: ShareController(),
        builder: (controller) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
            child: Scaffold(
                resizeToAvoidBottomInset: true,
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
                                  'text_share',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400
                                  ),
                                ).tr()
                              ],
                            ),
                            GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                    height: 40,
                                    width: 40,
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
                body: Container(
                    height: Get.height - (MediaQuery.of(context).padding.top) - Get.statusBarHeight,
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() => Container(
                              decoration: BoxDecoration(
                                border: controller.shareList.isNotEmpty ? const Border(
                                    bottom: BorderSide(
                                        color: Color(0xFFF2F2F2),
                                        width: 1
                                    ),
                                    top: BorderSide(
                                        color: Color(0xFFF2F2F2),
                                        width: 1
                                    )
                                ) : null,
                              ),
                              margin: const EdgeInsets.only(bottom: 20),
                              height: controller.shareList.length * 65 > controller.height - 218 ? controller.height - 234 : controller.shareList.length * 65,
                              child: Scrollbar(
                                  controller: controller.scrollController,
                                  thumbVisibility: true,
                                  trackVisibility: true,
                                  child: ListView.separated(controller: controller.scrollController, itemCount: controller.shareList.length, itemBuilder: (context, index) {
                                    final ShareResponseModel item = controller.shareList[index];

                                    return Slidable(
                                        endActionPane: ActionPane(
                                          dragDismissible: false,
                                          extentRatio: 0.22,
                                          motion: const ScrollMotion(),
                                          children: [
                                            SlidableAction(
                                                onPressed: (BuildContext context) {
                                                  controller.deleteShare(item.id);
                                                },
                                                spacing: 0,
                                                backgroundColor: dangerColor,
                                                foregroundColor: Colors.white,
                                                icon: Icons.delete
                                            ),
                                          ],
                                        ),
                                        child: InkWell(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 21),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 9,
                                                    height: 9,
                                                    decoration: ShapeDecoration(
                                                      color: getColors(index, reset: true),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 11),
                                                  Text(
                                                    item.email,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                        )
                                    );
                                  }, separatorBuilder: (BuildContext context, int index) {
                                    return Divider(color: Get.isDarkMode ? const Color(0xFF25282B) : const Color(0xFFF2F2F2), height: .1);
                                  })
                              )
                          )),
                          Form(
                            key: controller.formKey,
                            child: SizedBox(
                              width: Get.width-50,
                              child: TextFormField(
                                  controller: controller.email,
                                  autocorrect: false,
                                  validator: (val) {
                                    if (val == '') {
                                      return tr('field_required');
                                    } else if (val != '' && !EmailValidator.validate(val!)) {
                                      return tr('error_email');
                                    }

                                    return null;
                                  },
                                  onChanged: (val) {
                                    controller.updateButton();

                                    if (val != '' && EmailValidator.validate(val)) {
                                      controller.formKey.currentState!.validate();
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    labelStyle: const TextStyle(
                                        color: Color(0xFF828282),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300
                                    ),
                                    hintStyle: const TextStyle(
                                        color: Color(0xFFC9D3E0),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300
                                    ),
                                    hintText: tr('text_enter_email'),
                                    fillColor: Get.isDarkMode ? Colors.black45 : Colors.white,
                                    filled: true,
                                    suffixIcon: IconButton(
                                      icon: SvgPicture.asset('assets/icons/email.svg', semanticsLabel: 'Email', width: 24, height: 15),
                                      onPressed: () {},
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 23),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color: primaryColor,
                                        ),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color: dangerColor,
                                        ),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color: dangerColor,
                                        ),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color: Color(0xFFC9D3E0),
                                        ),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next
                              ),
                            )
                          ),
                          const SizedBox(height: 20),
                          Obx(() => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: ElevatedButton(
                                onPressed: () async {
                                  controller.addShare();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: controller.sendButton.value ? primaryColor : const Color(0xFFEFEFEF),
                                  minimumSize: Size(Get.width-44, 60),
                                  elevation: 0,
                                  alignment: Alignment.center,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(width: 1, color: controller.sendButton.value ? primaryColor : const Color(0xFFEFEFEF))
                                  ),
                                ),
                                child: controller.submitButton.value ? const SizedBox(
                                    width: 26,
                                    height: 26,
                                    child: CircularProgressIndicator(color: Colors.white)
                                ) : const Text(
                                  'text_share',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400
                                  ),
                                ).tr(),
                              )
                          ))
                        ],
                      ),
                    )
                )
            )
        )
    );
  }
}