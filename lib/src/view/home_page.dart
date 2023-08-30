import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controller/home_controller.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final homeController = ref.read(homeControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Theme.of(context).colorScheme.secondary,
          onPressed: () => homeController.logOff(context),
          icon: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
        ),
        centerTitle: true,
        title: const Text("Shop"),
        // actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1 / 1),
        ),
      ),
    );
  }
}
