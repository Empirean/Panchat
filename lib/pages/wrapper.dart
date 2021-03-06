import 'package:flutter/material.dart';
import 'package:panchat/models/logininfo.dart';
import 'package:panchat/pages/authentication/login.dart';
import 'package:panchat/models/users.dart';
import 'package:panchat/pages/authentication/swapper.dart';
import 'file:///C:/flutter/panchat/lib/pages/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {

    final loginInfo = Provider.of<LoginInfo>(context);

    if (loginInfo != null){
      return Home();
    }
    else{
      return Swapper();
    }

  }
}
