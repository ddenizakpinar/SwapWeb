import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swapweb_chat/AppBar/appbar.dart';
import 'package:swapweb_chat/AppBar/drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:swapweb_chat/AppScreens/profile.dart';

class FriendRequests extends StatefulWidget {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  FirebaseUser user;
  FriendRequests({this.user});

  @override
  _FriendRequests createState() => _FriendRequests();
}

class _FriendRequests extends State<FriendRequests> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //String uid =  sc.getFirebaseUserId();

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          "Requests",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 141, 52),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 12, 12, 12),
        centerTitle: true,
      ),
      drawer: MyDrawer(
        user: widget.user,
      ),
      body: Container(
        color: Color.fromARGB(255, 12, 12, 12),
        child: Column(
          children: <Widget>[
            Container(
              child: Expanded(
                child: StreamBuilder(
                  stream: _firestore
                      .collection('users')
                      .document(widget.user.uid.toString())
                      .collection("friendRequests")
                      .orderBy("username")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.all(10.0),
                        itemBuilder: (context, index) => postCard(
                            index,
                            context,
                            snapshot.data.documents[index],
                            height,
                            width),
                        itemCount: snapshot.data.documents.length,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget postCard(int index, BuildContext context, DocumentSnapshot document,
      double height, double width) {
    String a;

    return Column(
      children: <Widget>[
        Container(
          height: height / 8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0), color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          //debugPrint("zaa");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Profile(
                                      user: widget.user,
                                      id: document["uid"].toString(),
                                    )),
                          );
                        },
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Material(
                                        child: document['url'] != null
                                            ? CachedNetworkImage(
                                                placeholder: (context, url) =>
                                                    Container(
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 1.0,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(Colors.red),
                                                  ),
                                                  width: 120,
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
                                                size: 48.0,
                                                color: Colors.grey,
                                              ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0)),
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                      ),
                                      radius: 24,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          document['username'].toString(),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 12, 12, 12),
                                              fontSize: 20),
                                        ),
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.fromLTRB(
                                            10.0, 3.0, 0.0, 0.0),
                                      ),
                                      Container(
                                        child: Text(
                                          (document["status"].toString() + " "),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 12, 12, 12),
                                              fontSize: 14),
                                        ),
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.fromLTRB(
                                            10.0, 3.0, 0.0, 0.0),
                                      ),
                                    ],
                                  ),
                                ),

                                //Icon(Icons.dehaze),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: IconButton(
                              onPressed: () async {
                                DocumentSnapshot ds = await _firestore
                                    .collection("users")
                                    .document(widget.user.uid.toString())
                                    .get();

                                //Yukardaki

                                List liste = new List();
                                await _firestore
                                    .collection("users")
                                    .document(document.documentID.toString())
                                    .get()
                                    .then((onValue) {
                                  liste.addAll(onValue["friends"]);
                                });

                                debugPrint("list " + liste.toString());
                                liste.add(widget.user.uid.toString());
                                debugPrint("new list " + liste.toString());

                                await _firestore
                                    .collection("users")
                                    .document(document.documentID.toString())
                                    .setData({"friends": liste}, merge: true);

                                // Karşı
                                liste.clear();
                                await _firestore
                                    .collection("users")
                                    .document(widget.user.uid.toString())
                                    .get()
                                    .then((onValue) {
                                  liste.addAll(onValue["friends"]);
                                });

                                debugPrint("listebu " + liste.toString());
                                liste.add(document.documentID.toString());

                                await _firestore
                                    .collection("users")
                                    .document(widget.user.uid.toString())
                                    .setData({"friends": liste}, merge: true);

                                await _firestore
                                    .collection("users")
                                    .document(widget.user.uid.toString())
                                    .collection("friendRequests")
                                    .document(document.documentID)
                                    .delete();
                              },
                              icon: Icon(
                                Icons.check,
                                size: 32,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: IconButton(
                              onPressed: () async {
                                await _firestore
                                    .collection("users")
                                    .document(widget.user.uid.toString())
                                    .collection("friendRequests")
                                    .document(document.documentID)
                                    .delete();
                              },
                              icon: Icon(
                                Icons.close,
                                size: 32,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
        )
      ],
    );
  }
}
/*Widget buildItem(BuildContext context, DocumentSnapshot document) {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    child: Text("req"),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          '${document['username']}',
                          style: TextStyle(color: Colors.red),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          '${document['status']}',
                          style: TextStyle(color: Colors.blue),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      )
                    ],
                  ),
                ],
              ),
              margin: EdgeInsets.only(left: 20.0),
            ),
          ),
          InkWell(
            onTap: () async {
              DocumentSnapshot ds = await _firestore
                  .collection("users")
                  .document(widget.user.uid.toString())
                  .get();
       
              //Yukardaki

              List liste = new List();
              await _firestore
                  .collection("users")
                  .document(document.documentID.toString())
                  .get()
                  .then((onValue) {
                liste.addAll(onValue["friends"]);
              });

              debugPrint("listebu " + liste.toString());
              liste.add(widget.user.uid.toString());
              debugPrint("listeyenibu " + liste.toString());

              await _firestore
                  .collection("users")
                  .document(document.documentID.toString())
                  .setData({"friends": liste}, merge: true);

              // Karşı
              liste.clear();
              await _firestore
                  .collection("users")
                  .document(widget.user.uid.toString())
                  .get()
                  .then((onValue) {
                liste.addAll(onValue["friends"]);
              });

              debugPrint("listebu " + liste.toString());
              liste.add(document.documentID.toString());

              await _firestore
                  .collection("users")
                  .document(widget.user.uid.toString())
                  .setData({"friends": liste}, merge: true);

              await _firestore
                  .collection("users")
                  .document(widget.user.uid.toString())
                  .collection("friendRequests")
                  .document(document.documentID)
                  .delete();
            },
            child: Icon(
              Icons.check,
              size: 28,
            ),
          ),
          InkWell(
            child: Icon(
              Icons.close,
              size: 28,
            ),
            onTap: () async {
              await _firestore
                  .collection("users")
                  .document(widget.user.uid.toString())
                  .collection("friendRequests")
                  .document(document.documentID)
                  .delete();
            },
          )
        ],
      ),
    );
  }
}
*/
