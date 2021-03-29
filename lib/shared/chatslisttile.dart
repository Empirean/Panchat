import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panchat/services/database.dart';
import 'package:panchat/styles/listtilestyle.dart';

class ChatListTile extends StatelessWidget {

  final String senderId;
  final String targetId;

  ChatListTile({this.senderId, this.targetId});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: DatabaseService(path: "people").watchDocuments(field: "UID", filter: targetId),
      builder: (context, targetInfo) {
        if (targetInfo.hasData){
          var _target = targetInfo.data.docs;

          return GestureDetector(
            onTap: () async {
              QuerySnapshot channelsList1  = await DatabaseService(path: "channels").getDocuments(field: "CHANNEL_ID", filter: senderId + targetId);
              var _channelCheck1 = channelsList1.docs;

              QuerySnapshot channelsList2  = await DatabaseService(path: "channels").getDocuments(field: "CHANNEL_ID", filter: targetId + senderId);
              var _channelCheck2 = channelsList2.docs;

              if (_channelCheck1.length + _channelCheck2.length == 0) {
                Map<String, dynamic> channelInfo = {
                  "CHANNEL_ID" : senderId + targetId,
                };
                DatabaseService(path: "channels").insert(channelInfo);

                Navigator.pushNamed(context, "/messages", arguments: {
                  "CHANNEL_ID" : senderId + targetId,
                  "TITLE" : _target[0]["FIRST_NAME"] + " " + _target[0]["LAST_NAME"],
                });
              }
              else{
                if (_channelCheck1.length > 0) {
                  Navigator.pushNamed(context, "/messages", arguments: {
                    "CHANNEL_ID" : senderId + targetId,
                    "TITLE" : _target[0]["FIRST_NAME"] + " " + _target[0]["LAST_NAME"],
                  });
                }
                if (_channelCheck2.length > 0){
                  Navigator.pushNamed(context, "/messages", arguments: {
                    "CHANNEL_ID" : targetId + senderId,
                    "TITLE" : _target[0]["FIRST_NAME"] + " " + _target[0]["LAST_NAME"],
                  });
                }
              }
            },
            child: Card(
              color: Colors.white,
              child: ListTile(
                title: Text(
                  _target[0]["FIRST_NAME"] + " " + _target[0]["LAST_NAME"],
                  style: listStyle,
                ),
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
}
