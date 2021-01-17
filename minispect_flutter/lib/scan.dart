import 'dart:async';
import 'package:flutter/material.dart';
import 'package:minispect_flutter/main.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class ScanningPage extends StatefulWidget {
  ScanningPage({Key key}) : super(key: key);

  @override
  _ScanningPageState createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage> {
  String received;
  final _formKey = GlobalKey<FormState>();

  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    received = "";
    textController.addListener(() {
      super.setState(() {});
    });
    Consumer<RootAppStateChangeNotifier>(
      builder: (context, rootAppState, child) {
        print("init");
        rootAppState.openConnection(rootAppState.device);
        rootAppState.deviceConnection.input.listen((value) {
          String text = String.fromCharCodes(value);
          print(text);
          print('Listener Called');
          received = text;
        });
      },
    );
  }

  @override
  void dispose() {
    textController.dispose();

    super.dispose();
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
              Consumer<RootAppStateChangeNotifier>(
                builder: (context, rootAppState, child) {
                  if (rootAppState.getDeviceAddress() == "") {
                    return Text('No device selected');
                  } else if (!rootAppState.device.isConnected) {
                    return Text(
                        '${rootAppState.getDeviceName()} not connected');
                  } else
                    return Text('${rootAppState.getDeviceName()} connected');
                },
              ),
              RichText(
                text: TextSpan(
                    text: 'Received Message: ${received}',
                    style: TextStyle(
                      backgroundColor: Colors.black,
                      color: Colors.white,
                    )),
              ),
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
                            setState(() {
                              received = received + String.fromCharCodes(event);
                            });
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
