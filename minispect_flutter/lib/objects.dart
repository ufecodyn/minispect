// import 'dart:io';
// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';

// class ObjectsPage extends StatefulWidget {
//   @override
//   _ObjectsPageState createState(String ) => _ObjectsPageState();
// }

// class _ObjectsPageState extends State<ObjectsPage> {
//   Directory projectsDir;
//   bool loaded = false;
//   List<FileSystemEntity> projects = [];

//   @override
//   void initState() {
//     super.initState();
//     Directory appDocDir;
//     getApplicationDocumentsDirectory().then((value) {
//       setState(() {
//         appDocDir = value;
//         projectsDir = Directory('${appDocDir.path}/projects');
//         projectsDir.exists().then((exists) {
//           if (!exists) {
//             projectsDir
//                 .create(recursive: true)
//                 .then((value) => projectsDir = value);
//             loaded = true;
//           }
//         });
//         projects = projectsDir.listSync();
//       });
//     });
//   }

//   Widget projectTile(FileSystemEntity entity) {
//     return Card(
//         child: ListTile(
//       title: Text(entity.path),
//       onTap: () {
//         Navigator.push(context, MaterialPageRoute(builder: (context) =>)))
//         // Navigator.push scan
//       }
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: new AppBar(title: Text("Objects"),
//         actions: [
//           IconButton(onPressed: () => showDialog<String>(
//             context: context,
//             builder: (BuildContext context) => AlertDialog(
//               title: const Text('New Project'),
//               content: TextField(controller: ,)
//             )
//           ) , icon: Icon(Icons.plus_one))
//         ],
//         ),
//         body: Builder(
//             builder: (scaffoldContext) => ListView.builder(
//                   itemCount: projects == null ? 1 : projects.length,
//                   itemBuilder: (context, index) {
//                     if (projects == null && this.loaded) {
//                       return ListTile(title: Text('No Projects'));
//                     } else {
//                       return projectTile(projects[index]);
//                     }
//                   },
//                 )));
//   }
// }
