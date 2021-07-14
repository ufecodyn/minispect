import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:observable/observable.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

const int SPEC_CHANNELS = 288;

class MinispectDevice {
  BluetoothDevice device = BluetoothDevice();
  BluetoothConnection connection;
  Stream<Uint8List> _deviceOutputStream;
  StreamSubscription<Uint8List> _deviceOutputListener;

  String _receiveBuf = "";
  List<int> currentData;

  MinispectDevice() {
    this.device = BluetoothDevice();
    this.connection = null;
    this._receiveBuf = "";
  }

  MinispectDevice.fromDevice(BluetoothDevice _device) {
    this.device = _device;
  }

  // TODO: Add timeout
  Future<List<int>> scan(int i) async {
    print('scan');
    connection.output.add(ascii.encode("r" + i.toString()));
    Completer<List<int>> c = new Completer<List<int>>();
    _deviceOutputListener = _deviceOutputStream.listen((lump) {
      if (concatReceived(lump)) {
        c.complete(this.currentData);
      }
    });
    return c.future;
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
    this._receiveBuf += decoded;
    int find = _receiveBuf.indexOf(";");

    if (find != -1) {
      this._receiveBuf = this._receiveBuf.substring(0, find - 1);
      pushBuffer();
      this._receiveBuf = "";
      this._deviceOutputListener.pause();
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
      this._receiveBuf = "";
    } catch (e) {
      print(e.toString());
    }
  }

  bool openConnection(BluetoothDevice newDevice) {
    BluetoothConnection.toAddress(newDevice.address).then((newConnection) {
      this.connection = newConnection;
      this.device = newDevice;
      this._deviceOutputStream = connection.input.asBroadcastStream();
      return true;
    }).timeout(const Duration(seconds: 5), onTimeout: () {
      return false;
    }).onError((error, stackTrace) {
      return false;
    });
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
