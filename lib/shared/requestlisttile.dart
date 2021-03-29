import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panchat/services/database.dart';
import 'package:panchat/styles/buttonstyles.dart';
import 'package:panchat/styles/listtilestyle.dart';

class RequestsListTile extends StatelessWidget {

  final String senderId;
  final String targetId;

  RequestsListTile({this.senderId, this.targetId});

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: DatabaseService(path: "people").getDocuments(field: "UID", filter: senderId),
      builder: (context, userInfo) {
        if (userInfo.hasData) {
          var _user = userInfo.data.docs;

          return FutureBuilder(
            future: DatabaseService(path: "people/" + _user[0].id + "/requests").getDocuments(field: "UID", filter: targetId),
            builder: (context, requestInfo) {
              if (requestInfo.hasData) {
                var _requestInfo = requestInfo.data.docs;

                return Card(
                  child:Row(
                    children: [
                      Expanded(
                        flex: 50,
                        child: StreamBuilder(
                          stream: DatabaseService(path: "people").watchDocuments(field: "UID", filter: targetId),
                          builder: (context, targetInfo){

                            if (targetInfo.hasData) {
                              var _target = targetInfo.data.docs;
                              return ListTile(
                                title: Text(
                                  _target[0]["FIRST_NAME"] + " " + _target[0]["LAST_NAME"],
                                  style: listStyle,
                                ),
                              );
                            }
                            else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      Expanded(
                          flex: 25,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.0),
                            child: RaisedButton(
                              color: Colors.black,
                              child: Text(
                                "Reject",
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              ),
                              onPressed: () async {
                                DatabaseService(path: "people/" + _user[0].id + "/requests").delete(_requestInfo[0].id);
                              },
                            ),
                          ),
                      ),
                      Expanded(
                        flex: 25,
                        child: FutureBuilder(
                          future: DatabaseService(path: "people").getDocuments(field: "UID", filter: targetId),
                          builder:(context, targetInfo){

                            if (targetInfo.hasData) {

                              var _target = targetInfo.data.docs;

                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 8.0),
                                child: RaisedButton(
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

                                    DatabaseService(path: "people/" + _user[0].id + "/friends").insert(senderData);
                                    DatabaseService(path: "people/" + _target[0].id + "/friends").insert(targetData);

                                    DatabaseService(path: "people/" + _user[0].id + "/requests").delete(_requestInfo[0].id);
                                  },
                                ),
                              );
                            }
                            else {
                              return Container();
                            }
                          }
                        )
                      ),
                    ],
                  ),
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
