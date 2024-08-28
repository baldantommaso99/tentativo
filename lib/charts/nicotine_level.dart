class NicotineLevel {
  final DateTime date;
  final double level;

  NicotineLevel(this.date, this.level);
}

class HourlyNicotineLevel {
  final DateTime time;
  final double level;

  HourlyNicotineLevel({required this.time, required this.level});
}
