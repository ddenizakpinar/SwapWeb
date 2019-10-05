class User {
  String isim;
  String username;
  String email;
  String uid;
  dynamic url;
 // Map<String, dynamic> toJson() => toJson();
  User({this.isim, this.username, this.email,this.uid,this.url});

  Map<String, dynamic> toJson() {


      return <String,dynamic>{
        "isim": isim,
        "username": username,
        "email": email,
        "uid":uid,
        "url":url
      };
        
      
}}
