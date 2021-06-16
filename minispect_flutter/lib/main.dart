// @dart=2.9

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import './settings.dart';
import './scan.dart';
import './projects.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class RootAppStateChangeNotifier extends ChangeNotifier {
  BluetoothConnection deviceConnection;
  BluetoothDevice device;
  StreamSubscription deviceSubscription;

  void openConnection(BluetoothDevice newDevice) {
    BluetoothConnection.toAddress(newDevice.address).then((newConnection) {
      this.deviceConnection = newConnection;
    }).timeout(const Duration(seconds: 5));
    this.device = newDevice;
    notifyListeners();
  }

  void closeConnection() {
    deviceConnection.finish();
    deviceConnection.close();
    deviceConnection.dispose();
    notifyListeners();
  }

  String getDeviceAddress() {
    return device == null ? "" : device.address;
  }

  String getDeviceName() {
    return device == null ? "" : device.name;
  }
}

void checkModelDownloaded(String filename) async {
  getExternalStorageDirectory().then((value) {
    Directory models_dir = Directory('${value.path}/models/');
    models_dir.create();

    // try {
    //   if (models_dir.existsSync()) {
    //   } else {
    //     models_dir.create();
    //   }
    // } catch (err) {
    // }
    FlutterDownloader.registerCallback((id, status, progress) {
      print('callback');
    });
    try {
      // if (File('${models_dir.path}$filename').existsSync()) {
      // } else {
      final taskId = FlutterDownloader.enqueue(
        url: "http://minispect.vmpuri.com/$filename",
        savedDir: "${models_dir.path}",
        showNotification:
            false, // show download progress in status bar (for Android)
        openFileFromNotification:
            false, // click on notification to open downloaded file (for Android)
      );
    } catch (e) {
      print(e);
    }
    // }
  });
}

void main() async {
  await FlutterDownloader.initialize();
  //FlutterDownloader.registerCallback((id, status, progress) {});

  runApp(ChangeNotifierProvider(
    create: (context) => RootAppStateChangeNotifier(),
    child: MinispectApp(),
  ));
}

class MinispectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minispect',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Main Screen'),
    );
  }
}

class _HomePageState extends State<HomePage> {
  BluetoothState btstate = BluetoothState.UNKNOWN;

  @override
  void initState() {
    super.initState();

    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        btstate = state;
      });
    });

    Future.doWhile(() async {
      if (await FlutterBluetoothSerial.instance.isEnabled) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {});
      });
    });

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        btstate = state;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer<RootAppStateChangeNotifier>(
                builder: (context, rootAppState, child) {
              return Text((rootAppState.device == null ||
                      rootAppState.device.isConnected)
                  ? "Not Connected to any device"
                  : "Currently connected to ${rootAppState.getDeviceName()}\n${rootAppState.getDeviceAddress()}");
            }),
            MaterialButton(
              color: Colors.green,
              child: Text("Settings"),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new SettingsPage()));
              },
            ),
            MaterialButton(
              color: Colors.green,
              child: Text("Projects"),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ProjectsPage()));
              },
            ),
            MaterialButton(
              color: Colors.green,
              child: Text("Update Model"),
              onPressed: () {
                checkModelDownloaded('chl-latest.tflite');
              },
            ),
          ],
        ),
      ),
    );
  }
}
