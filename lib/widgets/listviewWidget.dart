import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_manager/home.dart';

class todoListViewWidget extends StatelessWidget {
  todoListViewWidget({
    Key? key,
    required this.listofDocumentSnap,
    required this.todosRef,
    required this.editedTodoController,
    required this.schedule,
  }) : super(key: key);

  final List<DocumentSnapshot<Object?>> listofDocumentSnap;
  final CollectionReference<Object?> todosRef;
  final TextEditingController editedTodoController;
  final String schedule;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: listofDocumentSnap.length,
        itemBuilder: (context, index) {
          void deleteRecord(BuildContext context) {
            todosRef.doc(listofDocumentSnap[index].id).delete();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Record Deleted'),
            ));
          }

          void submit() {
            Map<String, dynamic> dataResult = {
              'wtodo': editedTodoController.text
            };
            Navigator.of(context).pop();
            todosRef.doc(listofDocumentSnap[index].id).update(dataResult);
          }

          Future<dynamic> openDialog(BuildContext context) =>
              showDialog<dynamic>(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text('Edit your record'),
                        content: TextField(
                          controller: editedTodoController,
                          autofocus: true,
                          decoration: InputDecoration(hintText: 'Edit it'),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                submit();
                              },
                              child: Text('Submit'))
                        ],
                      ));
          Future<dynamic> openDialogDescription(BuildContext context) =>
              showDialog<dynamic>(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text(
                            'Task : ${listofDocumentSnap[index]['wtodo']}'),
                        content: Wrap(
                          children: [
                            Column(
                              children: [
                                Text(
                                    'Date of Upload : ${listofDocumentSnap[index].id}'),
                                Text(
                                    'Priority : ${listofDocumentSnap[index]['priority']}'),
                              ],
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Ok'))
                        ],
                      ));

          final item = listofDocumentSnap[index];
          if (listofDocumentSnap[index]['schedule'] == '$schedule') {
            return Slidable(
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                dismissible: DismissiblePane(
                  onDismissed: () {},
                ),
                children: [
                  SlidableAction(
                    onPressed: openDialogDescription,
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.description,
                    label: 'Description',
                  )
                ],
              ),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                dismissible: DismissiblePane(onDismissed: () {}),
                children: [
                  SlidableAction(
                      onPressed: deleteRecord,
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.black,
                      icon: Icons.delete,
                      label: 'Delete'),
                  SlidableAction(
                      onPressed: openDialog,
                      backgroundColor: Colors.black12,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit'),
                ],
              ),
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.all(4),
                child: ListTile(
                  title: Text('${listofDocumentSnap[index]['wtodo']}',
                      style: TextStyle(color: Colors.black)),
                  leading: Text('${listofDocumentSnap[index]['priority']}',
                      style: TextStyle(color: Colors.red)),
                  selectedTileColor: Colors.green,
                ),
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        });
  }
}
