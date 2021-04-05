import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panchat/models/users.dart';
import 'package:panchat/services/database.dart';
import 'package:panchat/styles/listtilestyle.dart';

class RequestsListTile extends StatelessWidget {

  final String senderId;
  final String targetId;

  RequestsListTile({this.senderId, this.targetId});

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: DatabaseService(path: "people").getUserInfo(field: "UID", filter: senderId),
      builder: (context, AsyncSnapshot<PanchatUser> userInfo) {
        if (userInfo.hasData) {

          return FutureBuilder(
            future: DatabaseService(path: "people/" + userInfo.data.id + "/requests").getDocuments(field: "UID", filter: targetId),
            builder: (context, requestInfo) {
              if (requestInfo.hasData) {
                var _requestInfo = requestInfo.data.docs;
                return StreamBuilder(
                  stream: DatabaseService(path: "people").watchUserInfo(field: "UID", filter: targetId),
                  builder: (context, AsyncSnapshot<PanchatUser> targetInfo) {
                    if (targetInfo.hasData) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.black,
                            child: Image(
                              image: AssetImage("assets/${targetInfo.data.image}"),
                            ),
                          ),
                          title: Text("${targetInfo.data.firstName} ${targetInfo.data.lastName}",
                            style: listStyle,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RaisedButton(
                                color: Colors.black,
                                child: Text(
                                  "Reject",
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                                onPressed: () async {
                                  DatabaseService(path: "people/" + userInfo.data.id + "/requests").delete(_requestInfo[0].id);
                                },
                              ),
                              SizedBox(width: 5,),
                              RaisedButton(
                                color: Colors.black,
                                child: Text(
                                    "Accept",
                                    style: TextStyle(
                                        color: Colors.white
                                    )
                                ),
                                onPressed: () async {

                                  Map<String, dynamic> senderData = {
                                    "UID" : targetId
                                  };

                                  Map<String, dynamic> targetData = {
                                    "UID" : senderId
                                  };

                                  DatabaseService(path: "people/" + userInfo.data.id + "/friends").insert(senderData);
                                  DatabaseService(path: "people/" + targetInfo.data.id + "/friends").insert(targetData);

                                  DatabaseService(path: "people/" + userInfo.data.id + "/requests").delete(_requestInfo[0].id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    else{
                      return Container();
                    }

                  }
                );

              }
              else{
                return Container();
              }
            },
          );
        }
        else{
          return Container();
        }
      }
    );
  }
}
