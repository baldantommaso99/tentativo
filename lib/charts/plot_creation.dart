import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

// Definisci la classe NicotineLevel
class NicotineLevel {
  final DateTime date;
  final double level;

  NicotineLevel({required this.date, required this.level});
}

class NicotineChart extends StatelessWidget {
  final List<charts.Series<NicotineLevel, DateTime>> seriesList;
  final bool animate;
  final DateTime registrationDate;
  final int cigarettesPerDay;

  NicotineChart(
    this.seriesList, {
    this.animate = false,
    required this.registrationDate,
    required this.cigarettesPerDay,
  });

  @override
  Widget build(BuildContext context) {
    // Calcola la data di inizio e di fine basate sulla data di registrazione e sul numero di sigarette
    //DateTime fixedStartDate = registrationDate;
    //DateTime fixedEndDate = registrationDate.add(Duration(days: cigarettesPerDay * 7 + 1));

    DateTime fixedStartDate =
        registrationDate.subtract(Duration(days: 1)); // Un giorno prima
    DateTime fixedEndDate = registrationDate
        .add(Duration(days: cigarettesPerDay * 7 + 2)); // Un giorno dopo

    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      domainAxis: charts.DateTimeAxisSpec(
        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
          day: charts.TimeFormatterSpec(
            format: 'dd', // Formatta i giorni sull'asse X
            transitionFormat: 'dd MMM',
          ),
        ),
        tickProviderSpec: charts.DayTickProviderSpec(
            increments: [1]), // Incrementi giorno per giorno
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
            color: charts.MaterialPalette.black,
          ),
          lineStyle: charts.LineStyleSpec(
            color: charts.MaterialPalette.black,
          ),
          axisLineStyle: charts.LineStyleSpec(
            color: charts.MaterialPalette.black,
          ),
        ),
        // Imposta l'intervallo dell'asse X al periodo di registrazione
        viewport: charts.DateTimeExtents(
          start: fixedStartDate,
          end: fixedEndDate,
        ),
      ),
      defaultRenderer: charts.BarRendererConfig<DateTime>(
        groupingType:
            charts.BarGroupingType.grouped, // Barre raggruppate per ogni giorno
        cornerStrategy: const charts.ConstCornerStrategy(20),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec:
            charts.BasicNumericTickProviderSpec(desiredTickCount: 10),
      ),
    );
  }

  // Crea dati di esempio
  static List<charts.Series<NicotineLevel, DateTime>> createSampleData(
      List<NicotineLevel> data) {
    return [
      charts.Series<NicotineLevel, DateTime>(
        id: 'Nicotine Level',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (NicotineLevel levels, _) => DateTime(levels.date.year,
            levels.date.month, levels.date.day), // Ignora le ore
        measureFn: (NicotineLevel levels, _) => levels.level,
        data: data,
      )
    ];
  }
}

class HourlyNicotineLevel {
  final DateTime time;
  final double level;

  HourlyNicotineLevel({required this.time, required this.level});
}

class HourlyNicotineChart extends StatelessWidget {
  final List<charts.Series<HourlyNicotineLevel, DateTime>> seriesList;
  final bool animate;

  HourlyNicotineChart(this.seriesList, {this.animate = false});

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      domainAxis: charts.DateTimeAxisSpec(
        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
          hour: charts.TimeFormatterSpec(
            format: 'HH', // Visualizza solo le ore sull'asse X
            transitionFormat: 'HH',
          ),
        ),
        tickProviderSpec: charts.StaticDateTimeTickProviderSpec(
          List.generate(12, (i) {
            return charts.TickSpec<DateTime>(
              DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day, i * 2),
              label: (i * 2).toString().padLeft(2, '0'),
            );
          }),
        ),
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
            color: charts.MaterialPalette.black,
          ),
          lineStyle: charts.LineStyleSpec(
            color: charts.MaterialPalette.black,
          ),
          axisLineStyle: charts.LineStyleSpec(
            color: charts.MaterialPalette.black,
          ),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec:
            charts.BasicNumericTickProviderSpec(desiredTickCount: 10),
      ),
    );
  }

  static List<charts.Series<HourlyNicotineLevel, DateTime>> createSampleData(
      List<HourlyNicotineLevel> data) {
    return [
      charts.Series<HourlyNicotineLevel, DateTime>(
        id: 'Hourly Nicotine Level',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (HourlyNicotineLevel levels, _) => levels.time,
        measureFn: (HourlyNicotineLevel levels, _) => levels.level,
        data: data,
      )
    ];
  }
}
