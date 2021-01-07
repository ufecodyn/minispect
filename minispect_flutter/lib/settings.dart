import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class SettingsPage extends StatefulWidget {
  final String title;

  SettingsPage({Key key, this.title}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  BluetoothState bts = BluetoothState.UNKNOWN;
  List<BluetoothDevice> devices;
  BluetoothConnection minispectConnection;
  String minispectAddr;

  @override
  void initState() {
    super.initState();

    FlutterBluetoothSerial.instance.getBondedDevices().then((bondedDevices) {
      setState(() {
        devices = bondedDevices;
      });
    });
  }

  void handleConnection(String address) async {
    super.setState(() {});
    BluetoothConnection.toAddress(address).then((state) {
      setState(() {
        minispectConnection = state;
        minispectAddr = address;
      });
    });
  }

  Future<void> deviceDialog(BluetoothDevice device) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Device Information'),
            content: Card(
              child: Column(
                children: [
                  Text('Name: ${device.name}'),
                  Text('Address: ${device.address}'),
                  MaterialButton(
                    child:
                        Card(child: Text("Disconnect"), color: Colors.blue[50]),
                    onPressed: () {
                      if (device.address == minispectAddr) {
                        minispectConnection.close();
                      }
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Settings ${minispectAddr}"),
        ),
        body: ListView.builder(
          itemCount: devices == null ? 1 : devices.length,
          itemBuilder: (context, index) {
            if (devices != null) {
              return Card(
                child: ListTile(
                  title: Text('${devices[index].name}'),
                  subtitle: Text('${devices[index].address}'),
                  tileColor: devices[index].address == minispectAddr
                      ? Colors.green[50]
                      : Colors.white,
                  trailing: IconButton(
                    icon: Icon(
                        devices[index].address == minispectAddr
                            ? Icons.bluetooth_audio
                            : devices[index].isConnected
                                ? Icons.bluetooth_audio
                                : Icons.bluetooth,
                        color: devices[index].address == minispectAddr
                            ? Colors.green
                            : devices[index].isConnected
                                ? Colors.blue
                                : Colors.grey),
                    onPressed: () {},
                  ),
                  onTap: () => handleConnection(devices[index].address),
                  onLongPress: () => deviceDialog(devices[index]),
                ),
              );
            } else {
              return ListTile(
                title: Text('Empty'),
              );
            }
          },
        ));
  }
}
