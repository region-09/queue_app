import 'package:flutter/material.dart';
import 'package:queue_app/models/model.dart';
import 'package:queue_app/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MainContent extends StatefulWidget {
  final List<Queue> cooking;
  final List<QueueDone> done;
  const MainContent({
    super.key,
    required this.cooking,
    required this.done,
  });

  @override
  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  Color _currentColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _startBlinking();
  }

  void _startBlinking() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _currentColor = _currentColor == Color.fromARGB(255, 255, 241, 241)
            ? const Color.fromARGB(255, 92, 215, 115)
            : Color.fromARGB(255, 255, 241, 241);
      });
      _startBlinking();
    });
  }

  @override
  Widget build(BuildContext context) {
    final globalProvider = context.watch<GlobalProvider>();
    final size = MediaQuery.of(context).size;
    return Container(
      color: const Color.fromARGB(255, 255, 241, 241),
      width: size.width,
      height: size.height,
      margin: EdgeInsets.only(
        top: 70 * globalProvider.fontSize,
        bottom: 60 * globalProvider.fontSize,
        left: 15,
        right: 15,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: List.generate(
                  widget.cooking.length,
                  (index) => Container(
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.orange),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          getTimeDifference(widget.cooking[index].time),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.cooking[index].info,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          widget.cooking[index].counter,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 36),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            height: size.height,
            color: Colors.black,
          ),
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: List.generate(
                  widget.done.length,
                  (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: widget.done[index].selected
                              ? _currentColor
                              : Colors.transparent,
                          border: const Border(
                            bottom: BorderSide(
                              width: 1,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              getTimeDifference(widget.done[index].time),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              widget.done[index].info,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              widget.done[index].counter,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 36),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String getTimeDifference(String timeFromBackend) {
  DateFormat format = DateFormat("dd.MM.yyyy HH:mm");
  DateTime timeFromBackendDate = format.parse(timeFromBackend);

  DateTime currentTime = DateTime.now();
  Duration difference = currentTime.difference(timeFromBackendDate);

  int minutesDifference = difference.inMinutes;

  return '$minutesDifferenceмин';
}
