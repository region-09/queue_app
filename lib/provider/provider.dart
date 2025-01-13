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
  bool isReverse = false;

  double get fontSize => _fontSize;

  GlobalProvider() {
    _loadFontSize();
    startWebSocketServer();
  }

  void startWebSocketServer() async {
    try {
      _server = await HttpServer.bind(InternetAddress.anyIPv4, 8088);
      debugPrint("Сервер запущен на порту 8081");

      await for (HttpRequest request in _server!) {
        try {
          handleHttpRequest(request);
        } catch (e) {
          debugPrint("Ошибка обработки запроса: $e");
          request.response
            ..statusCode = HttpStatus.internalServerError
            ..write('500 - Ошибка обработки запроса')
            ..close();
        }
      }
    } catch (e) {
      errorMessage = "Ошибка при запуске WebSocket-сервера: $e";
      debugPrint("Ошибка при запуске WebSocket-сервера: $e");
      startWebSocketServer();
    }
  }

  void handleHttpRequest(HttpRequest request) {
    final method = request.method;
    final path = request.uri.path;

    if (method == 'GET' && path == '/') {
      _handleGetRequest(request);
    } else if (method == 'POST' && path == '/') {
      _handlePostRequest(request);
    } else {
      _handleNotFound(request);
    }
  }

  void _handleGetRequest(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.ok
      ..headers.contentType = ContentType.html
      ..write('<h1 >Добро пожаловать на мой сервер!  ⭐⭐⭐</h1>')
      ..close();
  }

  void _handlePostRequest(HttpRequest request) async {
    final StringBuffer buffer = StringBuffer();
    try {
      await for (final data in request) {
        buffer.write(String.fromCharCodes(data));
      }
      final String body = buffer.toString();
      debugPrint('Получен запрос: $body');
      final decodedData = utf8.decode(const Latin1Codec().encode(body));
      final Map<String, dynamic> fromJson = jsonDecode(decodedData);
      final Queues queuesData = Queues.fromJson(fromJson["queues"]);

      queues = queuesData;
      errorMessage2 = null;
      errorMessage = null;
      notifyListeners();

      request.response
        ..statusCode = HttpStatus.ok
        ..write('Success')
        ..close();
    } catch (e) {
      debugPrint("Ошибка при обработке POST-запроса: $e");
      errorMessage = "Ошибка при обработке POST-запроса: $e";
      notifyListeners();
      request.response
        ..statusCode = HttpStatus.badRequest
        ..write('400 - Ошибка обработки данных')
        ..close();
    }
  }

  void _handleNotFound(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.notFound
      ..write('404 - Не найдено')
      ..close();
  }

  //=========================================================================
  void toggleReverse() {
    isReverse = !isReverse;
    notifyListeners();
  }

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
