import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/login_auth/login_page.dart';
import 'package:task_manager/main.dart';
import 'package:task_manager/profile.dart';
import 'package:task_manager/services/auth_services.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:math';

import 'widgets/listviewWidget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var data = Get.arguments;
  TextEditingController _todoController = TextEditingController();
  late TextEditingController editedTodoController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int todoNum = 0;
  List<bool> _selections = List.generate(3, (_) => false);
  List<bool> _selectionsX = List.generate(3, (_) => false);
  var priority = 'HIGH';
  var schedule = 'Daily';
  int _selectedIndex = 0;
  bool _value = false;
  var dropdownItems = [
    'Select Sort Type',
    'Date(Old to New)',
    'Task Name',
    'Priority'
  ];
  String dropdownvalue = 'Select Sort Type';

  @override
  Widget build(BuildContext context) {
    var username = auth.currentUser!.email;
    var dateTime = DateTime.now();
    CollectionReference todosRef =
        _firestore.collection('UsersTodos').doc(username).collection('todos');
    var stream = todosRef.snapshots();
    if (dropdownvalue == 'Priority') {
      stream = todosRef.orderBy('priority', descending: false).snapshots();
    }
    if (dropdownvalue == 'Date(Old to New)') {
      stream = todosRef.orderBy('dateTime', descending: true).snapshots();
    }
    if (dropdownvalue == 'Task Name') {
      stream = todosRef.orderBy('wtodo', descending: false).snapshots();
    }

    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(child: Text('$username')),
          Container(
            child: GestureDetector(
              child: Icon(Icons.input),
              onTap: () {
                openDialogX(context);
              },
            ),
          ),
        ],
      )),
      body: SafeArea(
          child: Column(
        children: [
          scheduleButtons(),
          Card(
            margin: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _todoController,
                  ),
                ),
                priorityButtons(),
                IconButton(
                    onPressed: () {
                      var todos = _todoController.text;
                      var dateTime = DateTime.now();

                      _firestore
                          .collection("UsersTodos")
                          .doc(username)
                          .collection("todos")
                          .doc("${dateTime}")
                          .set({
                        'wtodo': todos,
                        'priority': priority,
                        'schedule': schedule,
                        'dateTime': dateTime,
                      });
                    },
                    icon: Icon(Icons.add)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Center(
              child: Row(
                children: [
                  Text(
                    'Sort by :  ',
                    style: TextStyle(fontSize: 17),
                  ),
                  Container(
                    child: DropdownButton(
                      value: dropdownvalue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: dropdownItems.map((String dropdownItems) {
                        return DropdownMenuItem(
                          value: dropdownItems,
                          child: Text(dropdownItems),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: stream,
              builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                if (!asyncSnapshot.hasData) {
                  return CircularProgressIndicator();
                }

                List<DocumentSnapshot> listofDocumentSnap =
                    asyncSnapshot.data.docs;

                return todoListViewWidget(
                  listofDocumentSnap: listofDocumentSnap,
                  todosRef: todosRef,
                  editedTodoController: editedTodoController,
                  schedule: schedule,
                );
              },
            ),
          ),
        ],
      )),
    );
  }

  ToggleButtons priorityButtons() {
    return ToggleButtons(
      children: [
        Text(
          'High',
          style: TextStyle(color: Colors.red),
        ),
        Text(
          'Medium',
          style: TextStyle(color: Colors.blue),
        ),
        Text('Low'),
      ],
      isSelected: _selections,
      onPressed: (int index) {
        setState(() {
          print(_selections);
          if (index == 0) {
            _selections[0] = !_selections[0];
            _selections[1] = false;
            _selections[2] = false;
            priority = 'HIGH';
          } else if (index == 1) {
            _selections[1] = !_selections[1];
            _selections[0] = false;
            _selections[2] = false;
            priority = 'MEDIUM';
          } else if (index == 2) {
            _selections[2] = !_selections[2];
            _selections[1] = false;
            _selections[0] = false;
            priority = 'LOW';
          }
          print(priority);
        });
      },
    );
  }

  ToggleButtons scheduleButtons() {
    return ToggleButtons(
      children: [
        Container(
            width: (MediaQuery.of(context).size.width - 36) / 3,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Icon(
                  Icons.alarm,
                  size: 16.0,
                  color: Colors.red,
                ),
                new SizedBox(
                  width: 4.0,
                ),
                new Text(
                  "Daily",
                  style: TextStyle(color: Colors.red),
                )
              ],
            )),
        Container(
            width: (MediaQuery.of(context).size.width - 36) / 3,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Icon(
                  Icons.date_range,
                  size: 16.0,
                  color: Colors.yellow[800],
                ),
                new SizedBox(
                  width: 4.0,
                ),
                new Text("Weekly", style: TextStyle(color: Colors.yellow[800]))
              ],
            )),
        Container(
            width: (MediaQuery.of(context).size.width - 36) / 3,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Icon(
                  Icons.update,
                  size: 16.0,
                  color: Colors.blue,
                ),
                new SizedBox(
                  width: 4.0,
                ),
                new Text("Monthly", style: TextStyle(color: Colors.blue))
              ],
            )),
      ],
      isSelected: _selectionsX,
      onPressed: (int index) {
        setState(() {
          if (index == 0) {
            _selectionsX[0] = !_selectionsX[0];
            _selectionsX[1] = false;
            _selectionsX[2] = false;
            schedule = 'Daily';
          } else if (index == 1) {
            _selectionsX[1] = !_selectionsX[1];
            _selectionsX[0] = false;
            _selectionsX[2] = false;
            schedule = 'Weekly';
          } else if (index == 2) {
            _selectionsX[2] = !_selectionsX[2];
            _selectionsX[1] = false;
            _selectionsX[0] = false;
            schedule = 'Monthly';
          }
        });
      },
    );
  }

  Future<dynamic> openDialogX(BuildContext context) => showDialog<dynamic>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Are you sure to logout?'),
            actions: [
              TextButton(
                  onPressed: () {
                    AuthController.instance.logOut();

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Logged Out'),
                    ));
                    Navigator.pop(context);
                  },
                  child: Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('No')),
            ],
          ));
}

void doNothing(BuildContext context) {}
