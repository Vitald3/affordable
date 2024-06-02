import 'package:affordable/utils/extension.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/period_model.dart';
import '../../model/period_response_model.dart';

class PeriodNetwork {
  static Future<List<PeriodResponseModel>> getPeriods() async {
    var items = <PeriodResponseModel>[];

    try {
      final response = await Supabase.instance.client
          .from('periods')
          .select()
          .eq('uuid', Supabase.instance.client.auth.currentUser!.id)
          .order('day', ascending: true);

      for (var i in response) {
        items.add(PeriodResponseModel.fromJson(i));
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return items;
  }

  static Future<bool> addPeriod(PeriodModel model) async {
    try {
      await Supabase.instance.client
          .from('periods')
          .insert({'name': model.name, 'day': model.day, 'price': model.price, 'ever': model.ever, 'uuid': Supabase.instance.client.auth.currentUser!.id});

      return true;
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return false;
  }

  static Future<bool> removePeriod(int id) async {
    try {
      await Supabase.instance.client
          .from('periods')
          .delete()
          .eq('id', id);

      return true;
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return false;
  }

  static Future<bool> editPeriod(int id, PeriodModel model) async {
    try {
      await Supabase.instance.client
          .from('periods')
          .update({'name': model.name, 'day': model.day, 'price': model.price, 'ever': model.ever})
          .eq('id', id);

      return true;
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return false;
  }
}