//=2.9
import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:minispect_flutter/chart.dart';
import 'package:provider/provider.dart';
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
  double integration = 2;
  List<List<int>> refs = [];
  List<List<int>> data = []; //List<int>.filled(288, 0, growable: false);
  List<double> chlPreds = [];
  final objectNameController = TextEditingController();

  ChlModel model = ChlModel();

  double predictedChl = 1.0037;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    objectNameController.dispose();
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
                      height: 350,
                      child: ListView(
                        children: this
                            .data
                            .asMap()
                            .entries
                            .map((entry) => Container(
                                  height: 300,
                                  child: Center(
                                      child: Text(
                                          "Estimated Chl: ${model.predict(entry.value, (this.refs.isNotEmpty) ? this.refs[this.refs.length - 1] : List<int>.filled(288, 1))} g/m^2 ${entry.value.toString()}")),
                                ))
                            .toList(),
                      ),
                    ),
                    Slider(
                      value: integration,
                      min: 0,
                      max: 5,
                      divisions: 5,
                      onChanged: (double value) {
                        setState(() {
                          integration = value;
                        });
                      },
                      label: 'Integration Time: $integration ms',
                    ),

                    // Send message button
                    ElevatedButton(
                      onPressed: () async {
                        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                            SnackBar(
                                content: Text('Scanning...'),
                                duration: Duration(seconds: 1)));
                        //rootAppState.deviceConnection.output.add(ascii
                        //    .encode('r' + (integration).toInt().toString()));
                        List<int> newData = await rootAppState.minispectDevice
                            .scan(integration.toInt());
                        setState(() {
                          this.data.add(newData);
                          print(refs[0]);
                          //print(model.predict(newData, refs[refs.length - 1]));
                          // this.chlPreds.add(
                          //     model.predict(newData, refs[refs.length - 1]));
                        });
                      },
                      child: Text('Send'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        ScaffoldMessenger.of(scaffoldContext)
                            .showSnackBar(SnackBar(
                          content: Text('Scanning...'),
                          duration: Duration(seconds: 1),
                        ));
                        //rootAppState.deviceConnection.output.add(ascii
                        //    .encode('r' + (integration).toInt().toString()));
                        List<int> newData = await rootAppState.minispectDevice
                            .scan(integration.toInt());
                        setState(() {
                          print("Refs ${refs.length}");
                          this.refs.add(newData);
                        });
                      },
                      child: Text('Reference Scan'),
                    ),
                  ]);
                },
              )
            ],
          ),
        )));
  }
}
