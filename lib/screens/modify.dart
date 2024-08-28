import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ModifyPage extends StatefulWidget {
  final String accountName;
  final String cigaretteType;
  final double nicotine;

  ModifyPage({
    required this.accountName,
    required this.cigaretteType,
    required this.nicotine,
  });

  @override
  _ModifyPageState createState() => _ModifyPageState();
}

class _ModifyPageState extends State<ModifyPage> {
  String? _selectedCigaretteType;
  double? _nicotine;

  @override
  void initState() {
    super.initState();
    _selectedCigaretteType = widget.cigaretteType;
    _nicotine = widget.nicotine;
  }

  Future<void> _saveChanges() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usersData = prefs.getString('users');
    Map<String, dynamic> users =
        usersData != null ? json.decode(usersData) : {};

    if (users.containsKey(widget.accountName)) {
      users[widget.accountName]['CigaretteType'] = _selectedCigaretteType;
      users[widget.accountName]['Nicotine'] = _nicotine;
      await prefs.setString('users', json.encode(users));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modify Cigarette'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DropdownButton<String>(
                value: _selectedCigaretteType,
                onChanged: (newValue) {
                  setState(() {
                    _selectedCigaretteType = newValue;
                    if (newValue == 'Light') {
                      _nicotine = 0.5;
                    } else if (newValue == 'Regular') {
                      _nicotine = 1.0;
                    } else if (newValue == 'Heavy') {
                      _nicotine = 1.5;
                    }
                  });
                },
                items:
                    <String>['Light', 'Regular', 'Heavy'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Text('Selected Nicotine: $_nicotine mg'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
