import 'package:get/get.dart';
import '../../model/notification_response_model.dart';
import '../../network/setting/notifications.dart';

class NotificationsController extends GetxController {
  RxBool switchParam = false.obs;
  RxBool switchParam2 = false.obs;
  RxBool switchParam3 = false.obs;
  RxBool switchParam4 = false.obs;
  RxInt switchParamId = 0.obs;
  RxInt switchParamId2 = 0.obs;
  RxInt switchParamId3 = 0.obs;
  RxInt switchParamId4 = 0.obs;
  RxList<NotificationResponseModel> notifications = <NotificationResponseModel>[].obs;

  @override
  void onInit() async {
    getNotifications();
    super.onInit();
  }

  Future<void> getNotifications() async {
    NotificationsNetwork.getNotifications().then((value) {
      for (var i in value) {
        if (i.type == 1) {
          switchParam.value = true;
          switchParamId.value = i.id;
        } else if (i.type == 2) {
          switchParam2.value = true;
          switchParamId2.value = i.id;
        } else if (i.type == 3) {
          switchParam3.value = true;
          switchParamId3.value = i.id;
        } else if (i.type == 4) {
          switchParam4.value = true;
          switchParamId4.value = i.id;
        }
      }
    });
  }

  void setSwitchParam() {
    switchParam.toggle().obs;

    if (!switchParam.value) {
      NotificationsNetwork.deleteNotification(switchParamId.value).then((value) {
        if (!value) {
          switchParam.toggle().obs;
        }
      });
    } else {
      NotificationsNetwork.addNotification(1).then((value) {
        if (!value) {
          switchParam.toggle().obs;
        }
      });
    }
  }

  void setSwitchParam2() {
    switchParam2.toggle().obs;

    if (!switchParam2.value) {
      NotificationsNetwork.deleteNotification(switchParamId2.value).then((value) {
        if (!value) {
          switchParam2.toggle().obs;
        }
      });
    } else {
      NotificationsNetwork.addNotification(2).then((value) {
        if (!value) {
          switchParam2.toggle().obs;
        }
      });
    }
  }

  void setSwitchParam3() {
    switchParam3.toggle().obs;

    if (!switchParam3.value) {
      NotificationsNetwork.deleteNotification(switchParamId3.value).then((value) {
        if (!value) {
          switchParam3.toggle().obs;
        }
      });
    } else {
      NotificationsNetwork.addNotification(3).then((value) {
        if (!value) {
          switchParam3.toggle().obs;
        }
      });
    }
  }

  void setSwitchParam4() {
    switchParam4.toggle().obs;

    if (!switchParam4.value) {
      NotificationsNetwork.deleteNotification(switchParamId4.value).then((value) {
        if (!value) {
          switchParam4.toggle().obs;
        }
      });
    } else {
      NotificationsNetwork.addNotification(4).then((value) {
        if (!value) {
          switchParam4.toggle().obs;
        }
      });
    }
  }
}