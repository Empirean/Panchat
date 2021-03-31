import 'package:flutter/material.dart';
import 'package:panchat/services/authenticate.dart';
import 'package:panchat/styles/headerstyle.dart';
import 'package:panchat/styles/listtilestyle.dart';

class PanchaActions extends StatefulWidget {
  @override
  _PanchaActionsState createState() => _PanchaActionsState();
}

class _PanchaActionsState extends State<PanchaActions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Actions",
          style: headerStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.account_circle,
                  color: Colors.black,
                ),
                title: Text("Profile",
                  style: listStyle,
                ),
                onTap: (){
                  setState(() {
                    Navigator.pushNamed(context, "/profile");
                  });
                },
              ),
            ),
            Card(
              child: ListTile(
                tileColor: Colors.white70,
                leading: Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                title: Text("Sign out",
                  style: listStyle,
                ),
                onTap: (){
                  setState(() {
                    AuthenticationService().signOut();
                    Navigator.pop(context);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
