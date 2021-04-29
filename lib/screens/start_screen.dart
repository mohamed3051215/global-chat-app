import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_screen.dart';
import 'signin_screen.dart';
import 'signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';

// ignore: must_be_immutable
class StartScreen extends StatefulWidget {
  bool signInIsLoading = false;
  bool signUpIsLoading = false;

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool isloggedin = false;
  String name = "stillNotFound";
  var x;
  @override
  // ignore: must_call_super
  void initState() {
    getData();
  }

  goSignIn() {
    setState(() {
      widget.signInIsLoading = true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
    setState(() {
      widget.signInIsLoading = false;
    });
  }

  goSignUp() {
    setState(() {
      widget.signUpIsLoading = true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
    setState(() {
      widget.signUpIsLoading = false;
    });
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isloggedin = prefs.getBool("isloggedin");
      name = prefs.getString("name");
      x = prefs;
    });
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    if (x != null) {
      if (x.getBool("isloggedin") != null) {
        if (x.getBool("isloggedin")) {
          FirebaseAuth.instance.signInWithEmailAndPassword(
              email: x.getString("email"), password: x.getString("password"));
          return ChatScreen(x.getString("name"), x.getString("imageUrl"));
        } else {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 90.0, horizontal: 60),
                    child: Container(
                        child: Image.asset("assets/images/start.png",
                            fit: BoxFit.cover, height: 300)),
                  ),
                  Text(
                    "Get Started...",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 20),
                  if (!widget.signUpIsLoading)
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: goSignUp,
                        style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0))),
                        child: Text("Sign Up",
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    )
                  else
                    CircularProgressIndicator(),
                  SizedBox(height: 40),
                  if (!widget.signInIsLoading)
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0))),
                        onPressed: goSignIn,
                        child: Text("Sign In",
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    )
                  else
                    CircularProgressIndicator()
                ],
              ),
            ),
          );
        }
      } else {
        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 90.0, horizontal: 60),
                child: Container(
                    child: Image.asset("assets/images/start.png",
                        fit: BoxFit.cover, height: 300)),
              ),
              Text(
                "Get Started...",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width - 100,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    print(FirebaseAuth.instance.currentUser);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                  child: Text("Sign Up",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
              SizedBox(height: 40),
              Container(
                width: MediaQuery.of(context).size.width - 100,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  },
                  child: Text("Sign In",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      }
    } else {
      return Scaffold(
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 90.0, horizontal: 60),
              child: Container(
                  child: Image.asset("assets/images/start.png",
                      fit: BoxFit.cover, height: 300)),
            ),
            Text(
              "Get Started...",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width - 100,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  print(FirebaseAuth.instance.currentUser);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0))),
                child: Text("Sign Up",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
            SizedBox(height: 40),
            Container(
              width: MediaQuery.of(context).size.width - 100,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0))),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                },
                child: Text("Sign In",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
          ],
        ),
      );
    }
  }
}

// ignore: unnecessary_null_comparison
//   showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//             title: Text('Done'),
//             content: Text('your account is added succeefuly'),
//           ));
//   print(_auth);
// } else {
//   showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//             title: Text('Invalid Data '),
//             content: Text('this data doesn\'t help'),
//           ));
// }
// }
// ,
