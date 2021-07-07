import 'dart:io';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minispect_flutter/scan.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
//import './objects.dart';

class ProjectsPage extends StatefulWidget {
  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  Directory objectsDir;
  bool loaded = false;
  List<FileSystemEntity> projects = [];

  TextEditingController projectNameController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    Permission.storage.request();
    getExternalStorageDirectory().then((value) {
      setState(() {
        objectsDir = value;
        objectsDir.exists().then((exists) {
          if (!exists) {
            objectsDir
                .create(recursive: true)
                .then((value) => objectsDir = value);
            loaded = true;
          }
        });
        projects = objectsDir.listSync();
      });
    });
  }

  Widget projectTile(FileSystemEntity entity) {
    return Card(
        child: ListTile(
            title: Text(entity.path.substring(entity.path.lastIndexOf('/'))),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScanningPage(entity)));
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text("Projects"),
          actions: [
            IconButton(
                onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                            title: const Text('New Project'),
                            content: TextField(
                              controller: projectNameController,
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  //Directory newProjectDir =
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => ScanningPage()) ScanningPage(
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  //Directory newProjectDir =
                                  Directory temp =
                                      await getExternalStorageDirectory();
                                  Directory newProjectDir = Directory(
                                      "${temp.path}/${projectNameController.text}");
                                  print(newProjectDir.path);
                                  if (!await newProjectDir.exists()) {
                                    newProjectDir.create();
                                  }
                                  Navigator.of(context).pop();
                                  setState(
                                      () => projects = objectsDir.listSync());
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ScanningPage(newProjectDir)));
                                },
                                child: Text('Create Project'),
                              ),
                            ])),
                icon: Icon(Icons.plus_one))
          ],
        ),
        body: Builder(
            builder: (scaffoldContext) => ListView.builder(
                  itemCount: projects == null ? 1 : projects.length,
                  itemBuilder: (context, index) {
                    if (projects == null && this.loaded) {
                      return ListTile(title: Text('No Projects'));
                    } else {
                      return projectTile(projects[index]);
                    }
                  },
                )));
  }
}
