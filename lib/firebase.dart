import 'package:flutter/material.dart';
import 'AppBar/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStore extends StatefulWidget {
  @override
  _FireStoreState createState() => _FireStoreState();
}

class _FireStoreState extends State<FireStore> {
  final Firestore _firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: RaisedButton(
          child: Text("Ekle"),
          onPressed: _veriEkle,
        ),
      ),
    );
  }

  void _veriEkle() {
    Map<String, dynamic> denizEkle = Map();
    denizEkle['ad'] = "denizz";
    denizEkle['soy'] = "akpinar";
    debugPrint("d");
    _firestore
        .collection("users")
        .document("sxIEBp210LCCQ1uY5hW4")
        .setData(denizEkle)
        .then((onValue) => debugPrint("aa"));
  }
}
