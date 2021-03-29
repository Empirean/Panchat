import 'package:flutter/material.dart';
import 'package:panchat/pages/authentication/login.dart';
import 'package:panchat/pages/authentication/register.dart';

class Swapper extends StatefulWidget {
  @override
  _SwapperState createState() => _SwapperState();
}

class _SwapperState extends State<Swapper> {

  bool toggleView = true;

  void toggle(){
    setState(() {
      toggleView = !toggleView;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (toggleView) {
      return Login(toggleView: toggle,);
    }
    else{
      return Register(toggleView: toggle,);
    }
  }
}
