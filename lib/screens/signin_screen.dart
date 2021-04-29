import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

import 'chat_screen.dart';

// ignore: must_be_immutable
class SignInScreen extends StatefulWidget {
  bool isloding = false;

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController u = TextEditingController();
  var url;
  TextEditingController p = TextEditingController();
  showError(onError) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Error'),
              content: Text(onError.toString()),
            ));
  }

  var myName;
  signIn() async {
    await Firebase.initializeApp();
    // ignore: unused_local_variable
    setState(() {
      widget.isloding = true;
    });
    if (u.text.length > 4 &&
        p.text.length > 6 &&
        u.text.endsWith("@gmail.com")) {
      // ignore: unused_local_variable
      var auth = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: u.text, password: p.text)
          // ignore: return_of_invalid_type_from_catch_error
          .catchError((onError) => {showError(onError)});
      await FirebaseFirestore.instance
          .collection("users")
          .doc(auth.user.uid)
          .get()
          .then((value) async {
        myName = await value["name"];
        url = await value["imageUrl"];
      });

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => new ChatScreen(myName, url)));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isloggedin", true);
      prefs.setString("name", myName);
      prefs.setString("email", u.text);
      prefs.setString("password", p.text);
      prefs.setString("imageUrl", url);

      setState(() {
        widget.isloding = false;
      });
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('Invalid Data '),
                content: Text('this data doesn\'t help'),
              ));
      setState(() {
        widget.isloding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign In",
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
                child: new Image.asset("assets/images/signup.png",
                    width: MediaQuery.of(context).size.width - 70,
                    height: 300,
                    fit: BoxFit.cover),
              ),
            ),
            Center(
              child: Text(
                "Sign In",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Center(
                child: TextField(
                  controller: u,
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
            if (!widget.isloding)
              Container(
                width: MediaQuery.of(context).size.width - 90,
                height: 60,
                child: ElevatedButton(
                  onPressed: signIn,
                  style: ElevatedButton.styleFrom(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                  child: Text(
                    "Sign In",
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
