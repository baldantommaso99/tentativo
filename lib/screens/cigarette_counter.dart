import 'package:flutter/foundation.dart';

class CigaretteCounter with ChangeNotifier {
  int _cigarettesSmokedToday = 0;
  int _hourlyCigarettesSmoked = 0;
  double _hourlyNicotine = 0.0;
  DateTime _lastHourlyUpdate = DateTime.now();

  int get cigarettesSmokedToday => _cigarettesSmokedToday;
  int get hourlyCigarettesSmoked => _hourlyCigarettesSmoked;
  double get hourlyNicotine => _hourlyNicotine;

  void incrementCigarettes() {
    _cigarettesSmokedToday++;
    notifyListeners();
  }

  void setCigarettes(int count) {
    _cigarettesSmokedToday = count;
    notifyListeners();
  }

  void setHourlyCigarettes(int count) {
    _hourlyCigarettesSmoked = count;
    notifyListeners();
  }

  void setHourlyNicotine(double nicotine) {
    _hourlyNicotine = nicotine;
    notifyListeners();
  }

  void updateHourlyCount(int count, double nicotine) {
    DateTime now = DateTime.now();
    // Check if an hour has passed since the last update
    if (now.difference(_lastHourlyUpdate).inMinutes >= 60) {
      _hourlyCigarettesSmoked = count;
      _hourlyNicotine = nicotine;
      _lastHourlyUpdate = now;
    } else {
      _hourlyCigarettesSmoked = count;
      _hourlyNicotine = nicotine;
    }
    notifyListeners();
  }
}
