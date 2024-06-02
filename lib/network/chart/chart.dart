import 'package:supabase_flutter/supabase_flutter.dart';
import '../../model/chart_response_model.dart';
import '../../utils/extension.dart';

class ChartNetwork {
  static Future<List<ChartResponseModel>> getCharts() async {
    var items = <ChartResponseModel>[];

    try {
      final response = await Supabase.instance.client
          .from('charts')
          .select('*, chart_formula(id, chart_id, formula, formula_text)')
          .eq('uuid', Supabase.instance.client.auth.currentUser!.id);

      for (var i in response) {
        items.add(ChartResponseModel.fromJson(i));
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return items;
  }

  static Future<bool> changeNameChart(ChartResponseModel chart, String name) async {
    try {
      await Supabase.instance.client
          .from('charts')
          .update({'name': name})
          .eq('id', chart.id);

      return true;
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return false;
  }

  static Future<ChartResponseModel?> addChart(String name, String formula, String formulaText) async {
    try {
      final response = await Supabase.instance.client
          .from('charts')
          .insert({'name': name, 'uuid': Supabase.instance.client.auth.currentUser!.id})
          .select();

      if (response.isNotEmpty) {
        await Supabase.instance.client
            .from('chart_formula')
            .insert({'chart_id': response.single['id'], 'formula': formula, 'formula_text': formulaText});

        final value = await Supabase.instance.client
            .from('charts')
            .select('*, chart_formula(id, chart_id, formula, formula_text)')
            .eq('id', response.single['id']);

        if (value.isNotEmpty) {
          return ChartResponseModel.fromJson(value.single);
        }
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return null;
  }

  static Future<ChartResponseModel?> editChart(int id, int idFormula, String name, String formula, String formulaText) async {
    try {
      final response = await Supabase.instance.client
          .from('charts')
          .update({'name': name})
          .eq('id', id)
          .select('id');

      if (response.isNotEmpty) {
        if (idFormula == 0) {
          await Supabase.instance.client
              .from('chart_formula')
              .insert({'chart_id': id, 'formula': formula, 'formula_text': formulaText});
        } else {
          await Supabase.instance.client
              .from('chart_formula')
              .update({'formula': formula, 'formula_text': formulaText})
              .eq('id', idFormula);
        }


        final value = await Supabase.instance.client
            .from('charts')
            .select('*, chart_formula(id, chart_id, formula, formula_text)')
            .eq('id', id);

        if (value.isNotEmpty) {
          return ChartResponseModel.fromJson(value.single);
        }
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return null;
  }

  static Future<ChartResponseModel?> deleteFormula(int id) async {
    try {
      final response = await Supabase.instance.client
          .from('chart_formula')
          .select('chart_id')
          .eq('id', id);

      await Supabase.instance.client
          .from('chart_formula')
          .delete()
          .eq('id', id);

      final value = await Supabase.instance.client
          .from('charts')
          .select('*, chart_formula(id, chart_id, formula, formula_text)')
          .eq('id', response.single['chart_id']);

      if (value.isNotEmpty) {
        return ChartResponseModel.fromJson(value.single);
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return null;
  }

  static Future<bool> removeChart(int id) async {
    try {
      await Supabase.instance.client
          .from('charts')
          .delete()
          .eq('id', id);

      return true;
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return false;
  }
}