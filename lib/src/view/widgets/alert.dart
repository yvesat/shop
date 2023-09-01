import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../model/enums/alert_type.dart';

class Alert {
  dialog(BuildContext context, AlertType type, String message, {VoidCallback? onPress}) {
    String title;
    String okButton;
    String? cancelButton;

    switch (type) {
      case AlertType.error:
        title = AppLocalizations.of(context)!.error;
        okButton = AppLocalizations.of(context)!.ok;
        break;
      case AlertType.warning:
        title = AppLocalizations.of(context)!.confirmation;
        okButton = AppLocalizations.of(context)!.confirm;
        cancelButton = AppLocalizations.of(context)!.cancel;
        break;
      case AlertType.sucess:
        title = AppLocalizations.of(context)!.success;
        okButton = AppLocalizations.of(context)!.ok;
        break;
      default:
        title = AppLocalizations.of(context)!.error;
        okButton = AppLocalizations.of(context)!.ok;
        break;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    // onPressed: onPress,
                    onPressed: () {
                      if (type == AlertType.warning) {
                        onPress == null ? Navigator.pop(context) : onPress();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(okButton),
                  ),
                  if (type == AlertType.warning)
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(cancelButton!),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  snack(BuildContext context, String mensagem, {String? botao}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Center(
        child: Text(
          mensagem,
        ),
      ),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(label: (botao ?? AppLocalizations.of(context)!.ok), onPressed: () {}),
    ));
  }
}

final alertaProvider = Provider((_) => Alert());
