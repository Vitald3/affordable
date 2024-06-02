import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/award_response_model.dart';
import '../../utils/extension.dart';

class AwardNetwork {
  static Future<List<AwardResponseModel>> getAwards() async {
    var items = <AwardResponseModel>[];

    try {
      final response = await Supabase.instance.client
          .from('awards')
          .select()
          .eq('uuid', Supabase.instance.client.auth.currentUser!.id);

      for (var i in response) {
        items.add(AwardResponseModel.fromJson(i));
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return items;
  }

  static Future<bool> setAward(int award) async {
    try {
      final response = await Supabase.instance.client
          .from('awards')
          .insert({'award': 'award_$award', 'uuid': Supabase.instance.client.auth.currentUser!.id})
          .select('id');

      if (response.isNotEmpty) {
        return true;
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return false;
  }
}