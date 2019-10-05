import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swapweb_chat/AppScreens/chat.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:swapweb_chat/AppScreens/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  FirebaseUser user;
  String text;
  SearchScreen({this.user, this.text});
  @override
  _SearchScreen createState() => _SearchScreen(user: user, text: text);
}

class _SearchScreen extends State<SearchScreen> {
  FirebaseUser user;
  String text;
  bool loading = true;
  TextEditingController _textEditingController;
  _SearchScreen({this.user, this.text});
  var search = 1;
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Color color;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingController.text = text;
  }

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
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          search == 0
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      search = 1;
                    });
                  },
                  icon: Icon(Icons.search),
                )
              : IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      search = 0;
                    });
                  },
                ),
        ],
        centerTitle: true,
        title: search == 0
            ? Text(
                "Search Results",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 141, 52),
                ),
              )
            : TextFormField(
                controller: _textEditingController,
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 141, 52),
                ),
                cursorColor: Color.fromARGB(255, 255, 141, 52),
                decoration: InputDecoration(
                  hintText: "Search...",
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 141, 52),
                  ),
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 255, 141, 52),
                  ),
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
                ),
                onEditingComplete: () {
                  setState(() {
                    text = _textEditingController.text;
                  });
                },
              ),
        backgroundColor: Color.fromARGB(255, 12, 12, 12),
      ),
      body: Container(
          color: Color.fromARGB(255, 12, 12, 12),
          child: StreamBuilder(
              stream: _firestore
                  .collection('users')
                  .where("username", isEqualTo: text)
                  .snapshots(),
              builder: (context, snapshot) {
                if (loading) {
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
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            //return buildItemList(index, context,
                            //     projectSnap.data[index], height, width);
                            return buildItemList(index, context,
                                projectSnap.data[index], height, width);
                          },
                          itemCount: snapshot.data.documents.length,
                        );
                      }
                    },
                  );
                }
              })),
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

    //debugPrint("peeee"+dsList[1]["lastMessageTime"].toString());

    debugPrint("zzzzzzz" + dsList.toString());
   
    if (this.mounted) {
      setState(() {
        loading = false;
      });
    }
    return dsList;
  }

  Widget buildItemList(
      index, BuildContext context, DocumentSnapshot document, height, width) {
    debugPrint("yo");
    // return Text(document.data["username"]);
    String a;

    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: height / 7,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0), color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            child: document.data['url'] != null
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
                                                    imageUrl:
                                                        document.data['url'],
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
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              document.data['username']
                                                  .toString(),
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
                                              (document.data["status"]
                                                      .toString() +
                                                  " "),
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
                                        id: document.data["uid"].toString(),
                                      )),
                            );
                          },
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
            // color: Color.fromARGB(255, 255, 141, 52),
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
