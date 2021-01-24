import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:minispect_flutter/main.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ScanningPage extends StatefulWidget {
  ScanningPage({Key key}) : super(key: key);

  @override
  _ScanningPageState createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage> {
  String receiveBuf;
  List<int> data;
  final _formKey = GlobalKey<FormState>();

  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    receiveBuf = "";
    textController.addListener(() {
      super.setState(() {});
    });
  }

  @override
  void dispose() {
    textController.dispose();

    super.dispose();
  }

  void concatReceived(var lump) {
    var decoded = String.fromCharCodes(lump);
    if (decoded.indexOf('\n') == -1) {
      receiveBuf = receiveBuf + decoded;
    } else {
      receiveBuf = receiveBuf + decoded;
      data.clear();
      receiveBuf.split(" ").forEach((element) {
        data.add(int.parse(element));
      });
      receiveBuf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Scan"),
        ),
        body: SingleChildScrollView(
            child: Builder(
          builder: (scaffoldContext) => Column(
            children: <Widget>[
              // Consumer<RootAppStateChangeNotifier>(
              //   builder: (context, rootAppState, child) {
              //     if (rootAppState.getDeviceAddress() == "") {
              //       return Text('No device selected');
              //     } else if (!rootAppState.device.isConnected) {
              //       return Text(
              //           '${rootAppState.getDeviceName()} not connected');
              //     } else
              //       return Text('${rootAppState.getDeviceName()} connected');
              //   },
              // ),
              RichText(
                text: TextSpan(
                    text: 'Received Message: ${receiveBuf}',
                    style: TextStyle(
                      backgroundColor: Colors.black,
                      color: Colors.white,
                    )),
              ),
              //charts.LineChart(charts.Series(data: data), animate: animate),
              Consumer<RootAppStateChangeNotifier>(
                builder: (context, rootAppState, child) {
                  return Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      TextField(
                        controller: textController,
                        autocorrect: false,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Scaffold.of(scaffoldContext).showSnackBar(
                              SnackBar(content: Text('Processing Data')));
                          rootAppState.deviceConnection.output
                              .add(ascii.encode(textController.text));
                          rootAppState.deviceConnection.input.listen((event) {
                            setState(() => concatReceived(event));
                          }).onDone(() {
                            print('Done Receiving Data');
                          });
                        },
                        child: Text('Submit'),
                      )
                    ]),
                  );
                },
              )
            ],
          ),
        )));
  }
}
