import 'package:flutter/material.dart';
import 'package:queue_app/components/modals/settings_modal.dart';
import 'package:queue_app/provider/provider.dart';
import 'package:provider/provider.dart';

class MainLogoButton extends StatefulWidget {
  const MainLogoButton({super.key});

  @override
  _MainLogoButtonState createState() => _MainLogoButtonState();
}

class _MainLogoButtonState extends State<MainLogoButton> {
  @override
  Widget build(BuildContext context) {
    final globalProvider = context.watch<GlobalProvider>();
    return GestureDetector(
      onDoubleTap: () => settingsInput(context),
      child: Image.asset(
        'assets/main_logo.png',
        height: 50 * globalProvider.fontSize,
      ),
    );
  }
}
