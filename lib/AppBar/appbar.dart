import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  MyAppBar({this.title});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0, //?
      title: RichText(
        text: TextSpan(children: <TextSpan>[
          TextSpan(text: "swap", style: TextStyle(color: Colors.white)),
          TextSpan(text: "web", style: TextStyle(color: Colors.red)),
          //TextSpan(text: "chat", style: TextStyle(color: Colors.white,fontSize: 30))
        ], style: TextStyle(fontSize: 28)),
      ),
      backgroundColor: Colors.black,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
