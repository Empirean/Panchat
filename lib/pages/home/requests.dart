import 'package:flutter/material.dart';
import 'package:panchat/models/logininfo.dart';
import 'package:panchat/models/users.dart';
import 'package:panchat/services/database.dart';
import 'package:panchat/shared/requestlisttile.dart';
import 'package:panchat/styles/emptyStyle.dart';
import 'package:provider/provider.dart';

class Requests extends StatefulWidget {
  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {

  @override
  Widget build(BuildContext context) {
    final loginInfo = Provider.of<LoginInfo>(context, listen:false);

    return FutureBuilder(
      future: DatabaseService(path: "people").getUserInfo(field: "UID", filter: loginInfo.uid),
      builder: (context, AsyncSnapshot<PanchatUser> userInfo) {

        if (userInfo.hasData) {

          return StreamBuilder(
              stream: DatabaseService(path: "people/" + userInfo.data.id + "/requests").watchAll(),
              builder: (context, requestInfo) {
                if (requestInfo.hasData) {
                  var _request = requestInfo.data.docs;

                  if (_request.length > 0) {

                    return ListView.builder(
                        itemCount: _request.length,
                        itemBuilder: (context, index) {
                          return RequestsListTile(senderId: loginInfo.uid, targetId: _request[index]["UID"],);
                        }
                    );

                  }
                  else {
                    return Center(
                      child: Text("Requests",
                        style: emptyStyle,
                      ),
                    );
                  }

                }
                return Container();
              }
          );
        }
        else{
          return Container();
        }

      },
    );
  }
}
