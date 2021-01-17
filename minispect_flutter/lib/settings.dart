import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import 'package:minispect_flutter/main.dart';

class SettingsPage extends StatefulWidget {
  final String title;

  SettingsPage({Key key, this.title}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  BluetoothState bts = BluetoothState.UNKNOWN;
  List<BluetoothDevice> devices;
  Timer bluetoothRefresh;

  @override
  void initState() {
    super.initState();

    FlutterBluetoothSerial.instance.getBondedDevices().then((bondedDevices) {
      setState(() {
        devices = bondedDevices;
      });
    });

    bluetoothRefresh = new Timer.periodic(
        Duration(seconds: 5),
        (Timer t) => FlutterBluetoothSerial.instance
                .getBondedDevices()
                .then((bondedDevices) {
              setState(() {
                devices = bondedDevices;
              });
            }));
  }

  @override
  void dispose() {
    this.bluetoothRefresh.cancel();
    super.dispose();
  }

  Future<void> deviceDialog(BluetoothDevice device) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Device Information'),
              content: Builder(
                builder: (alertDialogContext) => Card(
                  child: Column(
                    children: [
                      Text('Name: ${device.name}'),
                      Text('Address: ${device.address}'),
                      Consumer<RootAppStateChangeNotifier>(
                          builder: (context, rootAppState, child) {
                        return MaterialButton(
                          child: Card(
                              child: Text("Disconnect"),
                              color: (device.address ==
                                      rootAppState.getDeviceAddress())
                                  ? Colors.blue[50]
                                  : Colors.grey),
                          onPressed: () {
                            if (device.address ==
                                rootAppState.getDeviceAddress()) {
                              rootAppState.closeConnection();
                              // Scaffold.of(alertDialogContext).showSnackBar(
                              //     SnackBar(content: Text('Disconnecting...')));
                            }
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Settings"),
        ),
        body: Builder(
            builder: (scaffoldContext) => ListView.builder(
                  itemCount: devices == null ? 1 : devices.length,
                  itemBuilder: (context, index) {
                    if (devices != null) {
                      return Consumer<RootAppStateChangeNotifier>(
                          builder: (context, rootAppState, child) {
                        return Card(
                          child: ListTile(
                            title: Text('${devices[index].name}'),
                            subtitle: Text('${devices[index].address}'),
                            tileColor: (devices[index].address ==
                                        rootAppState.getDeviceAddress() &&
                                    devices[index].isConnected)
                                ? Colors.green[50]
                                : devices[index].isConnected
                                    ? Colors.blue[50]
                                    : (devices[index].isBonded)
                                        ? Colors.white
                                        : Colors.grey,
                            trailing: IconButton(
                              icon: Icon(
                                  devices[index].isConnected
                                      ? Icons.bluetooth_audio
                                      : Icons.bluetooth_disabled,
                                  color: (devices[index].address ==
                                              rootAppState.getDeviceAddress() &&
                                          devices[index].isConnected)
                                      ? Colors.green
                                      : devices[index].isConnected
                                          ? Colors.blue[50]
                                          : Colors.grey),
                              onPressed: () {},
                            ),
                            onTap: () {
                              Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
                                  content: Text(
                                      'Connecting to ${devices[index].name}...')));
                              rootAppState.openConnection(devices[index]);
                            },
                            onLongPress: () => deviceDialog(devices[index]),
                          ),
                        );
                      });
                    } else {
                      return ListTile(
                        title: Text('Empty'),
                      );
                    }
                  },
                )));
  }
}
