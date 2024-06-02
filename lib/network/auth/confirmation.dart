import 'package:affordable/utils/extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart';
import '../../model/expense_response.dart';
import '../../model/period_model.dart';
import '../../model/period_response_model.dart';
import '../../model/planning_response_model.dart';
import '../../model/share_response_model.dart';
import '../setting/share.dart';

class ConfirmationNetwork {
  static Future<int> addPeriod(PeriodModel model) async {
    int id = 0;

    try {
      final response = await Supabase.instance.client
          .from('periods')
          .insert({'name': model.name, 'day': model.day, 'price': model.price, 'ever': model.ever, 'uuid': Supabase.instance.client.auth.currentUser!.id})
          .select('id');

      if (response.isNotEmpty) {
        id = response.last['id'];
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return id;
  }

  static Future<PlanningResponseModel?> addPlanning(int periodId, List<int> categoryIds) async {
    try {
      final response = await Supabase.instance.client.from('plannings').insert({'category_id': categoryIds}).select('id');

      if (response.isNotEmpty) {
        final PlanningResponseModel planning = PlanningResponseModel.fromJson(response.single);

        await Supabase.instance.client
            .from('periods')
            .update({'planning_id': planning.id})
            .eq('id', periodId);

        return planning;
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return null;
  }

  static Future<void> addExpense(int planningId, ExpenseResponse expense) async {
    try {
      await Supabase.instance.client
          .from('expenses')
          .insert({'name': expense.name, 'price': expense.price, 'category_id': expense.categoryId, 'planning_id': planningId});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> share(int shareId) async {
    final ShareResponseModel? share = await ShareNetwork.updateShare(shareId);

    if (share != null) {
      final periods = await Supabase.instance.client
          .from('periods')
          .select('*, plannings(id, category_id, expenses(id, category_id, planning_id, name, price, created_at))')
          .eq('uuid', share.uuid!);

      for (var i in periods) {
        final PeriodResponseModel period = PeriodResponseModel.fromJson(i);

        int periodId = await ConfirmationNetwork.addPeriod(PeriodModel(name: period.name, day: period.day, price: period.price, ever: period.ever));
        PlanningResponseModel? planning = await ConfirmationNetwork.addPlanning(periodId, period.planning?.categoryIds ?? []);

        if (planning != null && period.planning!.expenses != null) {
          for (var expense in period.planning!.expenses!) {
            ConfirmationNetwork.addExpense(planning.id, expense);
          }
        }
      }

      prefs?.setBool('level', true);
      prefs?.remove('share_id');
      final List<String> items = (prefs?.getStringList('share_success_id') ?? []);
      items.add('$shareId');
      prefs?.setStringList('share_success_id', items);
    }
  }

  static Future<bool> confirm(String code, String email, {int shareId = 0}) async {
    try {
      final AuthResponse response = await Supabase.instance.client.auth.verifyOTP(
          type: OtpType.email,
          token: code,
          email: email
      );

      if (response.user != null) {
        if (shareId > 0) {
          ConfirmationNetwork.share(shareId);
        }

        return true;
      } else {
        snackBar(text: tr('error_code'), error: true);
        return false;
      }
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return false;
  }

  static Future<bool> reSend(String email) async {
    try {
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: email
      );

      return true;
    } catch (e) {
      snackBar(text: e.toString(), error: true);
    }

    return false;
  }
}