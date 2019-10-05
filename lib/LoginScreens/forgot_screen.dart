import 'package:flutter/material.dart';


class ForgotScreen extends StatelessWidget {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.black,
      //appBar: MyAppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: height / (100 / 20),
            ),
            Text("Welcome to the", style: TextStyle(color: Colors.white)),
            Container(
              height: height / (100 / 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "swap",
                  style: TextStyle(color: Colors.white, fontSize: 50),
                ),
                Text(
                  "web",
                  style: TextStyle(color: Colors.red, fontSize: 50),
                ),
              ],
            ),
            SizedBox(
              height: height / (100 / 8),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                 
                  Container(
                    width: width/(100/80),
                    color: Colors.black,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Email",
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value.length < 5) {
                          return "False";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: height / (100 / 3),
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        debugPrint("Saved");
                        final snackBar =
                            SnackBar(content: Text('Email sent...',style: TextStyle(color: Colors.white),));
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                      }
                    },
                    color: Colors.red,
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child:
                          const Text('Send Mail', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  SizedBox(
                    height: height / (100 / 4),
                  ),
                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
