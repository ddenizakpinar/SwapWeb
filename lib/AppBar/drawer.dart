import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swapweb_chat/AppScreens/friend_list.dart';
import 'package:swapweb_chat/AppScreens/friend_requests.dart';
import 'package:swapweb_chat/AppScreens/main_page.dart';
import 'package:swapweb_chat/AppScreens/profile.dart';
import 'package:swapweb_chat/AppScreens/settings.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:swapweb_chat/LoginScreens/login_screen2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget implements PreferredSizeWidget {
  FirebaseUser user;
  MyDrawer({this.user});

  @override
  _MyDrawerState createState() => _MyDrawerState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => null;
}

class _MyDrawerState extends State<MyDrawer> {
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _textFieldController = TextEditingController();
  var requestsCount = 0;
  var photoUrl;
  var email = " ";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
    getRequests();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromARGB(255, 12, 12, 12),
        child: ListView(
          children: <Widget>[
            InkWell(
              onTap: () {
                debugPrint("heyyy");

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(
                      user: widget.user,
                      id: widget.user.uid.toString(),
                    ),
                  ),
                );
              },
              child: DrawerHeader(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 45,
                          child: Material(
                            child: photoUrl != null
                                ? CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.red),
                                      ),
                                      width: 120,
                                      height: 120.0,
                                      padding: EdgeInsets.all(15.0),
                                    ),
                                    imageUrl: photoUrl,
                                    width: 120.0,
                                    height: 120.0,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.account_circle,
                                    size: 118.0,
                                    color: Colors.grey,
                                  ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(60.0)),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            "",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            email,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        )
                      ],
                    )

                    //Text(widget.user.email, style: TextStyle(color: Colors.white))
                  ],
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/mountain.jpg"),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Home",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 141, 52),
                ),
              ),
              leading:
                  Icon(Icons.home, color: Color.fromARGB(255, 255, 141, 52)),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(
                      user: widget.user,
                    ),
                  ),
                );
              },
            ),
            Divider(
              color: Color.fromARGB(255, 255, 141, 52),
              endIndent: 20,
              indent: 20,
            ),
            ListTile(
              title: Text(
                "Friends",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 141, 52),
                ),
              ),
              leading:
                  Icon(Icons.people, color: Color.fromARGB(255, 255, 141, 52)),
              onTap: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FriendList(
                        user: widget.user,
                      ),
                    ),
                  );
                });
              },
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Requests",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 141, 52),
                      )),
                  requestsCount > 0
                      ? CircleAvatar(
                          backgroundColor: Colors.orange, //TODO color
                          radius: 14,
                          child: Text(
                            requestsCount.toString(),
                            style: TextStyle(
                                color: Color.fromARGB(255, 12, 12, 12)),
                          ),
                        )
                      : Text("")
                ],
              ),
              leading: Icon(Icons.notifications,
                  color: Color.fromARGB(255, 255, 141, 52)),
              onTap: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FriendRequests(
                        user: widget.user,
                      ),
                    ),
                  );
                });
              },
            ),
            ListTile(
              title: Text("Find Friends",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 141, 52),
                  )),
              leading: Icon(Icons.person_add,
                  color: Color.fromARGB(255, 255, 141, 52)),
              onTap: () {
                setState(() {
                  friendAddDialog(context);
                });
              },
            ),
            ListTile(
              title: Text("Settings",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 141, 52),
                  )),
              leading: Icon(Icons.settings,
                  color: Color.fromARGB(255, 255, 141, 52)),
              onTap: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Settings(
                        user: widget.user,
                      ),
                    ),
                  );
                });
              },
            ),
            ListTile(
              title: Text("Logout",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 141, 52),
                  )),
              leading: Icon(
                Icons.exit_to_app,
                color: Color.fromARGB(255, 255, 141, 52),
              ),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                setState(() {
                  signout();
                });
              },
            )
          ],
        ),
      ),
    );
  }

  void signout() {
    _auth.signOut();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen2(),
        ),
        (Route<dynamic> route) => false);
    // Navigator.popAndpushReplacementNamed(context, "login");
    // Navigator.pushReplacementReplacementNamed(context, "login");
  }

  friendAddDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Find your friends'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter username"),
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text(
                  'Send Request',
                  style: TextStyle(color: Color.fromARGB(255, 255, 141, 52)),
                ),
                onPressed: () async {
                  if (await userControl(_textFieldController.text)) {
                  } else {
                    debugPrint("username not found");
                  }

                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<bool> userControl(String username) async {
    debugPrint(username);
    DocumentSnapshot ds = await _firestore
        .collection("users")
        .document(widget.user.uid.toString())
        .get();

    var result = await _firestore
        .collection("users")
        .where("username", isEqualTo: username)
        .getDocuments();
  

    for (var i in result.documents) {
      debugPrint("dök" + i.documentID);
      debugPrint("i data: " + i.data.toString());

      if (i.exists) {
        debugPrint("dök" + i.documentID);
        _firestore
            .collection("users")
            .document(i.documentID)
            .collection("friendRequests")
            .document(widget.user.uid)
            .setData(ds.data)
            .then((ss) => debugPrint("sss"));

        return true;
      }
    }
    debugPrint("hey");
    return false;
  }

  Future getRequests() async {
    var ds = await _firestore
        .collection("users")
        .document(widget.user.uid)
        .collection("friendRequests")
        .getDocuments();

    if (this.mounted) {
      setState(() {
        requestsCount = ds.documents.length - 1;
      });
    }
  }

  void getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      photoUrl = prefs.getString("prefsUrl");
      email = prefs.getString("prefsEmail");
    });
    debugPrint("URL HERE" + prefs.getString("prefsUrl"));
  }
}
