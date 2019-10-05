import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:swapweb_chat/AppBar/drawer.dart';
import 'package:swapweb_chat/AppScreens/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatefulWidget {
  final String peerId;
  final FirebaseUser user;
  final String username;
  final String url;

  Chat({this.peerId, this.user, this.username, this.url});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String selfUrl = " ";
  @override
  void initState() {
    super.initState();
    getUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profile(
                          user: widget.user,
                          id: widget.peerId.toString(),
                        )));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  ClipOval(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.network(
                      widget.url != null ? widget.url : selfUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      widget.username,
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 141, 52),
                          fontSize: 28),
                    ),
                  )
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.scatter_plot),
              ),
            ],
          ),
        ),
        backgroundColor: Color.fromARGB(255, 12, 12, 12),
        centerTitle: true,
      ),
      drawer: MyDrawer(
        user: widget.user,
      ),
      body: ChatScreen(
        peerId: widget.peerId,
        user: widget.user,
      ),
    );
  }

  Future getUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selfUrl = prefs.getString("prefsUrl");
    });
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  final FirebaseUser user;

  ChatScreen({this.peerId, this.user});

  @override
  State createState() => ChatScreenState(peerId: peerId, user: user);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState({this.peerId, this.user});
  final FirebaseUser user;
  String peerId;
  String id;
  String username;
  var listMessage;
  String groupChatId;
  bool isLoading;
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    var ds = Firestore.instance.collection("users").document(peerId).get();
    ds.then((onValue) {
      username = onValue["username"];
    });
    groupChatId = '';
    isLoading = false;
    id = widget.user.uid;
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    read();
    setState(() {});
  }

  void onSendMessage(String content) {
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
          },
        );
      });

      var docRef2 = Firestore.instance
          .collection('users')
          .document(user.uid.toString())
          .collection("chats")
          .document(peerId.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(
          docRef2,
          {
            "lastMessage": content,
            "lastMessageFrom": id,
            "lastMessageTime": DateTime.now().millisecondsSinceEpoch.toString(),
            "hasRead": "1"
          },
        );
      });

      var docRef3 = Firestore.instance
          .collection('users')
          .document(peerId.toString())
          .collection("chats")
          .document(id.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(
          docRef3,
          {
            "lastMessage": content,
            "lastMessageFrom": id,
            "lastMessageTime": DateTime.now().millisecondsSinceEpoch.toString(),
            "hasRead": "0",
            "unreadCount": FieldValue.increment(1)
          },
        );
      });

      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {}
  }

  Widget buildItem(DocumentSnapshot document) {
    int intTime = int.parse(document["timestamp"]);
    DateTime datee = new DateTime.fromMillisecondsSinceEpoch(intTime);

    if (document['idFrom'] == id) {
      return Row(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(
                    document['content'],
                    style: TextStyle(color: Color.fromARGB(255, 12, 12, 12)),
                  ),
                ),
                Text(
                  date(datee),
                  style: TextStyle(color: Colors.black26),
                )
              ],
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            margin: EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 141, 52),
                borderRadius: BorderRadius.circular(10.0)),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          document['content'],
                          style:
                              TextStyle(color: Color.fromARGB(255, 12, 12, 12)),
                        ),
                      ),
                      Text(
                        date(datee),
                        style: TextStyle(color: Colors.black26),
                      )
                    ],
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(left: 10.0),
                ),
              ],
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 6.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            buildListMessage(),
            buildInput(),
          ],
        ),

        // Loading
      ],
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              color: Color.fromARGB(255, 12, 12, 12), // DON DÖN
              child: Padding(
                padding: const EdgeInsets.only(left: 36.0),
                child: TextField(
                  cursorColor: Color.fromARGB(255, 255, 141, 52),
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 141, 52), fontSize: 15.0),
                  controller: textEditingController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Type something...',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 141, 52),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: Material(
              child: Container(
                child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => onSendMessage(textEditingController.text),
                  color: Color.fromARGB(255, 255, 141, 52),
                  iconSize: 40,
                ),
              ),
              color: Color.fromARGB(255, 12, 12, 12),
            ),
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width / (100 / 100),
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Color.fromARGB(255, 255, 141, 52), width: 0.5)),
          color: Color.fromARGB(255, 12, 12, 12)),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: Container(
        color: Color.fromARGB(245, 12, 12, 12),
        child: groupChatId == ''
            ? Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan)))
            : StreamBuilder(
                stream: Firestore.instance
                    .collection('messages')
                    .document(groupChatId)
                    .collection(groupChatId)
                    .orderBy('timestamp', descending: true)
                    .limit(20)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red)));
                  } else {
                    listMessage = snapshot.data.documents;
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) =>
                          buildItem(snapshot.data.documents[index]),
                      itemCount: snapshot.data.documents.length,
                      reverse: true,
                      controller: listScrollController,
                    );
                  }
                },
              ),
      ),
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

  void read() async {
    var docRef2 = Firestore.instance
        .collection('users')
        .document(user.uid.toString())
        .collection("chats")
        .document(peerId.toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(
        docRef2,
        {"hasRead": "1", "unreadCount": 0},
      );
    });
  }
}
