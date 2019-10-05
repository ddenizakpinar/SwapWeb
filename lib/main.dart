import 'package:flutter/material.dart';

import 'AppScreens/friend_list.dart';
import 'AppScreens/friend_requests.dart';
import 'AppScreens/main_page.dart';
import 'LoginScreens/forgot_screen.dart';

import 'LoginScreens/login_screen2.dart';

import 'LoginScreens/register_screen2.dart';
import 'firebase.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        'test': (context) => FireStore(),
        'login': (context) => LoginScreen2(),
        'register': (context) => RegisterScreen2(),
        'forgot': (context) => ForgotScreen(),
        'main': (context) => MainPage(),
        'friendRequests': (context) => FriendRequests(),
        'friendList': (context) => FriendList(),
      },

      // initialRoute: 'login',
      initialRoute: 'login',
      //theme: ThemeData(backgroundColor: Colors.red),
    );
  }
}
