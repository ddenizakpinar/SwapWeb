import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swapweb_chat/AppScreens/chat.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:swapweb_chat/AppScreens/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatsScreen extends StatefulWidget {
  FirebaseUser user;
  ChatsScreen({this.user});
  @override
  _ChatsScreen createState() => _ChatsScreen(user: user);
}

class _ChatsScreen extends State<ChatsScreen> {
  FirebaseUser user;
  _ChatsScreen({this.user});

  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Color color;
/*
 ListView.builder(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    itemBuilder: (context, index) => buildItemList(
                        context, snapshot.data.documents[index], height, width),
                    itemCount: snapshot.data.documents.length,*/
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: Color.fromARGB(255, 12, 12, 12),
      child: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('users')
                  .document(widget.user.uid.toString())
                  .collection("chats")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  );
                } else {
                  return FutureBuilder(
                    future: bilmemne(snapshot.data.documents),
                    builder: (context, projectSnap) {
                      if (projectSnap.hasData == null) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 255, 141, 52)),
                          ),
                        );
                      } else {
                        if (projectSnap.data == null) {
                          return Column(
                            children: <Widget>[
                              AppBar(
                                title: Text(
                                  "Chats",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 141, 52),
                                  ),
                                ),
                                centerTitle: true,
                                backgroundColor:
                                    Color.fromARGB(255, 12, 12, 12),
                              ),
                              SizedBox(
                                height: height / 3,
                              ),
                              Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color.fromARGB(255, 255, 141, 52)),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              return buildItemList(index, context,
                                  projectSnap.data[index], height, width);
                            },
                            itemCount: snapshot.data.documents.length,
                          );
                        }
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<DocumentSnapshot>> bilmemne(
      List<DocumentSnapshot> documentList) async {
    debugPrint("boyut" + documentList.length.toString());
    debugPrint("boyutt" + documentList[0].data.toString());
    List<DocumentSnapshot> dsList = List<DocumentSnapshot>();
    DocumentSnapshot ds;
    for (var i in documentList) {
      ds = await _firestore
          .collection("users")
          .document(i["uid"].toString())
          .get();

      ds.data.addAll(i.data);
      //debugPrint("jee"+i.data.toString());
      dsList.add(ds);
    }
    dsList.sort((m1, m2) {
      var r = m2["lastMessageTime"].compareTo(m1["lastMessageTime"]);
      if (r != 0) return r;
      return m2["lastMessageTime"].compareTo(m1["lastMessageTime"]);
    });
    //debugPrint("peeee"+dsList[1]["lastMessageTime"].toString());
    return dsList;
  }

  Widget buildItemList(index, BuildContext context, DocumentSnapshot document,
      double height, double width) {
    String a;

    var d = DateTime.fromMillisecondsSinceEpoch(
        int.parse((document["lastMessageTime"])));

    var date = DateFormat("kk:mm").format(d);
    if (index == 0) {
      return Column(
        children: <Widget>[
          AppBar(
            title: Text(
              "Chats",
              style: TextStyle(
                color: Color.fromARGB(255, 255, 141, 52),
              ),
            ),
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 12, 12, 12),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(
                          user: widget.user,
                          peerId: document.documentID,
                          username: document["username"],
                          url: document["url"],
                        )),
              );
            },
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: height / 8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.0),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: Row(
                              children: <Widget>[
                                InkWell(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5),
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  child: Material(
                                                    child: document['url'] !=
                                                            null
                                                        ? CachedNetworkImage(
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Container(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                strokeWidth:
                                                                    1.0,
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                            Color>(
                                                                        Colors
                                                                            .red),
                                                              ),
                                                              width: 120,
                                                              height: 120.0,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          15.0),
                                                            ),
                                                            imageUrl:
                                                                document['url'],
                                                            width: 120.0,
                                                            height: 120.0,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .account_circle,
                                                            size: 48.0,
                                                            color: Colors.grey,
                                                          ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30.0)),
                                                    clipBehavior: Clip
                                                        .antiAliasWithSaveLayer,
                                                  ),
                                                  radius: 30,
                                                ),
                                              ),
                                            ),

                                            //Icon(Icons.dehaze),
                                          ],
                                        ),
                                        margin: EdgeInsets.only(left: 20.0),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Profile(
                                                user: widget.user,
                                                id: document["uid"].toString(),
                                              )),
                                    );
                                  },
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 6, 0, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          document['username'].toString(),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.fromLTRB(
                                            10.0, 3.0, 0.0, 0.0),
                                      ),
                                      Container(
                                        child: Text(
                                          (document["lastMessage"].toString() +
                                              ""),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.fromLTRB(
                                            10.0, 3.0, 0.0, 0.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 28, 0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  date,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: document["hasRead"] == "1"
                                        ? Colors.black
                                        : Color.fromARGB(255, 255, 141, 52),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: document["unreadCount"] > 0
                                      ? CircleAvatar(
                                          //foregroundColor: Colors.green,
                                          backgroundColor:
                                              Color.fromARGB(255, 255, 141, 52),
                                          radius: 13,
                                          child: Text(
                                            document["unreadCount"].toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      : Container(),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                )
              ],
            ),
          ),
        ],
      );
    }
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Chat(
                    user: widget.user,
                    peerId: document.documentID,
                    username: document["username"],
                    url: document["url"],
                    // urlSelf: ,
                  )),
        );
      },
      child: Column(
        children: <Widget>[
          Container(
            height: height / 8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0), color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Material(
                                            child: document['url'] != null
                                                ? CachedNetworkImage(
                                                    placeholder:
                                                        (context, url) =>
                                                            Container(
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 1.0,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                Colors.red),
                                                      ),
                                                      width: 120,
                                                      height: 120.0,
                                                      padding:
                                                          EdgeInsets.all(15.0),
                                                    ),
                                                    imageUrl: document['url'],
                                                    width: 120.0,
                                                    height: 120.0,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Icon(
                                                    Icons.account_circle,
                                                    size: 48.0,
                                                    color: Colors.grey,
                                                  ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0)),
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                          ),
                                          radius: 30,
                                        ),
                                      ),
                                    ),

                                    //Icon(Icons.dehaze),
                                  ],
                                ),
                                margin: EdgeInsets.only(left: 20.0),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profile(
                                        user: widget.user,
                                        id: document["uid"].toString(),
                                      )),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 6, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  document['username'].toString(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                                alignment: Alignment.centerLeft,
                                margin:
                                    EdgeInsets.fromLTRB(10.0, 3.0, 0.0, 0.0),
                              ),
                              Container(
                                child: Text(
                                  (document["lastMessage"].toString() + "ff "),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                ),
                                alignment: Alignment.centerLeft,
                                margin:
                                    EdgeInsets.fromLTRB(10.0, 3.0, 0.0, 0.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 4, 28, 0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 12,
                            color: document["hasRead"] == "1"
                                ? Colors.black
                                : Color.fromARGB(255, 255, 141, 52),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: document["unreadCount"] > 0
                              ? CircleAvatar(
                                  //foregroundColor: Colors.green,
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 141, 52),
                                  radius: 13,
                                  child: Text(
                                    document["unreadCount"].toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : Container(),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
          )
        ],
      ),
    );
  }
/*
  Widget buildItemList(BuildContext context, DocumentSnapshot document,
      double height, double width) {
    String a;
    //debugPrint(document["status"]);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0), color: Colors.white),
        child: Row(
          children: <Widget>[
            Flexible(
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Material(
                                  color: Colors.white,
                                  child: document['url'] != null
                                      ? CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Container(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1.0,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.red),
                                            ),
                                            width: 120.0,
                                            height: 120.0,
                                            padding: EdgeInsets.all(15.0),
                                          ),
                                          imageUrl: document['url'],
                                          width: 120.0,
                                          height: 120.0,
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(
                                          Icons.account_circle,
                                          size: 60.0,
                                          color: Colors.grey,
                                        ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(125.0)),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                ),
                                radius: 30,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    document['username'].toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  margin:
                                      EdgeInsets.fromLTRB(10.0, 3.0, 0.0, 0.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(left: 20.0),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Chat(
                              user: widget.user,
                              peerId: document.documentID,
                              username: document["username"],
                            )),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }*/
}
