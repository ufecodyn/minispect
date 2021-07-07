import 'package:scidart/src/numdart/numdart.dart';
import 'package:path_provider/path_provider.dart';

class Spectrum {
  List<int> data = [];
  List<double> wavelengths = [];

  double lower = 350;
  double upper = 840;

  // List to store exact value of all wavelengths. Generally not used, can be used to specify exact wavelengths a spectrophotometer reads.
  // By default, uninitialized

  Spectrum(double lowerWavelength, double upperWavelength, List<int> data) {
    double spacing = (upperWavelength - lowerWavelength) / data.length;
    this.wavelengths = List<double>.generate(
        data.length, (index) => lowerWavelength + (spacing * index));
    this.data = data;
    this.lower = lowerWavelength;
    this.upper = upperWavelength;
  }

  Spectrum.noData(
      double lowerWavelength, double upperWavelength, int numDatapoints) {
    double spacing = (upperWavelength - lowerWavelength) / data.length;
    this.wavelengths = List<double>.generate(
        data.length, (index) => lowerWavelength + (spacing * index));
    this.data = List<int>.generate(numDatapoints, (index) => 0);
    this.lower = lowerWavelength;
    this.upper = upperWavelength;
  }

  Spectrum.specifyWavelengths(List<int> data, List<double> wavelengths) {
    this.wavelengths = wavelengths;
    this.data = data;
    this.lower = wavelengths[0];
    this.upper = wavelengths[-1];
  }

  List<double> getWavelengths() {
    if (this.wavelengths == null) {
      var n = (this.upper - this.lower) / this.data.length;
      List<double> arr = List<double>.generate(
          this.data.length, (int index) => lower + index * n);
      this.wavelengths = arr;
    }
    return this.wavelengths;
  }

  List<int> getData() {
    return this.data;
  }

  int getReading(int index) {
    return this.data[index];
  }

  // To prevent redundancy,

  //void saveJson(Directory dir, Spectrum s) {}
}
