import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

// ignore: must_be_immutable
class ChatMessage extends StatelessWidget {
  final messageText;
  final uid;
  final name;
  final dateYears;
  final dateHours;
  final imageLink;
  ChatMessage(this.name, this.messageText, this.uid, this.dateHours,
      this.dateYears, this.imageLink);

  @override
  Widget build(BuildContext context) {
    if (uid == FirebaseAuth.instance.currentUser.uid) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.network(
                imageLink,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                name.toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w700),
                              ),
                            ),
                            // "${DateTime.now().hour} : ${DateTime.now().minute} : ${DateTime.now().second}"
                            Text(dateHours.toString(),
                                style: TextStyle(fontWeight: FontWeight.w300)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 0, right: 10, left: 15),
                        child: Text(messageText,
                            textWidthBasis: TextWidthBasis.parent,
                            style: TextStyle(height: 1.5, fontSize: 17)),
                      ),
                      Row(
                        children: [
                          SizedBox(width: 170),
                          Text(
                            dateYears.toString(),
                            style: TextStyle(fontWeight: FontWeight.w200),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // "${DateTime.now().hour} : ${DateTime.now().minute} : ${DateTime.now().second}"
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(dateHours.toString(),
                                  style:
                                      TextStyle(fontWeight: FontWeight.w300)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                name.toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 0, right: 10, left: 15),
                        child: Text(messageText,
                            textWidthBasis: TextWidthBasis.parent,
                            style: TextStyle(height: 1.5, fontSize: 17)),
                      ),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            dateYears.toString(),
                            style: TextStyle(fontWeight: FontWeight.w200),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 50,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.network(
                imageLink,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      );
    }
  }
}
