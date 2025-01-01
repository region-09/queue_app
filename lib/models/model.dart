class Queues {
  final List<Queue>? cooking;
  final List<QueueDone>? done;

  Queues({
    this.cooking,
    this.done,
  });

  factory Queues.fromJson(Map<String, dynamic> json) {
    return Queues(
      cooking: (json['cooking'] as List).map((e) => Queue.fromJson(e)).toList(),
      done: (json['done'] as List).map((e) => QueueDone.fromJson(e)).toList(),
    );
  }
}

class Queue {
  final int id;
  final String time;
  final String info;
  final String counter;

  Queue({
    required this.id,
    required this.time,
    required this.info,
    required this.counter,
  });

  factory Queue.fromJson(Map<String, dynamic> json) {
    return Queue(
      id: json['id'],
      time: json['time'],
      info: json['info'],
      counter: json['counter'] as String,
    );
  }
}

class QueueDone {
  final int id;
  final String time;
  final String info;
  final String counter;
  final bool selected;

  QueueDone({
    required this.id,
    required this.time,
    required this.info,
    required this.counter,
    required this.selected,
  });

  factory QueueDone.fromJson(Map<String, dynamic> json) {
    return QueueDone(
      id: json['id'],
      time: json['time'],
      info: json['info'],
      counter: json['counter'] as String,
      selected: json['selected'],
    );
  }
}
