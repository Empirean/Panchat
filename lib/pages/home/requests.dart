import 'package:flutter/material.dart';
import 'package:panchat/models/users.dart';
import 'package:panchat/services/database.dart';
import 'package:panchat/shared/requestlisttile.dart';
import 'package:provider/provider.dart';

class Requests extends StatefulWidget {
  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {

  @override
  Widget build(BuildContext context) {
    final panchatUser = Provider.of<PanchatUser>(context, listen:false);

    return FutureBuilder(
      future: DatabaseService(path: "people").getDocuments(field: "UID", filter: panchatUser.uid),
      builder: (context, userInfo) {

        if (userInfo.hasData) {
          var _user = userInfo.data.docs;

          return StreamBuilder(
              stream: DatabaseService(path: "people/" + _user[0].id + "/requests").watchAll(),
              builder: (context, requestInfo) {
                if (requestInfo.hasData) {
                  var _request = requestInfo.data.docs;

                  if (_request.length > 0) {

                    return ListView.builder(
                        itemCount: _request.length,
                        itemBuilder: (context, index) {
                          return RequestsListTile(senderId: panchatUser.uid, targetId: _request[index]["UID"],);
                        }
                    );

                  }
                  else {
                    return Center(
                      child: Text("Requests"),
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
