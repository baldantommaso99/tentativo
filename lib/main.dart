import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:progetto/screens/cigarette_counter.dart';
import 'package:progetto/screens/homepage.dart'; // Cambiato da ProfilePage a HomePage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CigaretteCounter()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(), // Imposta HomePage come pagina iniziale
      ),
    );
  }
}
