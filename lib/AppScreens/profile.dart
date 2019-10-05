import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swapweb_chat/AppBar/appbar.dart';
import 'package:swapweb_chat/AppBar/drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Profile extends StatefulWidget {
  FirebaseUser user;
  String id;
  Profile({this.user, this.id});
  bool progressBar = true;

  @override
  _ProfileState createState() => _ProfileState(id: id, user: user);
}

class _ProfileState extends State<Profile> {
  bool progress2 = true;
  List<String> friendList = [];
  List<List<DocumentSnapshot>> list = [];
  var list2 = [];
  FirebaseUser user;
  String id;
  _ProfileState({this.user, this.id});
  @override
  void initState() {
    super.initState();
    _firestore
        .collection("users")
        .document(id.toString())
        .get()
        .then((onValue) {
      setState(() {
        ds = onValue;
        diziyeAt();

        debugPrint(id.toString() + "dd");
      });
      setState(() {
        widget.progressBar = false;
      });
    });
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DocumentSnapshot ds;

  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white, //?
      drawer: MyDrawer(
        user: user, //ds["username"] vs.
      ),
      /*appBar: AppBar(
        title: Text("csd"),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),*/
      body: Stack(
        children: <Widget>[
          Container(
            color: Color.fromARGB(255, 12, 12, 12),
            height: height,
            child: list2.length == 0
                ? Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 255, 141, 52)),
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) {
                      //return Text(list[index][0].data["content"]);
                      //return Text("aaa");

                      return postCard(index, width, height);
                    },
                    itemCount: list2.length,
                  ),
          ),
        ],
      ),
    );
  }

  diziyeAt() async {
    list2.clear();
    list.clear();
    friendList.clear();
    setState(() {});

    debugPrint("id: " + id.toString());

    await _firestore
        .collection("users")
        .document(id.toString())
        .collection("posts") // orderby limit
        .getDocuments()
        .then((onValue) {
      list.add(onValue.documents);
    });

    for (var i in list) {
      for (var c in i) {
        var d =
            await _firestore.collection("users").document(id.toString()).get();
        c.data["email"] = d.data["email"];
        c.data["username"] = d.data["username"];
        list2.add(c.data);
        debugPrint(c.data.toString());
      }
    }

    //debugPrint(list2[3]["content"]);

    setState(() {
      progress2 = false;
    });
  }

  Widget postCard(int index, width, height) {
    int intTime = int.parse(list2[index]["timestamp"]);
    DateTime datee = new DateTime.fromMillisecondsSinceEpoch(intTime);
/*AppBar(
            title: Text(
              "Profile",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 1000.0,
          ),*/
    if (index == 0) {
      return Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: height / (100 / 50),
                    width: width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(ds['url']), fit: BoxFit.fill),
                    ),
                    child: Container(
                        color: Colors.black.withAlpha(220),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: height / (100 / 8),
                            ),
                            CircleAvatar(
                              radius: 65,
                              child: ClipOval(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Image.network(
                                  ds['url'],
                                  width: 130,
                                  height: 130,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    ds['isim'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      ds['status'],
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  width: width / 3,
                                  //follower
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        ds['friendCount'].toString(),
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 141, 52)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          "FRIENDS",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                      255, 255, 141, 52)
                                                  .withAlpha(160),
                                              fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: width / 3,
                                  //friend
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        ds['friendCount'].toString(),
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 141, 52)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          "FOLLOWERS",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                      255, 255, 141, 52)
                                                  .withAlpha(160),
                                              fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: width / 3,
                                  //fav
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        ds['friendCount'].toString(),
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 141, 52)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          "TOTAL LIKES",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                      255, 255, 141, 52)
                                                  .withAlpha(160),
                                              fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                  ),
                ],
              ),
              AppBar(
                title: Text(
                  "Profile",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 141, 52),
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
            ],
          ),
          Material(
            color: Color.fromARGB(255, 12, 12, 12),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.0),
                        color: Colors.white),
                    child: Column(
                      children: <Widget>[
                        /*Text(list2[index]["content"] + " index :" + index.toString()),
                                    Text(list2[index]["i"]),
                                    Text(list2[index]["email"]),*/
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  debugPrint(list2[index]["uid"].toString() +
                                      "tıklandı");
                                },
                                child: Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      // BURASI PHOTO URL
                                      child: Material(
                                        child: ds['url'] != null
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
                                                  width: 500.0,
                                                  height: 500.0,
                                                  padding: EdgeInsets.all(15.0),
                                                ),
                                                imageUrl: ds['url'],
                                                width: 500.0,
                                                height: 500.0,
                                                fit: BoxFit.cover,
                                              )
                                            : Icon(
                                                Icons.account_circle,
                                                size: 50.0,
                                                color: Colors.grey,
                                              ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.0)),
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                      ),
                                      backgroundColor: Colors.white,
                                      radius: 25,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            ds["isim"],
                                            style: TextStyle(fontSize: 22),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            date(datee),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black45),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                          child: Center(child: content(list2, index)),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }

    return Material(
      color: Color.fromARGB(255, 12, 12, 12),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.0),
                  color: Colors.white),
              child: Column(
                children: <Widget>[
                  /*Text(list2[index]["content"] + " index :" + index.toString()),
                                    Text(list2[index]["i"]),
                                    Text(list2[index]["email"]),*/
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            debugPrint(
                                list2[index]["uid"].toString() + "tıklandı");
                          },
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                // BURASI PHOTO URL
                                child: Material(
                                  child: ds['url'] != null
                                      ? CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Container(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1.0,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.red),
                                            ),
                                            width: 500.0,
                                            height: 500.0,
                                            padding: EdgeInsets.all(15.0),
                                          ),
                                          imageUrl: ds['url'],
                                          width: 500.0,
                                          height: 500.0,
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(
                                          Icons.account_circle,
                                          size: 50.0,
                                          color: Colors.grey,
                                        ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0)),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                ),
                                backgroundColor: Colors.white,
                                radius: 25,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      ds["isim"],
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      date(datee),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black45),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: Center(child: content(list2, index)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Text content(list2, index) {
    String content = list2[index]["content"];
    /* if (content.length > 200) {
      return Text(content.substring(0, 260));
    }*/

    return Text(content);
  }
//HEE
/*Container(
        color: Colors.grey.withAlpha(50),
        child: Center(
          child: widget.progressBar == true
              ? CircularProgressIndicator(
                  strokeWidth: 1.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red))
              : Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.bottomCenter,
                          overflow: Overflow.visible,
                          fit: StackFit.passthrough,
                          children: <Widget>[
                            Container(
                              height: height / (100 / 20),
                              width: width,
                              color: Colors.black,
                            ),
                            Positioned(
                              top: height / 14,
                              child: CircleAvatar(
                                child: Material(
                                  child: ds['url'] != null
                                      ? CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Container(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1.0,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.red),
                                            ),
                                            width: 500.0,
                                            height: 500.0,
                                            padding: EdgeInsets.all(15.0),
                                          ),
                                          imageUrl: ds['url'],
                                          width: 500.0,
                                          height: 500.0,
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(
                                          Icons.account_circle,
                                          size: 170,
                                          color: Colors.grey,
                                        ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0)),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                backgroundColor: Colors.black,
                                radius: 80,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height / (100 / 13),
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              ds["isim"],
                              style:
                                  TextStyle(fontSize: 32, color: Colors.black),
                            ),
                            Text(
                              ds["username"],
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),*/

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

  Future favAdd(list2) async {
    List<dynamic> lll = List<dynamic>();
    debugPrint("fonk ici" + list2["docID"]);
    debugPrint("list?" + list2["favs"].toString());
    lll.addAll(list2["favs"]);
    if (lll.contains(user.uid.toString())) {
    } else {
      lll.add(user.uid.toString());
    }

    await _firestore
        .collection("users")
        .document(list2["uid"].toString())
        .collection("posts")
        .document(list2["docID"].toString())
        .setData({"favs": lll}, merge: true).then((onValue) {
      debugPrint("eklenmiştir inş");
    });
    setState(() {});
  }

  Future favDel(list2) async {
    List<dynamic> lll = List<dynamic>();
    debugPrint("fonk ici" + list2["docID"]);
    debugPrint("list?" + list2["favs"].toString());
    lll.addAll(list2["favs"]);
    //lll.add(user.uid.toString());
    lll.remove(user.uid.toString());
    await _firestore
        .collection("users")
        .document(list2["uid"].toString())
        .collection("posts")
        .document(list2["docID"].toString())
        .setData({"favs": lll}, merge: true).then((onValue) {
      debugPrint("çıkmıştır inş");
    });
    setState(() {});
  }
}
/*CircleAvatar(
                    child: Material(
                      child: ds['url'] != null
                          ? CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.0,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.red),
                                ),
                                width: 500.0,
                                height: 500.0,
                                padding: EdgeInsets.all(15.0),
                              ),
                              imageUrl: ds['url'],
                              width: 500.0,
                              height: 500.0,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.account_circle,
                              size: 50.0,
                              color: Colors.grey,
                            ),
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    backgroundColor: Colors.red,
                    radius: 25,
                  ),*/
