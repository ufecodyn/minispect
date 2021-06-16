//@dart = 2.9
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import 'package:minispect_flutter/main.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

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

  void downloadModel() async {}

  Widget deviceListTile(BluetoothDevice device, BuildContext scaffoldContext) {
    return Consumer<RootAppStateChangeNotifier>(
      builder: (context, rootAppState, child) {
        return Card(
          child: ListTile(
            title: Text('${device.name}'),
            subtitle: Text('${device.address}'),
            tileColor: (device.address == rootAppState.getDeviceAddress() &&
                    device.isConnected)
                ? Colors.green[50]
                : device.isConnected
                    ? Colors.blue[50]
                    : (device.isBonded)
                        ? Colors.white
                        : Colors.grey,
            trailing: Icon(
                device.isConnected
                    ? Icons.bluetooth_audio
                    : Icons.bluetooth_disabled,
                color: (device.address == rootAppState.getDeviceAddress() &&
                        device.isConnected)
                    ? Colors.green
                    : device.isConnected
                        ? Colors.blue
                        : Colors.grey),
            onTap: () {
              ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                  SnackBar(content: Text('Connecting to ${device.name}...')));
              rootAppState.openConnection(device);
            },
            onLongPress: () => deviceDialog(device),
          ),
        );
      },
    );
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
      appBar: new AppBar(title: new Text("Settings")),
      body: Column(children: [
        ListTile(
          title: Text('Get Latest Model'),
          trailing: IconButton(
            icon: Icon(Icons.download),
            onPressed: () => downloadModel(),
          ),
        ),
        Builder(
            builder: (scaffoldContext) => ListView.builder(
                  itemCount: devices == null ? 1 : devices.length,
                  itemBuilder: (context, index) {
                    if (devices != null) {
                      return Consumer<RootAppStateChangeNotifier>(
                          builder: (context, rootAppState, child) {
                        return deviceListTile(devices[index], scaffoldContext);
                      });
                    } else {
                      return ListTile(
                        title: Text('Empty'),
                      );
                    }
                  },
                ))
      ]),
    );
  }
}
