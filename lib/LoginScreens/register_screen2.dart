import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:swapweb_chat/AppScreens/main_page.dart';
import 'package:swapweb_chat/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen2 extends StatefulWidget {
  @override
  _RegisterScreen2State createState() => _RegisterScreen2State();
}

class _RegisterScreen2State extends State<RegisterScreen2> {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String username = "empty";
  String email = "empty";
  String password = "empty";
  var url;
  var firebaseUser;
  String errorMessage = " ";
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File imageFile;
  String imageUrl;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
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
                  SizedBox(height: height / (100 / 10)),
                  Container(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: <Widget>[
                        CircleAvatar(
                          child: Material(
                            child: url != null
                                ? CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Color.fromARGB(255, 255, 141, 52),
                                        ),
                                      ),
                                      width: 500.0,
                                      height: 500.0,
                                      padding: EdgeInsets.all(15.0),
                                    ),
                                    imageUrl: url,
                                    width: 700.0,
                                    height: 700.0,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.account_circle,
                                    size: 170,
                                    color: Colors.grey,
                                  ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(140.0)),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                          ),
                          backgroundColor: Color.fromARGB(255, 255, 141, 52),
                          radius: 90,
                        ),
                        FloatingActionButton(
                          child: Icon(Icons.add_photo_alternate),
                          backgroundColor: Color.fromARGB(255, 255, 141, 52),
                          onPressed: () {
                            getImage();
                          },
                        )
                      ],
                    ),
                  ),

                  /*ClipOval(
                  child: Image.asset(
                    'assets/sweb.png',
                    width: 140,
                    height: 140,
                    fit: BoxFit.fill,
                  ),
                ),*/
                  SizedBox(
                    height: height / (100 / 4),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: width / (100 / 85),
                              child: TextFormField(
                                maxLines: 1,
                                minLines: 1,
                                cursorColor: Color.fromARGB(255, 255, 141, 52),
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
                                    labelText: "USERNAME",
                                    labelStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 141, 52),
                                        fontSize: 8),
                                    errorStyle: TextStyle(
                                      color: Color.fromARGB(255, 255, 141, 52),
                                    ),
                                    counterStyle: TextStyle(
                                      color: Color.fromARGB(255, 255, 141, 52),
                                    )),
                                validator: (value) {
                                  if (value.length < 6) {
                                    return "Username needs to be longer than 5 characters.";
                                  }
                                  return null;
                                },
                                onSaved: (u) {
                                  username = u;
                                },
                              ),
                            ),
                            Container(
                              width: width / (100 / 85),
                              child: TextFormField(
                                maxLines: 1,
                                minLines: 1,
                                style: TextStyle(color: Colors.white),
                                cursorColor: Color.fromARGB(255, 255, 141, 52),
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
                                        color:
                                            Color.fromARGB(255, 255, 141, 52),
                                        fontSize: 8),
                                    errorStyle: TextStyle(
                                      color: Color.fromARGB(255, 255, 141, 52),
                                    ),
                                    counterStyle: TextStyle(
                                      color: Color.fromARGB(255, 255, 141, 52),
                                    )),
                                validator: (value) {
                                  if (!value.contains("@")) {
                                    return "Email address is not valid.";
                                  }
                                  return null;
                                },
                                onSaved: (e) {
                                  email = e;
                                },
                              ),
                            ),
                            Container(
                              width: width / (100 / 85),
                              child: TextFormField(
                                obscureText: true,
                                cursorColor: Color.fromARGB(255, 255, 141, 52),
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
                                  errorStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 141, 52),
                                  ),
                                  counterStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 141, 52),
                                  ),
                                ),
                                validator: (value) {
                                  if (value.length < 6) {
                                    return "Password is too weak.";
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
                  Text(
                    errorMessage,
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 141, 52),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Container(
                      width: width / (100 / 80),
                      height: height / (100 / 9),
                      child: FlatButton(
                        child: Text("Register",
                            style: TextStyle(color: Colors.white)),
                        color: Color.fromARGB(255, 255, 141, 52),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            debugPrint("Email:" +
                                email +
                                "  Password:" +
                                password +
                                "  Username: " +
                                username);
                            await firebaseRegister();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {});
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      debugPrint("img:" + imageUrl.toString());
      setState(() {
        url = imageUrl;
        debugPrint("url" + url.toString());
      });
    }, onError: (err) {});
  }

  Future firebaseRegister() async {
    if (url == null) {
      errorMessage = "Select a photograph";
      return;
    }

    try {
      firebaseUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on PlatformException catch (error) {
      print("Error: " + error.toString());
      setState(() {
        errorMessage = "The email is already in use.";
      });
      return;
    } finally {
      print("finally");
    }
    setState(() {
      errorMessage = " ";
    });
    UserUpdateInfo info = new UserUpdateInfo();

    debugPrint("urdl" + url.toString());
    info.photoUrl = url;
    await firebaseUser.updateProfile(info); // pick profile p.

    User _user = User(
        isim: username,
        email: email,
        username: username,
        url: url,
        uid: firebaseUser.uid);

    Map<String, dynamic> map = _user.toJson();
    var ref = _firestore.collection("users").document(_user.uid);

    await _firestore
        .collection("users")
        .document(ref.documentID)
        .setData(_user.toJson());
    await _firestore
        .collection("users")
        .document(ref.documentID)
        .setData({"friendCount": 0, "bannedCount": 0}, merge: true);
    await _firestore
        .collection("users")
        .document(ref.documentID)
        .collection("friends")
        .document("none")
        .setData({"arrka": "ddf"}, merge: true);
    List friendss = List();
    friendss.add(firebaseUser.uid.toString()); // BURA
    await _firestore
        .collection("users")
        .document(ref.documentID)
        .setData({"friends": friendss}, merge: true);
    await _firestore
        .collection("users")
        .document(ref.documentID)
        .collection("bans")
        .document("none")
        .setData({"arrka": "ddf"}, merge: true);
    await _firestore
        .collection("users")
        .document(ref.documentID)
        .setData({"status": "I'm new here"}, merge: true);
    /*_firestore
        .collection("users")
        .document(ref.documentID)
        .collection("chats")
        .document("none")
        .setData({"arrka": "ddf"}, merge: true);*/
    await _firestore
        .collection("users")
        .document(ref.documentID)
        .collection("friendRequests")
        .document("none")
        .setData({"arrka": "ddf"}, merge: true);
    await _firestore
        .collection("users")
        .document(ref.documentID)
        .collection("status")
        .document("none")
        .setData({"arrka": "ddf"}, merge: true);

    // First post (Joined)
    List<String> li = new List<String>();
    li.add(firebaseUser.uid.toString());
    await _firestore
        .collection("users")
        .document(firebaseUser.uid.toString())
        .collection("posts")
        .document()
        .setData({
      "content": "Hello i'm new here!",
      "ref": firebaseUser.uid,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      "favs": li,
    }).then((onValue) {
      debugPrint("psoted");
    });
    //end

    final snackBar = SnackBar(
        content: Text(
      'Registration successful',
      style: TextStyle(color: Colors.white),
    ));
    _scaffoldKey.currentState.showSnackBar(snackBar);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("prefsUrl", url.toString());
    await prefs.setString("prefsEmail", firebaseUser.email.toString());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(
          user: firebaseUser,
        ),
      ),
    );
  }
}
