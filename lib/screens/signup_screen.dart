import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'chat_screen.dart';

// ignore: must_be_immutable
class SignUpScreen extends StatefulWidget {
  bool isloading = false;
  var imageLink;
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController e = TextEditingController();
  TextEditingController p = TextEditingController();
  TextEditingController n = TextEditingController();
  int imageQuality = 20;
  ImagePicker picker = ImagePicker();
  File hello;
  void showStorage(BuildContext context) async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, imageQuality: imageQuality);

    setState(() {
      hello = File(pickedFile.path);
    });
    Navigator.of(context).pop();
  }

  showCamera(BuildContext context) async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, imageQuality: imageQuality);

    setState(() {
      hello = File(pickedFile.path);
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_element
    hi() {
      setState(() {});
    }

    showError(onError) {
      return showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('Error'),
                content: Text(onError.toString()),
              ));
    }

    signUp() async {
      var pt = p.text;
      var et = e.text;
      var nt = n.text;
      var url;
      setState(() {
        widget.isloading = true;
      });
      if (et.trim().length > 11 &&
          et.trim().endsWith("@gmail.com") &&
          pt.length > 6 &&
          !nt.contains(" ") &&
          nt.length > 3) {
        if (hello != null) {
          await Firebase.initializeApp();

          // ignore: unused_local_variable
          var result = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: e.text, password: p.text)
              // ignore: return_of_invalid_type_from_catch_error
              .catchError((onError) => {showError(onError)});
          // ignore: unused_local_variable
          var y = FirebaseStorage.instance
              .ref()
              .child("images/${result.user.uid.toString()}");
          UploadTask uploadTask = y.putFile(hello);
          await uploadTask.whenComplete(() async {
            try {
              widget.imageLink = await y.getDownloadURL();
              url = await y.getDownloadURL();
            } catch (onError) {
              showError(onError);
            }

            print(
                "Here is Your URL ${widget.imageLink}\nHere is your fucking url $url");
          });

          // ignore: unused_local_variable
          var firestoreResult = await FirebaseFirestore.instance
              .collection("users")
              .doc(result.user.uid.toString())
              .set({
            "name": n.text,
            "username": e.text,
            "password": p.text,
            "uid": result.user.uid.toString(),
            "imageUrl": url,
          });
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => ChatScreen(n.text, url)));
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("isloggedin", true);
          prefs.setString("name", n.text);
          prefs.setString("email", e.text);
          prefs.setString("password", p.text);
          prefs.setString("imageUrl", url);

          setState(() {
            widget.isloading = false;
          });
          print(hello);
        } else {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text('Invalid Data '),
                    content: Text('You have to pick an image'),
                  ));
          setState(() {
            widget.isloading = false;
          });
        }
      } else {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text('Invalid Data '),
                  content: Text('this data doesn\'t help'),
                ));
        setState(() {
          widget.isloading = false;
        });
      }
    }

    pickerDialog() {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Chose An Source"),
                content: Container(
                  height: 150,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Row(
                        children: [
                          GestureDetector(
                              child: Icon(Icons.storage),
                              onTap: () => showStorage(context)),
                          FlatButton(
                            child: Text("Storage",
                                style: TextStyle(fontSize: 21.5)),
                            minWidth: 200,
                            onPressed: () => showStorage(context),
                          )
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          GestureDetector(
                              child: Icon(Icons.storage),
                              onTap: () => showCamera(context)),
                          FlatButton(
                            child: Text("Camera",
                                style: TextStyle(fontSize: 21.5)),
                            minWidth: 200,
                            onPressed: () => showCamera(context),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ));
    }

    userImage() {
      return Container(
        child: Column(
          children: [
            if (hello != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(160),
                child: Container(
                  width: 250,
                  height: 250,
                  child: Image.file(
                    hello,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Image.asset("assets/images/anonymous.png"),
            SizedBox(height: 30),
            Container(
                height: 50,
                width: MediaQuery.of(context).size.width - 100,
                child: ElevatedButton(
                    onPressed: pickerDialog,
                    style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0))),
                    child:
                        Text("Pick an Image", style: TextStyle(fontSize: 20))))
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                child: userImage(),
              ),
            ),
            Center(
              child: Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Center(
                child: TextField(
                  controller: n,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                        20,
                      )),
                      hintText: "Enter Your Name"),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Center(
                child: TextField(
                  controller: e,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                        20,
                      )),
                      hintText: "Enter Your username"),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Center(
                child: TextField(
                  controller: p,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                        20,
                      )),
                      hintText: "Enter Your Password"),
                ),
              ),
            ),
            SizedBox(height: 25),
            if (!widget.isloading)
              Container(
                width: MediaQuery.of(context).size.width - 100,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                  onPressed: signUp,
                  child: Text(
                    "Sign Up",
                  ),
                ),
              )
            else
              CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
