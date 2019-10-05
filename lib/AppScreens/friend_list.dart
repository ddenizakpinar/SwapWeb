import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//SIGN OUT SILDIN
import 'package:swapweb_chat/AppBar/drawer.dart';
import 'package:swapweb_chat/AppScreens/chat.dart';
import 'package:swapweb_chat/AppScreens/profile.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FriendList extends StatefulWidget {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  FirebaseUser user;
  FriendList({this.user});

  @override
  _FriendList createState() => _FriendList(user: user);
}

class _FriendList extends State<FriendList> {
  FirebaseUser user;
  _FriendList({this.user});
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _textFieldController = TextEditingController();
  // List<dynamic> dataList = List<dynamic>();
  List<dynamic> friendList = List<dynamic>();
  List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUpData();
  }

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
        centerTitle: true,
        title: RichText(
          text: TextSpan(children: <TextSpan>[
            TextSpan(
                text: "Friends",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 141, 52),
                )),

            //TextSpan(text: "chat", style: TextStyle(color: Colors.white,fontSize: 30))
          ], style: TextStyle(fontSize: 28)),
        ),
        backgroundColor: Color.fromARGB(255, 12, 12, 12),
      ),
      drawer: MyDrawer(
        user: widget.user,
      ),
      body: Container(
        color: Color.fromARGB(255, 12, 12, 12),
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, index) {
                return postCard(index, width, height);
              },
              itemCount: dataList.length,
            )),
          ],
        ),
      ),
    );
  }

/*  Widget postCard(index, width, height) {
    debugPrint("bura" + dataList[0]["username"].toString());
    return Container(child: Text(dataList[index]["username"].toString()));
  }*/

  setUpData() async {
    await _firestore
        .collection("users")
        .document(user.uid.toString())
        .get()
        .then((onValue) {
      friendList.addAll(onValue["friends"]);
    });

    for (var friend in friendList) {
      // debugPrint(friend);
      await _firestore
          .collection("users")
          .document(friend.toString())
          .get()
          .then((onValue) {
        debugPrint("?" + onValue["username"].toString());
        //dataList.add({"username": onValue["username"]});
        dataList.add(onValue.data);
      });
    }

    setState(() {});
  }

  Widget postCard(int index, double height, double width) {
    String a;

    return Column(
      children: <Widget>[
        Container(
          height: height / 5,
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
                                      padding: const EdgeInsets.only(right: 5),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Material(
                                          child: dataList[index]['url'] != null
                                              ? CachedNetworkImage(
                                                  placeholder: (context, url) =>
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
                                                  imageUrl: dataList[index]
                                                      ['url'],
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
                                            dataList[index]['username']
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
                                            (dataList[index]["status"]
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
                                      id: dataList[index]["uid"].toString(),
                                    )),
                          );
                        },
                      ),
                      Row(
                        children: <Widget>[
                          InkWell(
                            child: Icon(
                              Icons.mail,
                              size: 30,
                            ),
                            onTap: () async {
                              DocumentSnapshot ds = await _firestore
                                  .collection("users")
                                  .document(widget.user.uid.toString())
                                  .get();
                              _firestore //uid
                                  .collection("users")
                                  .document(widget.user.uid)
                                  .collection("chats")
                                  .document(dataList[index]["uid"].toString())
                                  .setData({
                                "uid": dataList[index]["uid"],
                                "lastMessage": "null",
                                "lastMessageTime": DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                "hasRead": "0",
                                "unreadCount": 0
                              }, merge: true);

                              _firestore
                                  .collection("users")
                                  .document(dataList[index]["uid"].toString())
                                  .collection("chats")
                                  .document(widget.user.uid)
                                  .setData({
                                "uid": widget.user.uid,
                                "lastMessage": "null",
                                "lastMessageTime": DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                "hasRead": "0",
                                "unreadCount": 0
                              }, merge: true);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Chat(
                                          user: widget.user,
                                          peerId:
                                              dataList[index]["uid"].toString(),
                                          username: dataList[index]["username"],
                                        )),
                              );
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 40,
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
          color: Color.fromARGB(255, 255, 141, 52),
        )
      ],
    );
  }
}
