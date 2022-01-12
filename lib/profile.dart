import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userImage;
  final imagePicker = ImagePicker();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    var username = auth.currentUser!.email;
    var userID = auth.currentUser!.uid;
    var user = auth.currentUser!.metadata.creationTime;
    DocumentReference todosRef = _firestore
        .collection('UsersTodos')
        .doc(username)
        .collection('todos')
        .doc('pImage');
    DocumentReference imageRef =
        _firestore.collection("UsersTodos").doc(username);
    Future<dynamic> openDialog(BuildContext context) => showDialog<dynamic>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Are you sure?'),
              actions: [
                TextButton(
                    onPressed: () {
                      auth.sendPasswordResetEmail(
                          email: auth.currentUser!.email.toString());
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Reset password email has been sent to your email'),
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

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Profile')),
      ),
      body: Center(
        child: Column(children: [
          Center(
            child: Text(
              'Date that you create your account :  $user',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Text(
            'Your email : $username ',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: () async {
              XFile? _image = await getImage();

              userImage = await uploadImage(_image!);

              auth.currentUser!.updatePhotoURL(userImage);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Profile Photo Edited'),
              ));

              setState(() {});
            },
            child: auth.currentUser!.photoURL == null
                ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                        )),
                    width: 200,
                    height: 200,
                    child: Icon(
                      Icons.camera,
                      color: Colors.black,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                        )),
                    width: 200,
                    height: 200,
                    child: Image.network('${auth.currentUser!.photoURL}'),
                  ),
          ),
          SizedBox(
            height: 50,
          ),
          TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () {
                openDialog(context);
              },
              child: Text(
                'Reset Your Password',
                style: TextStyle(color: Colors.white, fontSize: 15),
              )),
        ]),
      ),
    );
  }

  Future<XFile?> getImage() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }
}

Future<String> uploadImage(XFile image) async {
  Reference db =
      FirebaseStorage.instance.ref("imageFolder/${getImageName(image)}");
  await db.putFile(File(image.path));
  return await db.getDownloadURL();
}

String getImageName(XFile image) {
  return image.path.split("/").last;
}
