// @dart=2.9
import 'package:scidart/scidart.dart';

//import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ChlModel {
  final _modelFile = 'chl-latest.tflite';

  Interpreter _intepreter;

  ChlModel() {
    _loadModel();
  }

  void _loadModel() async {
    _intepreter = await Interpreter.fromAsset(_modelFile);
    print('Interpreter loaded successfully');
  }

  double predict(List<int> data, List<int> ref) {
    double output;
    List<List<double>> input = [extendedPolynomialMatrix(calibrate(data, ref))];
    //_intepreter.run(input, output);
    return output;
  }
}

List<double> calibrate(List<int> data, List<int> ref) {
  List<double> calibrated = [];
  for (int i = 0; i < data.length; i++) {
    calibrated.add((data[i]).toDouble() / (ref[i] + 1).toDouble());
  }
  return calibrated;
}

List<double> extendedPolynomialMatrix(List<double> data) {
  List<double> poly = data;
  poly.forEach((element) {
    element = element * element;
  });
  List<double> epm = new List.from(data)..addAll(poly);
  return epm;
}

double gitelson(List<int> data) {
  if (data.length == 288) {
    return data[10] / data[5];
  }
  return 0;
}
