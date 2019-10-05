import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapweb_chat/AppBar/appbar.dart';
import 'package:swapweb_chat/AppBar/drawer.dart';
import 'package:swapweb_chat/AppScreens/chat_screen.dart';
import 'package:swapweb_chat/AppScreens/post_share.dart';
import 'package:swapweb_chat/AppScreens/profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:swapweb_chat/AppScreens/search.dart';
import 'friend_list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:swapweb_chat/models/date.dart';

class MainPage extends StatefulWidget {
  FirebaseUser user;

  MainPage({this.user});
  //MainPage({this.isimmail});
  bool loading = false;
  @override
  _MainPageState createState() => _MainPageState(user: user);
}

class _MainPageState extends State<MainPage> {
  String dropdownValue = 'One'; //?
  FirebaseUser user;
  TextEditingController _textEditingController;
  _MainPageState({this.user});
  ScrollController _controller;
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Date dateConverter;
  int bottomSelectedIndex = 0;
  int counter = -1;
  double offset;
  int search = 0;
  List<dynamic> friendList = [];
  List<List<DocumentSnapshot>> list = [];
  List<dynamic> dataList = List<dynamic>();
  List<int> sayi = [];
  int dayCounter = 10;
  FocusNode _focusNode;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  var currentPageValue = 0.0;

  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = new ScrollController();
    _textEditingController = new TextEditingController();
    dateConverter = new Date();
    setState(() {
      diziyeAt(10);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double currentPage = 0;

    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,

        //appBar: MyAppBar(),
        drawer: MyDrawer(
          user: widget.user,
        ),
        bottomNavigationBar: myBottomNavBar(),
        floatingActionButton:
            selectedIndex == 0 ? socialFloating() : chatFloating(),
        body: Container(
          //color: Color.fromARGB(255,12,12,12),
          child: Column(
            children: <Widget>[
              Container(
                child: Flexible(
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: pageController,
                    onPageChanged: (index) {
                      pageChanged(index);
                    },
                    children: <Widget>[
                      homeScreen(width, height),
                      ChatsScreen(user: widget.user)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
      selectedIndex = index;
      debugPrint("yowew" + selectedIndex.toString());
    });
  }

  void bottomTapped(int index) {
    setState(() {
      selectedIndex = index;
      debugPrint("yoww" + selectedIndex.toString());
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  BottomNavigationBar myBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: bottomSelectedIndex,
      onTap: (index) {
        bottomTapped(index);
      },
      //
      //
      selectedItemColor: Colors.black,
      selectedFontSize: 14,

      backgroundColor: Color.fromARGB(245, 12, 12, 12),

      items: [
        BottomNavigationBarItem(
          // backgroundColor: Colors.redAccent,
          icon: Icon(
            Icons.home,
            color: Color.fromARGB(255, 255, 141, 52),
          ),
          title: Text(
            'Home',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 141, 52),
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.mail,
            color: Color.fromARGB(255, 255, 141, 52),
          ),
          title: Text(
            'Messages',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 141, 52),
            ),
          ),
        ),
      ],
    );
  }

  Container homeScreen(double width, double height) {
    return Container(
      color: Color.fromARGB(255, 12, 12, 12),
      child: Center(
        child: Container(
          child: dataList.length == 0
              ? Column(
                  children: <Widget>[
                    AppBar(
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
                                    _textEditingController.text = " ";
                                    search = 0;
                                  });
                                },
                              ),
                      ],
                      title: search == 0
                          ? Text(
                              "Feeds",
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 141, 52),
                              ),
                            )
                          : TextFormField(
                              focusNode: _focusNode,
                              controller: _textEditingController,
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 141, 52),
                              ),
                              cursorColor: Color.fromARGB(255, 255, 141, 52),
                              decoration: InputDecoration(
                                hintText: "Search...",
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
                            ),
                      centerTitle: true,
                      backgroundColor: Color.fromARGB(255, 12, 12, 12),
                    ),
                    SizedBox(
                      height: height / 3,
                    ),
                    Center(
                      child: Container(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 255, 141, 52),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : Container(
                  color: Color.fromARGB(255, 12, 12, 12),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            header: WaterDropHeader(),
                            footer: CustomFooter(
                              builder: (BuildContext context, LoadStatus mode) {
                                Widget body;
                                if (mode == LoadStatus.idle) {
                                  body = Text("pull up load");
                                } else if (mode == LoadStatus.loading) {
                                  body = CupertinoActivityIndicator();
                                } else if (mode == LoadStatus.failed) {
                                  body = Text("Load Failed!Click retry!");
                                } else {
                                  body = Text("No more Data");
                                }
                                return Container(
                                  height: 55.0,
                                  child: Center(child: body),
                                );
                              },
                            ),
                            controller: _refreshController,
                            onRefresh: _onRefresh,
                            onLoading: _onLoading,
                            child: ListView.builder(
                              controller: _controller,
                              itemBuilder: (context, index) {
                                return dataList.length > 0
                                    ? postCard(index, width, height)
                                    : Container();
                              },
                              itemCount: dataList.length,
                            )),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  FloatingActionButton socialFloating() {
    return FloatingActionButton(
      child: Icon(Icons.add_photo_alternate),
      backgroundColor: Color.fromARGB(255, 255, 141, 52),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostShare(
              user: widget.user,
            ),
          ),
        );
      },
    );
  }

  FloatingActionButton chatFloating() {
    return FloatingActionButton(
      child: Icon(Icons.chat),
      backgroundColor: Color.fromARGB(255, 255, 141, 52),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FriendList(
              user: widget.user,
            ),
          ),
        );
      },
    );
  }

  Widget postCard(int index, width, height) {
    int intTime = int.parse(dataList[index]["timestamp"]);
    DateTime datee = new DateTime.fromMillisecondsSinceEpoch(intTime);

    if (index == 0) {
      return Column(
        children: <Widget>[
          AppBar(
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
            title: search == 0
                ? Text(
                    "Feeds",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 141, 52),
                    ),
                  )
                : TextFormField(
                    focusNode: _focusNode,
                    controller: _textEditingController,
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 141, 52),
                    ),
                    cursorColor: Color.fromARGB(255, 255, 141, 52),
                    decoration: InputDecoration(
                      hintText: "Search...",
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchScreen(
                            user: widget.user,
                            text: _textEditingController.text,
                          ),
                        ),
                      );
                    },
                  ),
            centerTitle: true,
            backgroundColor: Color.fromARGB(255, 12, 12, 12),
          ),
          Container(
            color: Color.fromARGB(255, 12, 12, 12),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: Colors.white),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              debugPrint(dataList[index]["uid"].toString() +
                                  "tıklandı");

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Profile(
                                            user: user,
                                            id: dataList[index]["uid"]
                                                .toString(),
                                          )));
                            },
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  child: Material(
                                    child: dataList[index]['url'] != null
                                        ? CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                Container(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1.0,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.red),
                                              ),
                                              width: 50.0,
                                              height: 50.0,
                                              padding: EdgeInsets.all(15.0),
                                            ),
                                            imageUrl: dataList[index]['url'],
                                            width: 50.0,
                                            height: 50.0,
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
                                        dataList[index]["username"],
                                        style: TextStyle(fontSize: 22),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        //dateConverter.dateConvert(datee),
                                        dateConvert(datee),
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
                        child: Center(
                          child: Text(dataList[index]["content"]),
                        )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 70, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              if ((dataList[index]["fav"] == 1)) {
                                debugPrint("zaten var");

                                setState(() {
                                  favDel(dataList[index]);
                                  dataList[index]["fav"] = 0;
                                  dataList[index]["favCount"] -= 1;
                                });
                              } else {
                                debugPrint("yok");
                                setState(() {
                                  favAdd(dataList[index]);
                                  dataList[index]["fav"] = 1;
                                  dataList[index]["favCount"] += 1;
                                });
                              }
                            },
                            child: Container(
                              //  color: Colors.grey.withAlpha(1), //BUNU DUZELT DÜZELT
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    (dataList[index]["favCount"]).toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 255, 141, 52),
                                    ),
                                  ),
                                  dataList[index]["fav"] == 1
                                      ? Icon(
                                          Icons.favorite,
                                          color: Colors.deepOrange,
                                          size: 34,
                                        )
                                      : Icon(
                                          Icons.favorite_border,
                                          color:
                                              Color.fromARGB(255, 255, 141, 52),
                                          size: 34,
                                        )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: <Widget>[
        Container(
          color: Color.fromARGB(255, 12, 12, 12),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.white),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            debugPrint(
                                dataList[index]["uid"].toString() + "tıklandı");

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile(
                                          user: user,
                                          id: dataList[index]["uid"].toString(),
                                        )));
                          },
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                child: Material(
                                  child: dataList[index]['url'] != null
                                      ? CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              Container(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 1.0,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.red),
                                            ),
                                            width: 50.0,
                                            height: 50.0,
                                            padding: EdgeInsets.all(15.0),
                                          ),
                                          imageUrl: dataList[index]['url'],
                                          width: 50.0,
                                          height: 50.0,
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
                                      dataList[index]["username"],
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      //dateConverter.dateConvert(datee),
                                      dateConvert(datee),
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
                      child: Center(
                        child: Text(dataList[index]["content"]),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 70, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            if ((dataList[index]["fav"] == 1)) {
                              debugPrint("zaten var");

                              setState(() {
                                favDel(dataList[index]);
                                dataList[index]["fav"] = 0;
                                dataList[index]["favCount"] -= 1;
                              });
                            } else {
                              debugPrint("yok");
                              setState(() {
                                favAdd(dataList[index]);
                                dataList[index]["fav"] = 1;
                                dataList[index]["favCount"] += 1;
                              });
                            }
                          },
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  (dataList[index]["favCount"]).toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 255, 141, 52),
                                  ),
                                ),
                                dataList[index]["fav"] == 1
                                    ? Icon(
                                        Icons.favorite,
                                        color: Colors.deepOrange,
                                        size: 34,
                                      )
                                    : Icon(
                                        Icons.favorite_border,
                                        color:
                                            Color.fromARGB(255, 255, 141, 52),
                                        size: 34,
                                      )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  diziyeAt(int negaDay) async {
    dataList.clear();
    list.clear();
    friendList.clear();
    //setState(() {});

    await _firestore
        .collection("users")
        .document(user.uid.toString())
        .get()
        .then((onValue) {
      friendList.addAll(onValue["friends"]);
    });
    Duration day = new Duration(days: negaDay);

    var time = DateTime.now().millisecondsSinceEpoch - day.inMilliseconds;

    for (var friend in friendList) {
      // debugPrint(friend);
      await _firestore
          .collection("users")
          .document(friend.toString())
          .collection("posts")
          .where("timestamp", isGreaterThan: time.toString()) // orderby limit
          .getDocuments()
          .then((onValue) {
        list.add(onValue.documents);
      });
    }

    try {
      for (var i in list) {
        for (var c in i) {
          String refID = c.data["ref"];

          var d = await _firestore
              .collection("users")
              .document(refID.toString())
              .get();

          c.data["email"] = d.data["email"];
          c.data["username"] = d.data["username"];
          c.data["uid"] = d.data["uid"];
          c.data["url"] = d.data["url"];
          List<dynamic> newList = List<dynamic>();
          newList = c.data["favs"];
          List<dynamic> lll2 = List<dynamic>();

          c.data["favCount"] = newList.length - 1;

          lll2.addAll(c.data["favs"]);

          c.data["docID"] = c.documentID.toString();
          if (lll2.contains(user.uid.toString())) {
            c.data["fav"] = 1;
          } else {
            c.data["fav"] = 0;
          }
          dataList.add(c.data);
        }
      }
    } catch (e) {}

    dataList.sort((m1, m2) {
      var r = m2["timestamp"].compareTo(m1["timestamp"]);
      if (r != 0) return r;
      return m2["timestamp"].compareTo(m1["timestamp"]);
    });

    try {
      setState(() {});
    } catch (e) {
      debugPrint(e.toString() + "buggggg");
    }
  }

  RaisedButton loadMoreButton() {
    return RaisedButton(
      onPressed: () {
        dayCounter += 10;
        diziyeAt(dayCounter);
      },
      child:
          Text((dayCounter + 10).toString() + "'dan önceki mesajları göster."),
    );
  }

  Future favAdd(dataList) async {
    List<dynamic> favList = List<dynamic>();
    debugPrint("fonk ici" + dataList["docID"]);
    debugPrint("list?" + dataList["favs"].toString());
    favList.addAll(dataList["favs"]);
    if (favList.contains(user.uid.toString())) {
    } else {
      favList.add(user.uid.toString());
    }

    await _firestore
        .collection("users")
        .document(dataList["uid"].toString())
        .collection("posts")
        .document(dataList["docID"].toString())
        .setData({"favs": favList}, merge: true).then((onValue) {});
    setState(() {});
  }

  Future favDel(dataList) async {
    List<dynamic> favList = List<dynamic>();
    debugPrint("fonk ici" + dataList["docID"]);
    debugPrint("list?" + dataList["favs"].toString());
    favList.addAll(dataList["favs"]);
    //favList.add(user.uid.toString());
    favList.remove(user.uid.toString());
    await _firestore
        .collection("users")
        .document(dataList["uid"].toString())
        .collection("posts")
        .document(dataList["docID"].toString())
        .setData({"favs": favList}, merge: true).then((onValue) {});
    setState(() {});
  }

  String dateConvert(DateTime tm) {
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

  void _onRefresh() async {
    // monitor network fetch
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    await diziyeAt(dayCounter);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch

    dayCounter += 10;
    await diziyeAt(dayCounter);
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }
}
