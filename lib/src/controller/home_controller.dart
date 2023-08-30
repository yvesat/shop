import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/enums/alert_type.dart';
import '../view/widgets/alert.dart';

class HomeController extends StateNotifier<AsyncValue<void>> {
  HomeController() : super(const AsyncValue.data(null));

  final Alert alert = Alert();

  Future<void> logOff(BuildContext context) async {
    return alert.dialog(
      context,
      AlertType.warning,
      "Log out from the app?",
      onPress: () {
        Navigator.pop(context);
        return context.pushReplacement('/');
      },
    );
  }
}

final homeControllerProvider = StateNotifierProvider<HomeController, AsyncValue<void>>((ref) => HomeController());

//TODO: LANGUAGE