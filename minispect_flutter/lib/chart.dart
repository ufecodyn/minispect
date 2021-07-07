import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:minispect_flutter/spectrum.dart';

class WavelengthReading {
  double wavelength;
  int intensity;

  WavelengthReading(double wavelength, int intensity) {
    this.wavelength = wavelength;
    this.intensity = intensity;
  }

  static List<WavelengthReading> fromSpectrum(Spectrum s) {
    List<WavelengthReading> out;
    List<double> wavelengths = s.getWavelengths();
    List<int> intensities = s.getData();
    for (int i = 0; i < wavelengths.length; i++) {
      out.add(new WavelengthReading(wavelengths[i], intensities[i]));
    }
    return out;
  }
}

class SpectrumChart extends StatefulWidget {
  @override
  _SpectrumChartState createState() => _SpectrumChartState();
}

class _SpectrumChartState extends State<SpectrumChart> {
  List<Spectrum> scans;
  List<charts.Series> seriesList;
  bool animate;

  @override
  void initState() {
    super.initState();
    animate = false;
  }

  void addReading(List<int> _data) {
    Spectrum newReading = Spectrum(350, 840, _data);
    scans.add(newReading);
  }

  void addReadingFromSpectrum(Spectrum _s) {
    scans.add(_s);
  }

  @override
  Widget build(BuildContext context) {
    return new charts.NumericComboChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.LineRendererConfig(),
      customSeriesRenderers: [
        new charts.PointRendererConfig(customRendererId: 'customPoint')
      ],
    );
  }

  List<charts.Series<WavelengthReading, double>> generateSeries(
      Spectrum s, int counter) {
    List<WavelengthReading> wavelengths = WavelengthReading.fromSpectrum(s);
    return [
      charts.Series<WavelengthReading, double>(
        id: 'Reading $counter',
        domainFn: (WavelengthReading reading, _) => reading.wavelength,
        measureFn: (WavelengthReading reading, _) => reading.intensity,
        data: wavelengths,
      )
    ];
  }

  // List<charts.Series<WavelengthReading, double>> RandomData(
  //     Spectrum s, int counter) {
  //   List<WavelengthReading> wavelengths = WavelengthReading.fromSpectrum(s);
  //   return new charts.Series<WavelengthReading, double>(
  //     id: 'Reading $counter',
  //     domainFn: (WavelengthReading reading, _) => reading.wavelength,
  //     measureFn: (WavelengthReading reading, _) => reading.intensity,
  //     data: wavelengths,
  //   );
  // }
}

class SimpleSpectrumChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleSpectrumChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  // factory SimpleSpectrumChart.withSampleData() {
  //   return new SimpleSpectrumChart(
  //     _createSampleData(),
  //     // Disable animations for image tests.
  //     animate: false,
  //   );
  // }

  factory SimpleSpectrumChart.withData(List<int> data) {
    return new SimpleSpectrumChart(_seriesFromData(data), animate: false);
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList, animate: animate);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSpectra, double>> _seriesFromData(
      List<int> data) {
    List<LinearSpectra> d;

    double counter = 0;
    for (int scan in data) {
      d.add(new LinearSpectra(counter, scan));
      counter += 1;
    }

    return [
      new charts.Series<LinearSpectra, double>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSpectra spect, _) => spect.wavelength,
        measureFn: (LinearSpectra spect, _) => spect.intensity,
        data: d,
      )
    ];
  }
}

/// Sample linear data type.
class LinearSpectra {
  final double wavelength;
  final int intensity;

  LinearSpectra(this.wavelength, this.intensity);
}

class SimpleLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleLineChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory SimpleLineChart.withSampleData() {
    return new SimpleLineChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(seriesList, animate: animate);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
