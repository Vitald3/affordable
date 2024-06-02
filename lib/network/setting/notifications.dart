import 'package:affordable/utils/extension.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/notification_response_model.dart';

class NotificationsNetwork {
  static Future<bool> addNotification(int type) async {
    try {
      await Supabase.instance.client
          .from('notification')
          .insert({'type': type, 'uuid': Supabase.instance.client.auth.currentUser!.id});

      return true;
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return false;
  }

  static Future<bool> deleteNotification(int id) async {
    try {
      await Supabase.instance.client
          .from('notification')
          .delete()
          .eq('id', id);

      return true;
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return false;
  }

  static Future<List<NotificationResponseModel>> getNotifications() async {
    var items = <NotificationResponseModel>[];

    try {
      final response = await Supabase.instance.client
          .from('notification')
          .select();

      for (var i in response) {
        items.add(NotificationResponseModel.fromJson(i));
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return items;
  }
}