import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String? _firstName;
  String? _lastName;
  String? _accountName;
  String? _password;
  int? _cigPerDay;
  String? _cigType;
  double? _nicotine;

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final DateTime registrationDate =
          DateTime.now().toUtc(); // Data di registrazione
      String formattedDate = registrationDate.toIso8601String();

      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Recupera i dati degli utenti esistenti
      String? usersData = prefs.getString('users');
      Map<String, dynamic> users =
          usersData != null ? json.decode(usersData) : {};

      // Aggiungi i dati del nuovo utente
      users[_accountName!] = {
        'FirstName': _firstName,
        'LastName': _lastName,
        'Password': _password,
        'CigarettesPerDay': _cigPerDay,
        'CigaretteType': _cigType,
        'Nicotine': _nicotine,
        'registrationDate': formattedDate, // Salva la data di registrazione
      };

      // Salva i dati aggiornati
      await prefs.setString('users', json.encode(users));
      print('User data saved: ${users[_accountName!]}'); // Debug
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'First name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _firstName = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Last name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your last name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _lastName = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Account name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your account name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _accountName = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value;
                },
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Number of cigarettes per day'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the number of cigarettes per day';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cigPerDay = int.parse(value!);
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Cigarette type'),
                items:
                    <String>['Light', 'Regular', 'Heavy'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _cigType = newValue;
                    if (newValue == 'Light') {
                      _nicotine = 0.5;
                    } else if (newValue == 'Regular') {
                      _nicotine = 1.0;
                    } else if (newValue == 'Heavy') {
                      _nicotine = 1.5;
                    }
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveData,
                child: Text('Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
