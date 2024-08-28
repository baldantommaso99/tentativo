import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'cigarette_counter.dart';
import 'modify.dart';
import 'plots.dart';
import 'homePage.dart';
import 'delete_account_page.dart';

class ProfilePage extends StatefulWidget {
  final String accountName;

  ProfilePage({required this.accountName});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _cigaretteType;
  double? _nicotine;
  String? _registrationDate;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadCigarettesSmokedToday();
    _checkSavedData();
    _checkAndResetHourlyCounter();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accountName = prefs.getString('loggedInAccount');

    if (accountName != null) {
      String? usersData = prefs.getString('users');
      Map<String, dynamic> users =
          usersData != null ? json.decode(usersData) : {};

      if (users.containsKey(accountName)) {
        setState(() {
          _cigaretteType = users[accountName]['CigaretteType'];
          _nicotine = users[accountName]['Nicotine'];
          _registrationDate = users[accountName]['registrationDate'];
        });
      }
    }
  }

  Future<void> _loadCigarettesSmokedToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String todayKey = _getTodayKey();
    String dailyCountsKey = "${widget.accountName}_dailyCounts";
    String? dailyCountsData = prefs.getString(dailyCountsKey);
    Map<String, int> dailyCounts = dailyCountsData != null
        ? Map<String, int>.from(json.decode(dailyCountsData))
        : {};

    int cigarettes = prefs.getInt(todayKey) ?? 0;
    Provider.of<CigaretteCounter>(context, listen: false)
        .setCigarettes(cigarettes);
  }

  String _getTodayKey() {
    DateTime now = DateTime.now();
    String accountName = widget.accountName;
    return "${accountName}_cigarettes_${now.year}${now.month}${now.day}";
  }

  Future<void> _incrementCigaretteCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Recupera i dati dell'utente
    String accountName = widget.accountName;
    String todayKey = _getTodayKey();
    String hourlyKey = _getHourlyKey();
    String hourlyNicotineKey = _getHourlyNicotineKey();

    int newCount = Provider.of<CigaretteCounter>(context, listen: false)
            .cigarettesSmokedToday +
        1;

    setState(() {
      // Salva il conteggio delle sigarette per oggi
      prefs.setInt(todayKey, newCount);
      Provider.of<CigaretteCounter>(context, listen: false)
          .incrementCigarettes();
    });

    // Registra l'orario della sigaretta e aggiorna i dati
    await _recordCigaretteTime();

    _saveDailyCount(newCount); // Salva il conteggio giornaliero

    // Incrementa il contatore orario
    int hourlyCount = prefs.getInt(hourlyKey) ?? 0;
    hourlyCount++;
    double hourlyNicotine = prefs.getDouble(hourlyNicotineKey) ?? 0.0;
    hourlyNicotine += _nicotine ?? 0.0;

    Provider.of<CigaretteCounter>(context, listen: false)
        .updateHourlyCount(hourlyCount, hourlyNicotine);
    prefs.setInt(hourlyKey, hourlyCount);
    prefs.setDouble(hourlyNicotineKey, hourlyNicotine);

    // Aggiorna la UI per riflettere il nuovo valore del contatore orario
    setState(() {});
  }

  String _getHourlyKey() {
    DateTime now = DateTime.now();
    String accountName = widget.accountName;
    return "${accountName}_hourly_cigarettes_${now.year}${now.month}${now.day}${now.hour}";
  }

  String _getHourlyNicotineKey() {
    DateTime now = DateTime.now();
    String accountName = widget.accountName;
    return "${accountName}_hourly_nicotine_${now.year}${now.month}${now.day}${now.hour}";
  }

  Future<void> _checkSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dailyCountsKey = "${widget.accountName}_dailyCounts";
    String? dailyCountsData = prefs.getString(dailyCountsKey);

    print("Saved dailyCountsData: $dailyCountsData");
  }

  Future<void> _recordCigaretteTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentKey =
        "${widget.accountName}_${DateTime.now().toIso8601String()}";
    prefs.setInt(currentKey,
        1); // Registra che è stata fumata una sigaretta a questo orario
  }

  Future<void> _decrementCigaretteCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String todayKey = _getTodayKey();
    String hourlyKey = _getHourlyKey();
    String hourlyNicotineKey = _getHourlyNicotineKey();

    int currentCount = Provider.of<CigaretteCounter>(context, listen: false)
        .cigarettesSmokedToday;
    int hourlyCount = prefs.getInt(hourlyKey) ?? 0;
    double hourlyNicotine = prefs.getDouble(hourlyNicotineKey) ?? 0.0;

    if (currentCount > 0) {
      int newCount = currentCount - 1;
      setState(() {
        // Salva il conteggio delle sigarette per oggi
        prefs.setInt(todayKey, newCount);
        Provider.of<CigaretteCounter>(context, listen: false)
            .setCigarettes(newCount);
      });
      _saveDailyCount(newCount); // Salva il conteggio giornaliero

      // Decrementa il contatore orario
      if (hourlyCount > 0) {
        hourlyCount--;
        if (hourlyNicotine >= (_nicotine ?? 0.0)) {
          hourlyNicotine -= (_nicotine ?? 0.0);
        } else {
          hourlyNicotine = 0.0;
        }
        Provider.of<CigaretteCounter>(context, listen: false)
            .updateHourlyCount(hourlyCount, hourlyNicotine);
        prefs.setInt(hourlyKey, hourlyCount);
        prefs.setDouble(hourlyNicotineKey, hourlyNicotine);
      }

      // Aggiorna la UI per riflettere il nuovo valore del contatore orario
      setState(() {});
    }
  }

  Future<void> _checkAndResetHourlyCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String hourlyKey = _getHourlyKey();
    String hourlyNicotineKey = _getHourlyNicotineKey();
    String lastUpdateKey = "${widget.accountName}_lastHourlyUpdate";

    DateTime now = DateTime.now();
    DateTime lastUpdate =
        DateTime.parse(prefs.getString(lastUpdateKey) ?? now.toIso8601String());

    if (now.difference(lastUpdate).inMinutes >= 60) {
      // Reset or clear the hourly counter and nicotine
      prefs.setInt(hourlyKey, 0);
      prefs.setDouble(hourlyNicotineKey, 0.0);
      Provider.of<CigaretteCounter>(context, listen: false)
          .updateHourlyCount(0, 0.0);
      prefs.setString(lastUpdateKey, now.toIso8601String());
    }
  }

  Future<void> _saveDailyCount(int count) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String todayKey = _getTodayKey();
    String dailyCountsKey = "${widget.accountName}_dailyCounts";
    String? dailyCountsData = prefs.getString(dailyCountsKey);
    Map<String, int> dailyCounts = dailyCountsData != null
        ? Map<String, int>.from(json.decode(dailyCountsData))
        : {};
    dailyCounts[todayKey] = count;
    await prefs.setString(dailyCountsKey, json.encode(dailyCounts));
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInAccount'); // Remove the login state
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              HomePage()), // Replace HomePage() with your actual homepage widget
      (Route<dynamic> route) => false, // Remove all previous routes
    );
  }

  void _showDeleteConfirmation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeleteAccountPage(
          onDelete: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? accountName = prefs.getString('loggedInAccount');

            if (accountName != null) {
              // Recupera i dati degli utenti
              String? usersData = prefs.getString('users');
              Map<String, dynamic> users =
                  usersData != null ? json.decode(usersData) : {};

              // Rimuovi solo i dati dell'utente specifico
              if (users.containsKey(accountName)) {
                users.remove(
                    accountName); // Rimuovi solo i dati dell'utente corrente
                await prefs.setString('users', json.encode(users));
              }

              // Rimuovi il login
              await prefs.remove('loggedInAccount');
            }

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false,
            );
          },
          onCancel: () {
            Navigator.pop(context); // Torna alla pagina ProfilePage
          },
        ),
      ),
    );
  } //_showDeleteConfirmation

  @override
  Widget build(BuildContext context) {
    final cigaretteProvider = Provider.of<CigaretteCounter>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Account Name: ${widget.accountName}'),
            Text('Cigarette Type: $_cigaretteType'),
            Text('Nicotine: $_nicotine'),
            SizedBox(height: 20),
            Text(
                'Registration Date: ${_registrationDate != null ? DateTime.parse(_registrationDate!).toLocal().toString() : 'Not Available'}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModifyPage(
                      accountName: widget.accountName,
                      cigaretteType: _cigaretteType!,
                      nicotine: _nicotine!,
                    ),
                  ),
                ).then((_) {
                  _loadUserData();
                });
              },
              child: Text('Modify Profile'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _decrementCigaretteCount();
                  },
                  child: Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    child: Icon(
                      Icons.remove,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _incrementCigaretteCount();
                  },
                  child: Text('Add a Cigarette'),
                ),
                SizedBox(width: 20),
                Text(
                  '${cigaretteProvider.cigarettesSmokedToday}',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(width: 20),
                Text(
                  'Hourly: ${cigaretteProvider.hourlyCigarettesSmoked}',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Plots(accountName: widget.accountName),
                  ),
                );
              },
              child: Text('Your Progress'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ElevatedButton(
              onPressed: _showDeleteConfirmation,
              child: Icon(Icons.delete),
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
            ElevatedButton(
              onPressed: _logout,
              child: Icon(Icons.logout),
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
            Text(
              'Hourly Nicotine: ${cigaretteProvider.hourlyNicotine.toStringAsFixed(2)} mg',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
