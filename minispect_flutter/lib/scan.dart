//=2.9
import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:minispect_flutter/chart.dart';
import 'package:provider/provider.dart';
//import 'package:minispect_flutter/chart.dart';
import 'package:minispect_flutter/main.dart';
import 'package:minispect_flutter/file_writing.dart';
import 'package:minispect_flutter/equations.dart';

class ScanningPage extends StatefulWidget {
  final Directory scanDir;
  ScanningPage(this.scanDir, {Key key}) : super(key: key);

  @override
  _ScanningPageState createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage> {
  // String project = "";
  String objectName =
      "Untitled_${DateTime.now().toUtc().millisecondsSinceEpoch}";
  //Directory scanDir = new Directory("/");

  String currScanType = "data";
  String receiveBuf = "";
  double integration = 8;
  List<List<int>> refs = [];
  List<List<int>> data = []; //List<int>.filled(288, 0, growable: false);
  final objectNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    objectNameController.dispose();
  }

  bool concatReceived(var lump) {
    var decoded = String.fromCharCodes(lump);
    this.receiveBuf += decoded;
    int find = this.receiveBuf.indexOf(";");
    if (find != -1) {
      // String temp =
      //     find < receiveBuf.length - 1 ? receiveBuf.substring(find + 1) : "";
      receiveBuf = receiveBuf.substring(0, find - 1);
      pushBuffer();
      //setState(() => this.receiveBuf = temp); // temp;
      this.receiveBuf = "";
      return true;
    }
    return false;
  }

  void pushBuffer() {
    try {
      List<int> newData = this.receiveBuf.split(" ").map(int.parse).toList();
      if (newData.length != 288) {
        print(
            "ERROR:  ${newData.length}, ${data.length}, ${data[data.length - 1].length}");
        print(receiveBuf);
      }
      setState(() {
        switch (this.currScanType) {
          case "data":
            this.data.add(newData);
            break;
          case "ref":
            this.refs.add(newData);
            break;
          default:
            this.data.add(newData);
            break;
        }
      });
      this.receiveBuf = "";
    } catch (e) {
      print(e.toString());
    }
  }

  void saveScan() {
    FileWriter f = new FileWriter(widget.scanDir, this.objectName);
    f.writeData(this.refs, this.data);
  }

  void deleteLastScan() {
    if (this.data.isNotEmpty)
      setState(() => this.data.removeAt(this.data.length - 1));
  }

  void deleteScanAt(int index) {
    this.data.removeAt(index);
  }

  void renameObjectDialogBox(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Object Name'),
        content: TextField(
          controller: objectNameController,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => this.objectName = objectNameController.text);
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          leading: Icon(Icons.camera),
          title: new Text("Scan"),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: Text("Object: $objectName",
                  style: TextStyle(color: Colors.white))),
          actions: [
            IconButton(
                onPressed: () {
                  deleteLastScan();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Deleted Last Scan"),
                    duration: Duration(seconds: 1),
                  ));
                },
                icon: Icon(Icons.backspace_rounded)),
            IconButton(
                onPressed: () {
                  setState(() {
                    this.data = [];
                    this.refs = [];
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Deleted all object data"),
                    duration: Duration(seconds: 1),
                  ));
                },
                icon: Icon(Icons.delete)),
            IconButton(
                onPressed: () {
                  saveScan();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Saved"),
                    duration: Duration(seconds: 1),
                  ));
                },
                icon: Icon(Icons.save)),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => renameObjectDialogBox(context),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Builder(
          builder: (scaffoldContext) => Column(
            children: <Widget>[
              Consumer<RootAppStateChangeNotifier>(
                builder: (context, rootAppState, child) {
                  return Column(children: <Widget>[
                    Container(
                      height: 400,
                      // child: this.data.length > 0
                      //     ? SimpleSpectrumChart.withData(
                      //         this.data[this.data.length - 1])
                      //     : Text('No scans'),
                      child: ListView(
                        children: this
                            .data
                            .map((value) => Container(
                                  height: 300,
                                  child: Center(child: Text(value.toString())),
                                ))
                            .toList(),
                      ),
                    ),
                    Slider(
                      value: integration,
                      min: 0,
                      max: 50,
                      divisions: 25,
                      onChanged: (double value) {
                        setState(() {
                          integration = value;
                        });
                      },
                      label: 'Integration Time: $integration ms',
                    ),

                    // Send message button
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                            SnackBar(content: Text('Scanning...')));
                        rootAppState.deviceConnection.output.add(ascii
                            .encode('r' + (integration).toInt().toString()));
                        setState(() {
                          this.currScanType = "data";
                        });
                        // StreamSubscription sub;
                        // sub =
                        //     rootAppState.deviceConnection.input.listen((event) {
                        //   bool done = concatReceived(event);
                        //   if (done) {
                        //     //sub.cancel();
                        //     print('done receiving data');
                        //   }
                        // });
                      },
                      child: Text('Send'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Collecting Reference $integration...')));
                        rootAppState.deviceConnection.output.add(ascii
                            .encode('r' + (integration).toInt().toString()));
                        setState(() {
                          this.currScanType = "ref";
                        });
                        // StreamSubscription sub;
                        // sub =
                        //     rootAppState.deviceConnection.input.listen((event) {
                        //   bool done = concatReceived(event);
                        //   if (done) {
                        //     print('done receiving reference');
                        //   }
                        // });
                      },
                      child: Text('Reference Scan'),
                    ),
                    Text('${refs.length} Reference Scans taken'),
                  ]);
                },
              )
            ],
          ),
        )));
  }
}
