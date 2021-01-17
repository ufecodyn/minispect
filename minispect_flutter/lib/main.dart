import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import './settings.dart';
import './scan.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class RootAppStateChangeNotifier extends ChangeNotifier {
  BluetoothConnection deviceConnection;
  BluetoothDevice device;

  void openConnection(BluetoothDevice newDevice) {
    BluetoothConnection.toAddress(newDevice.address).then((newConnection) {
      deviceConnection = newConnection;
      device = newDevice;
    });
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

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => RootAppStateChangeNotifier(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Main Screen'),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
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

    Consumer<RootAppStateChangeNotifier>(
      builder: (context, rootAppState, child) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
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
              color: Colors.blue[300],
              child: Text("Go To Settings"),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new SettingsPage()));
              },
            ),
            MaterialButton(
              color: Colors.blue[300],
              child: Text("Scan"),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ScanningPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
