import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:swapweb_chat/AppBar/appbar.dart';
import 'package:swapweb_chat/AppBar/drawer.dart';
import 'package:swapweb_chat/AppScreens/chat.dart';
import 'package:swapweb_chat/AppScreens/profile.dart';

class Settings extends StatefulWidget {
  FirebaseUser user;
  Settings({this.user});

  @override
  _Settings createState() => _Settings(user: user);
}

class _Settings extends State<Settings> {
  static GlobalKey<FormState> _formKeySettings;
  FirebaseUser user;
  _Settings({this.user});
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  File imageFile;
  String done = "";
  String imageUrl;
  String status = " ?";
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _textFieldController = TextEditingController();
  String post;
  String text = "";
  var url;
  @override
  void initState() {
    super.initState();
    getStatus();
    setState(() {
      _formKeySettings = new GlobalKey<FormState>();
      url = user.photoUrl;
      _textFieldController.text = status;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //String uid =  sc.getFirebaseUserId();

    return Scaffold(
      key: _scaffoldKey,
      //resizeToAvoidBottomPadding: false,
      backgroundColor: Color.fromARGB(255, 12, 12, 12),
      appBar: AppBar(
        title: RichText(
          text: TextSpan(children: <TextSpan>[
            TextSpan(
                text: "Settings",
                style: TextStyle(color: Color.fromARGB(255, 255, 141, 52))),
            // TextSpan(text: " yap", style: TextStyle(color: Colors.red)),
            //TextSpan(text: "chat", style: TextStyle(color: Colors.white,fontSize: 30))
          ], style: TextStyle(fontSize: 28)),
        ),
        backgroundColor: Colors.black,
      ),
      drawer: MyDrawer(
        user: widget.user,
      ),
      body: Container(
        color: Color.fromARGB(255, 12, 12, 12),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: height / (100 / 7),
                ),
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.red),
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
                          clipBehavior: Clip.hardEdge,
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
                Container(
                    height: height / (100 / 16),
                    width: width / (100 / 70),
                    child: Form(
                        key: _formKeySettings,
                        child: TextFormField(
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 141, 52),
                            decorationColor: Color.fromARGB(255, 255, 141, 52),
                          ),
                          maxLines: 1,
                          minLines: 1,
                          maxLength: 24,
                          keyboardType: TextInputType.text,
                          controller: _textFieldController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 255, 141, 52)),
                              labelText: "Status",
                              fillColor: Colors.red,
                              focusColor: Color.fromARGB(255, 255, 141, 52),
                              hoverColor: Color.fromARGB(255, 255, 141, 52)),
                        ))),
                RaisedButton(
                  onPressed: () {
                    if (_formKeySettings.currentState.validate()) {
                      _formKeySettings.currentState.save();
                      statusSave();
                      imageSave();
                      setState(() {
                        done = "Profile has been updated";
                        text = "Relogin to see updates";
                      });
                    }
                  },
                  child: Text("Submit"),
                ),
                SizedBox(
                  height: height / 40,
                ),
                Text(
                  done,
                  style: TextStyle(color: Color.fromARGB(255, 255, 141, 52)),
                ),
                Text(
                  text,
                  style: TextStyle(color: Color.fromARGB(255, 255, 141, 52)),
                ),
              ],
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
      debugPrint("hey resim:" + imageUrl.toString());
      setState(() {
        url = imageUrl;
      });
    }, onError: (err) {});
  }

  void statusSave() {
    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(
        _firestore.collection("users").document(user.uid.toString()),
        {
          'status': _textFieldController.text,
        },
      );
    });
  }

  Future imageSave() async {
    UserUpdateInfo info = new UserUpdateInfo();
    info.photoUrl = url;
    if (url) {
      await user.updateProfile(info);
    }

    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(
        _firestore.collection("users").document(user.uid.toString()),
        {
          'url': url,
        },
      );
    });
  }

  void getStatus() async {
    var dataSet = await _firestore
        .collection("users")
        .document(user.uid.toString())
        .get();
    setState(() {
      status = dataSet.data["status"].toString();
      _textFieldController.text = status;
    });
  }
}
