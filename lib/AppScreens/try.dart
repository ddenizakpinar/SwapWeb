import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swapweb_chat/AppScreens/profile.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Try extends StatefulWidget {
  FirebaseUser user;
  Try({this.user});
  bool loading = false;
  @override
  _Try createState() => _Try(user: user);
}

class _Try extends State<Try> {
  FirebaseUser user;
  _Try({this.user});
  ScrollController _controller;
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> friends;

  @override
  void initState() {
    super.initState();
    friends = List<String>();
    friends.add("5y1rwFJf9FYMYD8upSuhw292GOQ2");
    _controller = ScrollController();
    //_controller.addListener(_scrollListener);

    setState(() {
      widget.loading = false;
      //debugPrint("false now");
    });
  }

// DURSUN BU list2[index]["docID"].toString()
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: Colors.grey.withAlpha(100),
        child: Center(
          child: Container(
            child: widget.loading == true
                ? CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  )
                : Container(
                    color: Colors.grey.withAlpha(100),
                    child: StreamBuilder(
                      stream: Firestore.instance
                          .collection('posts')
                          .orderBy('timestamp', descending: true).where("id",isEqualTo: friends[0])
                          .limit(20)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.red)));
                        } else {
                          //listMessage = snapshot.data.documents;
                          return ListView.builder(
                            padding: EdgeInsets.all(10.0),
                            itemBuilder: (context, index) => postCard(
                                snapshot.data.documents[index], width, height),
                            itemCount: snapshot.data.documents.length,
                            reverse: true,
                          );
                        }
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Container postCard(DocumentSnapshot document, width, height) {
    int intTime = int.parse(document["timestamp"]);
    DateTime datee = new DateTime.fromMillisecondsSinceEpoch(intTime);
    return Container(
      child: Text(document["content"]),
    );
  }

  String date(DateTime tm) {
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    Duration oneWeek = new Duration(days: 7);
    String month;
    switch (tm.month) {
      case 1:
        month = "january";
        break;
      case 2:
        month = "february";
        break;
      case 3:
        month = "march";
        break;
      case 4:
        month = "april";
        break;
      case 5:
        month = "may";
        break;
      case 6:
        month = "june";
        break;
      case 7:
        month = "july";
        break;
      case 8:
        month = "august";
        break;
      case 9:
        month = "september";
        break;
      case 10:
        month = "october";
        break;
      case 11:
        month = "november";
        break;
      case 12:
        month = "december";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      if (tm.hour < 10 && tm.minute < 10) {
        return '0${tm.hour}:0${tm.minute}';
      }
      if (tm.hour < 10) {
        return '0${tm.hour}:${tm.minute}';
      }
      if (tm.minute < 10) {
        return '${tm.hour}:0${tm.minute}';
      } else {
        return '${tm.hour}:${tm.minute}';
      }
    } else if (difference.compareTo(twoDay) < 1) {
      return "yesterday";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (tm.weekday) {
        case 1:
          return "monday";
        case 2:
          return "tuesday";
        case 3:
          return "wednesday";
        case 4:
          return "thurdsday";
        case 5:
          return "friday";
        case 6:
          return "saturday";
        case 7:
          return "sunday";
      }
    } else if (tm.year == today.year) {
      return '${tm.day} $month';
    } else {
      return '${tm.day} $month ${tm.year}';
    }
    return "";
  }
}
