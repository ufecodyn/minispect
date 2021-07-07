import 'dart:io';
import 'dart:convert';
//import 'package:permission_handler/permission_handler.dart';

import 'package:path_provider/path_provider.dart';

class FileWriter {
  //String project;
  String object;
  Directory dir;
  File file;
  // PermissionStatus filePermissions;

  FileWriter(Directory projectDir, String object) {
    this.dir = projectDir;
    this.object = object;
    getFilePermissions();
  }

  void writeData(List<List<int>> refs, List<List<int>> data) async {
    this.file = new File("${dir.path}/$object.json");
    print("Opened file in  ${this.dir.path}");

    this.file.create();
    this.file.writeAsString(jsonEncode(dataToJson(refs, data)));
  }

  Map<String, dynamic> dataToJson(List<List<int>> refs, List<List<int>> data) {
    return {
      "reference": refs,
      "data": data,
    };
  }

  void getFilePermissions() async {
    // this.filePermissions = await Permission.storage.request();

    // if (this.filePermissions != PermissionStatus.granted) {
    //   print("File permissions not granted. ${this.filePermissions.toString()}");
    // } else {
    //Directory temp = await getExternalStorageDirectory();
    //this.dir = new Directory("${temp.path}/$project");
    this.file = new File("$dir/$object.json");
    //}
  }
}
