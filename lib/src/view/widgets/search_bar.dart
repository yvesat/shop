import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const CustomSearchBar({super.key, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextField(
            onEditingComplete: () => Future.delayed(const Duration(), () => SystemChannels.textInput.invokeMethod('TextInput.hide')),
            controller: controller,
            onChanged: onChanged,
            onTapOutside: (_) => SystemChannels.textInput.invokeMethod('TextInput.hide'),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              label: Text(AppLocalizations.of(context)!.searchProduct,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: () => controller.clear(),
                child: const Icon(FontAwesomeIcons.x),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
