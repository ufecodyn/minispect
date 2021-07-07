import 'dart:async';
import 'dart:convert';

import 'package:observable/observable.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

const int SPEC_CHANNELS = 288;

class MinispectDevice {
  BluetoothDevice device = BluetoothDevice();
  BluetoothConnection connection;
  var subscription;

  String _receiveBuf;
  List<int> currentData;

  MinispectDevice() {
    this.device = BluetoothDevice();
    this.connection = null;
  }

  MinispectDevice.fromDevice(BluetoothDevice _device) {
    this.device = _device;
  }

  // TODO: Add timeout
  Future<List<int>> scan(int i) async {
    connection.output.add(ascii.encode("r" + (i).toInt().toString()));
    subscription.listen((lump) {
      if (concatReceived(lump)) {
        subscription.cancel();
        return this.currentData;
      }
    });
    // var subscription;
    // subscription = connection.input.listen((lump) {
    //   if (concatReceived(lump)) {
    //     subscription.cancel();
    //     return this.currentData;
    //   }
    // });
  }

  bool concatReceived(var lump) {
    var decoded = String.fromCharCodes(lump);
    _receiveBuf += decoded;
    int find = _receiveBuf.indexOf(";");

    if (find != -1) {
      _receiveBuf = _receiveBuf.substring(0, find - 1);
      pushBuffer();
      _receiveBuf = "";
      return true;
    }

    return false;
  }

  void pushBuffer() async {
    try {
      List<int> newData = _receiveBuf.split(" ").map(int.parse).toList();
      if (newData.length != SPEC_CHANNELS)
        throw FormatException(
            "New Data length (${newData.length}) not equal to SPEC_CHANNELS ($SPEC_CHANNELS)");
      this.currentData = newData;
      _receiveBuf = "";
    } catch (e) {
      print(e.toString());
    }
  }

  void openConnection(BluetoothDevice newDevice) {
    BluetoothConnection.toAddress(newDevice.address)
        .then((newConnection) {
          this.connection = newConnection;
          this.device = newDevice;
          this.subscription = connection.input;
        })
        .timeout(const Duration(seconds: 5))
        .then((value) {});
  }

  void closeConnection() {
    connection.finish();
    connection.dispose();
  }

  String getName() {
    return device == null ? "" : device.name;
  }

  String getAddress() {
    return device == null ? "" : device.address;
  }
}
