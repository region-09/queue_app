import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:queue_app/provider/provider.dart';
import 'package:provider/provider.dart';

void settingsInput(BuildContext context) async {
  final info = NetworkInfo();
  final ipAddress = await info.getWifiIP();
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
            TextButton(
              onPressed: () {
                globalProvider.toggleReverse();
              },
              style: TextButton.styleFrom(
               
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                textStyle: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                minimumSize: const Size(100, 50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Reverse List"),
                  const SizedBox(width: 10),
                  Switch(
                    thumbColor: WidgetStateProperty.all(
                        globalProvider.isReverse
                            ? Colors.green
                            : Colors.white),
                    value: globalProvider.isReverse,
                    onChanged: null,
                  )
                ],
              ),
            ),
            Text("IP: ${ipAddress ?? ""}"),
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
