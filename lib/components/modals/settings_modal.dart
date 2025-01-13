import 'package:flutter/material.dart';
import 'package:queue_app/provider/provider.dart';
import 'package:provider/provider.dart';

void settingsInput(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final globalProvider = context.watch<GlobalProvider>();

      return AlertDialog(
        scrollable: true,
        contentPadding: const EdgeInsets.all(20),
        title: const Text(
          "Настройки",
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Размер текста',
              style: TextStyle(fontSize: 16), // Текст с масштабированием
            ),
            Slider(
              value: globalProvider.fontSize,
              min: 0.5,
              max: 4.0,
              divisions: 20,
              label: globalProvider.fontSize.toStringAsFixed(1),
              onChanged: (newValue) {
                globalProvider.setFontSize(newValue);
              },
            ),
            if (globalProvider.errorMessage != null)
              Text(
                globalProvider.errorMessage ?? '',
                style: const TextStyle(color: Colors.red),
              ),
            if (globalProvider.errorMessage2 != null)
              Text(
                globalProvider.errorMessage2 ?? '',
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      );
    },
  );
}
