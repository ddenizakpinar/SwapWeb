import 'package:flutter/material.dart';
import 'package:swapweb_chat/AppScreens/main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen2 extends StatefulWidget {
  static GlobalKey<FormState> _formKeyLog = new GlobalKey<FormState>();

  @override
  _LoginScreen2State createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  final Firestore _firestore = Firestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser user = null;

  String errorMessage = " ";

  String email;

  var password;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/mountain.jpg"), fit: BoxFit.cover),
        ),
        child: Container(
          color: Colors.black.withAlpha(380),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(height: height / (100 / 20)),
                  /*ClipOval(
                  child: Image.asset(
                    'assets/sweb.png',
                    width: 140,
                    height: 140,
                    fit: BoxFit.fill,
                  ),
                ),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "swap",
                        style: TextStyle(color: Colors.white, fontSize: 42),
                      ),
                      Text(
                        "web",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 141, 52),
                            fontSize: 42),
                      )
                    ],
                  ),
                  SizedBox(
                    height: height / (100 / 23),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Form(
                        key: LoginScreen2._formKeyLog,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: width / (100 / 85),
                              child: TextFormField(
                                cursorColor: Color.fromARGB(255, 255, 141, 52),
                                maxLines: 1,
                                minLines: 1,
                                style: TextStyle(color: Colors.white),
                                maxLength: 24,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 141, 52),
                                  )),
                                  disabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 141, 52),
                                  )),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 141, 52),
                                  )),
                                  errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 141, 52),
                                  )),
                                  focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 141, 52),
                                  )),
                                  labelText: "EMAIL",
                                  labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 255, 141, 52),
                                      fontSize: 8),
                                  counterStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 141, 52),
                                  ),
                                ),
                                validator: (value) {
                                  if (!value.contains("@")) {
                                    return "False";
                                  }
                                  return null;
                                },
                                onSaved: (u) {
                                  email = u;
                                },
                              ),
                            ),
                            Container(
                              width: width / (100 / 85),
                              child: TextFormField(
                                cursorColor: Color.fromARGB(255, 255, 141, 52),
                                obscureText: true,
                                maxLines: 1,
                                minLines: 1,
                                style: TextStyle(color: Colors.white),
                                maxLength: 24,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 141, 52),
                                  )),
                                  disabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 141, 52),
                                  )),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 141, 52),
                                  )),
                                  errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 141, 52),
                                  )),
                                  focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 141, 52),
                                  )),
                                  labelText: "PASSWORD",
                                  labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 141, 52),
                                    fontSize: 8,
                                  ),
                                  counterStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 141, 52),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.length < 5) {
                                    return "False";
                                  }
                                  return null;
                                },
                                onSaved: (p) {
                                  password = p;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  activeColor:
                                      Color.fromARGB(255, 255, 141, 52),
                                  value: true,
                                  onChanged: (bool val) {},
                                ),
                              ),
                              Text(
                                "Keep me logged in.",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 14.0),
                          child: Text(
                            "Forgot your password?",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Container(
                      width: width / (100 / 80),
                      height: height / (100 / 9),
                      child: FlatButton(
                        child: Text("Login",
                            style: TextStyle(color: Colors.white)),
                        color: Color.fromARGB(255, 255, 141, 52),
                        onPressed: () async {
                          if (LoginScreen2._formKeyLog.currentState
                              .validate()) {
                            LoginScreen2._formKeyLog.currentState.save();

                            firebaseLogin(context);
                            debugPrint("girildi*");
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, 'register');
                          },
                          child: Text(
                            " Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future firebaseLogin(BuildContext context) async {
    try {
      user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on PlatformException catch (error) {
      print("Error var : " + error.toString()); 

      setState(() {
        errorMessage = "The email or password is incorrect.";
      });
      return;
    } finally {
      print("finally");
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("prefsUrl", user.photoUrl.toString());
    await prefs.setString("prefsEmail", user.email.toString());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(
          user: user,
        ),
      ),
    );
  }
}
