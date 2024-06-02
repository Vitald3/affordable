import 'package:affordable/utils/extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tinkoff_sdk/tinkoff_sdk.dart';
import '../../main.dart';
import '../../network/setting/pay.dart';

class PayController extends GetxController {
  RxBool submitButton = false.obs;
  RxBool free = (pay?.pay ?? true).obs;
  final TinkoffSdk acquiring = TinkoffSdk();

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {
    acquiring.activate(
        terminalKey: '',
        publicKey: '',
        logging: true,
        isDeveloperMode: true
    );
  }

  Future<void> setPay(bool type) async {
    free.value = type;
  }

  Future<void> go() async {
    if (free.value) {
      Get.back();
    } else {
      final TinkoffResult result = await openPaymentScreen(orderOptions: OrderOptions(orderId: '${pay!.id}', amount: 3000), customerOptions: CustomerOptions(customerKey: Supabase.instance.client.auth.currentUser!.id));

      if (result.success) {
        PayNetwork.updatePay();
        snackBar(text: tr('text_pay_success'), callback: () => Get.back());
      } else {
        snackBar(text: result.message, error: true);
      }
    }
  }

  Future<TinkoffResult> openPaymentScreen({
    required OrderOptions orderOptions,
    required CustomerOptions customerOptions,
  }) async {
    return await acquiring.openPaymentScreen(
      terminalKey: '',
      publicKey: '',
      orderOptions: orderOptions,
      customerOptions: customerOptions,
      featuresOptions: const FeaturesOptions(
        fpsEnabled: true
      ),
    );
  }
}