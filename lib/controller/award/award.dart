import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/award_response_model.dart';
import '../../network/award/award.dart';

class AwardController extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  RxBool isLoading = false.obs;
  RxList<AwardResponseModel> awards = <AwardResponseModel>[].obs;
  List<Map<String, String>> items = [
    {'name': tr('text_award_1'), 'award': 'award_1'},
    {'name': tr('text_award_2'), 'award': 'award_2'},
    {'name': tr('text_award_3'), 'award': 'award_3'},
    {'name': tr('text_award_4'), 'award': 'award_4'},
    {'name': tr('text_award_5'), 'award': 'award_5'},
    {'name': tr('text_award_6'), 'award': 'award_6'},
    {'name': tr('text_award_7'), 'award': 'award_7'},
    {'name': tr('text_award_8'), 'award': 'award_8'},
    {'name': tr('text_award_9'), 'award': 'award_9'},
    {'name': tr('text_award_10'), 'award': 'award_10'},
    {'name': tr('text_award_11'), 'award': 'award_11'},
    {'name': tr('text_award_12'), 'award': 'award_12'},
    {'name': tr('text_award_13'), 'award': 'award_13'},
    {'name': tr('text_award_14'), 'award': 'award_14'},
    {'name': tr('text_award_15'), 'award': 'award_15'},
    {'name': tr('text_award_16'), 'award': 'award_16'},
    {'name': tr('text_award_17'), 'award': 'award_17'}
  ];

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  void initialize() async {
    awards.addAll(await AwardNetwork.getAwards());
    isLoading.value = true;
  }
}