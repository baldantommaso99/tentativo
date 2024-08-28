import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:progetto/charts/nicotine_level.dart'; // Assicurati che il percorso sia corretto

class NicotineChart extends StatelessWidget {
  final List<charts.Series<NicotineLevel, DateTime>> seriesList;
  final bool animate;
  final int cigarettesPerDay; // Campo richiesto
  final DateTime registrationDate; // Campo richiesto

  NicotineChart(this.seriesList,
      {required this.animate,
      required this.registrationDate,
      required this.cigarettesPerDay});

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }
}

class HourlyNicotineChart extends StatelessWidget {
  final List<HourlyNicotineLevel> data;
  final bool animate;

  HourlyNicotineChart(this.data, {this.animate = false});

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      _createSeries(),
      animate: animate,
      // altre proprietà di configurazione
    );
  }

  List<charts.Series<HourlyNicotineLevel, DateTime>> _createSeries() {
    return [
      charts.Series<HourlyNicotineLevel, DateTime>(
        id: 'Nicotine',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (HourlyNicotineLevel level, _) => level.time,
        measureFn: (HourlyNicotineLevel level, _) => level.level,
        data: data,
      )
    ];
  }
}
