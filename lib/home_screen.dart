import 'package:flutter/material.dart';
import 'package:queue_app/components/current_time.dart';
import 'package:queue_app/components/loading.dart';
import 'package:queue_app/components/main_content.dart';
import 'package:queue_app/components/main_logo.dart';
import 'package:queue_app/components/modals/settings_modal.dart';
import 'package:queue_app/provider/provider.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final globalProvider = context.watch<GlobalProvider>();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: globalProvider.queues == null
            ? Container(
                alignment: Alignment.center,
                color: Colors.black,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        overlayColor: Colors.transparent,
                      ),
                      onPressed: () => settingsInput(context),
                      child: Loading(
                        size: 60 * globalProvider.fontSize,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              )
            : Container(
                color: Colors.black,
                width: size.width,
                height: size.height,
                child: Stack(
                  children: [
                    MainContent(
                      cooking: globalProvider.queues!.cooking!,
                      done: globalProvider.queues!.done!,
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        height: 70 * globalProvider.fontSize,
                        decoration: const BoxDecoration(color: Colors.black),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Text(
                                'Готовятся',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: CurrentTimeWidget(),
                            ),
                            const Expanded(
                              flex: 1,
                              child: Text(
                                'Готовы',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(color: Colors.black),
                        height: 60 * globalProvider.fontSize,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(bottom: 10),
                        child: const Text(
                          'Очередь заказов',
                          style: TextStyle(
                            height: 0,
                            fontSize: 36,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60 * globalProvider.fontSize,
                        padding: const EdgeInsets.only(bottom: 10, left: 15),
                        alignment: Alignment.topLeft,
                        child: const MainLogoButton(),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
