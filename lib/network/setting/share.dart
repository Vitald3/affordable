import 'package:affordable/utils/extension.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/share_response_model.dart';

class ShareNetwork {
  static Future<bool> addShare(String email) async {
    try {
      await Supabase.instance.client
          .from('share')
          .insert({'email': email, 'uuid': Supabase.instance.client.auth.currentUser!.id});

      return true;
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return false;
  }

  static Future<ShareResponseModel?> updateShare(int id) async {
    try {
      final response = await Supabase.instance.client
          .from('share')
          .update({'status': 1})
          .eq('id', id)
          .select();

      if (response.isNotEmpty) {
        return ShareResponseModel.fromJson(response.last);
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return null;
  }

  static Future<bool> deleteShare(int id) async {
    try {
      await Supabase.instance.client
          .from('share')
          .delete()
          .eq('id', id);

      return true;
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return false;
  }

  static Future<List<ShareResponseModel>> getShare() async {
    var items = <ShareResponseModel>[];

    try {
      final response = await Supabase.instance.client
          .from('share')
          .select();

      for (var i in response) {
        items.add(ShareResponseModel.fromJson(i));
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return items;
  }

  static Future<ShareResponseModel?> getShareById(int id) async {
    try {
      final response = await Supabase.instance.client
          .from('share')
          .select()
          .eq('id', id);

      if (response.isNotEmpty) {
        return ShareResponseModel.fromJson(response.last);
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return null;
  }
}