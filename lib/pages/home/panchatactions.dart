import 'package:flutter/material.dart';
import 'package:panchat/models/logininfo.dart';
import 'package:panchat/models/users.dart';
import 'package:panchat/services/authenticate.dart';
import 'package:panchat/services/database.dart';
import 'package:panchat/styles/headerstyle.dart';
import 'package:panchat/styles/listtilestyle.dart';
import 'package:provider/provider.dart';

class PanchaActions extends StatefulWidget {
  @override
  _PanchaActionsState createState() => _PanchaActionsState();
}

class _PanchaActionsState extends State<PanchaActions> {

  @override
  Widget build(BuildContext context) {
    final loginInfo = Provider.of<LoginInfo>(context, listen: false);
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
              child: StreamBuilder(
                stream: DatabaseService(path: "people").watchUserInfo(field: "UID", filter: loginInfo.uid),
                builder: (context, AsyncSnapshot<PanchatUser> userInfo) {
                  return ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      color: Colors.black,
                    ),
                    title: Text("Profile",
                      style: listStyle,
                    ),
                    onTap: (){
                      setState(() {
                        Navigator.pushNamed(context, "/profile", arguments: {
                          "USER_INFO" : userInfo.data
                        });
                      });
                    },
                  );
                },
              ),
            ),
            Divider(
              height: 10,
              color: Colors.white,
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
                onTap: () async {
                  await AuthenticationService().signOut();
                  Navigator.pop(context);

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
