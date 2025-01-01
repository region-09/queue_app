import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:queue_app/models/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalProvider with ChangeNotifier {
  double _fontSize = 1.0;
  HttpServer? _server;
  Queues? queues;
  String? errorMessage;
  String? errorMessage2;
  Color _backgroundColor = Colors.white;
  Color _primaryColor = Colors.black;

  double get fontSize => _fontSize;
  Color get backgroundColor => _backgroundColor;
  Color get primaryColor => _primaryColor;

  GlobalProvider() {
    _loadFontSize();
    startWebSocketServer();
  }

  void startWebSocketServer() async {
    try {
      _server = await HttpServer.bind(InternetAddress.anyIPv4, 8081);
      debugPrint("WebSocket сервер запущен на порту 8081");

      await for (HttpRequest request in _server!) {
        try {
          if (WebSocketTransformer.isUpgradeRequest(request)) {
            WebSocket socket = await WebSocketTransformer.upgrade(request);
            debugPrint("Клиент подключился!");

            socket.listen((data) {
              try {
                // debugPrint("Получены данные: $data");
                final Map<String, dynamic> decodedData = jsonDecode(data);
                final Queues queuesData =
                    Queues.fromJson(decodedData["queues"]);

                queues = queuesData;
                errorMessage2 = null;
                errorMessage = null;
                notifyListeners();

                socket.add("Сообщение принято: $data");
              } catch (e, stackTrace) {
                debugPrint("Ошибка при обработке данных WebSocket: $e");
                // debugPrint("$stackTrace");
                socket.add("Ошибка обработки данных: $e");
                errorMessage2 = "Ошибка обработки данных: $e";
                notifyListeners();
              }
            }, onError: (error) {
              debugPrint("Ошибка WebSocket: $error");
              errorMessage = "Ошибка сервера: $error";
            }, onDone: () {
              debugPrint("Клиент отключился");
              errorMessage = "Клиент отключился";
            });
          } else {
            request.response
              ..statusCode = HttpStatus.forbidden
              ..close();
          }
        } catch (e, stackTrace) {
          debugPrint("Ошибка при обработке HTTP-запроса: $e");
          // debugPrint("$stackTrace");

          errorMessage = "Ошибка сервера: $e";
          notifyListeners();

          request.response
            ..statusCode = HttpStatus.internalServerError
            ..write("Ошибка сервера: $e")
            ..close();
        }
      }
    } catch (e, stackTrace) {
      debugPrint("Ошибка при запуске WebSocket-сервера: $e");
      // debugPrint("$stackTrace");

      errorMessage = "Не удалось запустить сервер: $e";
      notifyListeners();
    }
  }

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///

  void setFontSize(double newSize) async {
    _fontSize = newSize;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', newSize);
  }

  void _loadFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _fontSize = prefs.getDouble('fontSize') ?? 1.0;
    notifyListeners();
  }

  @override
  void dispose() {
    _server?.close();
    super.dispose();
  }
}
