// ignore: unused_import
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import "../widgets/message.dart";
import 'start_screen.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  final name;
  var uid;
  final imageLink;
  ChatScreen(this.name, this.imageLink);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController m = TextEditingController();
    // ignore: unused_element
    showError(onError) {
      return showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('Error'),
                content: Text(onError.toString()),
              ));
    }

    logOut() async {
      FirebaseAuth.instance.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isloggedin", false);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => StartScreen()));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Chats"),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            PopupMenuButton(
                itemBuilder: (BuildContext bc) => [
                      PopupMenuItem(
                          child: GestureDetector(
                        child: Container(
                            width: double.infinity, child: Text("Log Out")),
                        onTap: logOut,
                      )),
                    ],
                onSelected: (route) {
                  print("hello world");
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 132,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .orderBy('createdTime', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return Text('Loading');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return new Text('Loading...');
                      default:
                        return new ListView(
                          reverse: true,
                          children: snapshot.data.docs
                              .map((DocumentSnapshot document) {
                            return new ChatMessage(
                              document["name"],
                              document["message"],
                              document["uid"],
                              document["dateHours"],
                              document["dateYears"],
                              document["imageUrl"],
                            );
                          }).toList(),
                        );
                    }
                  },
                ),
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 70,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: 5.0,
                              minWidth: 5.0,
                              maxHeight: 90.0,
                              maxWidth: 30.0,
                            ),
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              controller: m,
                              decoration:
                                  InputDecoration(hintText: "Send Message..."),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Icon(
                        Icons.send,
                        size: 20,
                      ),
                    ),
                    onPressed: () async {
                      try {
                        FirebaseFirestore.instance
                            .collection("chats")
                            .doc()
                            .set({
                          "name": widget.name,
                          "message": m.text,
                          "uid": FirebaseAuth.instance.currentUser.uid,
                          "dateHours":
                              "${DateTime.now().hour} : ${DateTime.now().minute} : ${DateTime.now().second}",
                          "dateYears":
                              "${DateTime.now().year} / ${DateTime.now().month} / ${DateTime.now().day}",
                          "createdTime": Timestamp.now(),
                          "imageUrl": widget.imageLink,
                        });
                        m.clear();
                      } catch (e) {
                        return showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text('Error'),
                                  content: Text(e.toString()),
                                ));
                      }
                    },
                  )
                ],
              )
            ],
          ),
        ));
  }
}
