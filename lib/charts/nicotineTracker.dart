class NicotineTracker {
  DateTime registrationDate;
  Map<DateTime, int> cigarettesPerDay = {};

  NicotineTracker(this.registrationDate);

  void addCigarette() {
    DateTime today = DateTime.now();
    if (!cigarettesPerDay.containsKey(today)) {
      cigarettesPerDay[today] = 0;
    }
    cigarettesPerDay[today] = cigarettesPerDay[today]! + 1;
  }

  int daysSinceRegistration() {
    return DateTime.now().difference(registrationDate).inDays;
  }

  int calculateWeeklyThreshold(int daysSinceStart) {
    int weeksSinceStart = (daysSinceStart / 7).floor();
    return 5 - weeksSinceStart;
  }

  Map<DateTime, int> getCigarettesPerDay() {
    return cigarettesPerDay;
  }
}
