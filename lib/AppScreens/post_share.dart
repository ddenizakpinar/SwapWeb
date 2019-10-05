import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:swapweb_chat/AppBar/appbar.dart';
import 'package:swapweb_chat/AppBar/drawer.dart';
import 'package:swapweb_chat/AppScreens/chat.dart';
import 'package:swapweb_chat/AppScreens/profile.dart';

class PostShare extends StatefulWidget {
  FirebaseUser user;
  PostShare({this.user});

  @override
  _PostShare createState() => _PostShare(user: user);
}

class _PostShare extends State<PostShare> {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  FirebaseUser user;
  _PostShare({this.user});
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _textFieldController = TextEditingController();
  String post;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //String uid =  sc.getFirebaseUserId();

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: RichText(
          text: TextSpan(children: <TextSpan>[
            TextSpan(
                text: "Share",
                style: TextStyle(color: Color.fromARGB(255, 255, 141, 52))),
            TextSpan(text: " post", style: TextStyle(color: Colors.white)),
            //TextSpan(text: "chat", style: TextStyle(color: Colors.white,fontSize: 30))
          ], style: TextStyle(fontSize: 28)),
        ),
        backgroundColor: Colors.black,
      ),
      drawer: MyDrawer(
        user: widget.user,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text("What are you thinking?",style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _textFieldController,
                      maxLength: 240,
                      minLines: 1,
                      maxLines: 6,
                      onSaved: (txt) {
                        post = txt;
                      },
                      validator: (txt) {
                        if (txt.length < 5) {
                          return "";
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            RaisedButton(
              child: Text("Send"),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();

                  // debugPrint(post+"n");
                  await postSend(post);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future postSend(String post) async {
    List<String> li = new List<String>();
    li.add(user.uid.toString());

    await _firestore
        .collection("users")
        .document(user.uid.toString())
        .collection("posts")
        .document()
        .setData({
      "content": post,
      "ref": user.uid,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      "favs": li,
    }).then((onValue) {
      debugPrint("psoted");
    });
  }
}
