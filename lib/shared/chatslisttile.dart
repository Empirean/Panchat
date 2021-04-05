import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panchat/models/users.dart';
import 'package:panchat/services/database.dart';
import 'package:panchat/styles/listtilestyle.dart';

class ChatListTile extends StatelessWidget {

  final PanchatUser sender;
  final String targetId;

  ChatListTile({this.sender, this.targetId});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: DatabaseService(path: "people").watchUserInfo(field: "UID", filter: targetId),
      builder: (context, AsyncSnapshot<PanchatUser> targetInfo) {

        if (targetInfo.hasData){

          String _title = "${targetInfo.data.firstName} ${targetInfo.data.lastName}";

          return GestureDetector(

            onTap: () async {

              QuerySnapshot channelsList1  = await DatabaseService(path: "channels").getDocuments(field: "CHANNEL_ID", filter: sender.uid + targetId);
              var _channelCheck1 = channelsList1.docs;

              QuerySnapshot channelsList2  = await DatabaseService(path: "channels").getDocuments(field: "CHANNEL_ID", filter: targetId + sender.uid);
              var _channelCheck2 = channelsList2.docs;

              if (_channelCheck1.length + _channelCheck2.length == 0) {
                Map<String, dynamic> channelInfo = {
                  "CHANNEL_ID" : sender.uid + targetId,
                };
                DatabaseService(path: "channels").insert(channelInfo);

                Navigator.pushNamed(context, "/messages", arguments: {
                  "CHANNEL_ID" : sender.uid + targetId,
                  "TITLE" : _title,
                  "SENDER_INFO" : sender,
                  "TARGET_INFO" : targetInfo.data
                });
              }
              else{
                if (_channelCheck1.length > 0) {
                  Navigator.pushNamed(context, "/messages", arguments: {
                    "CHANNEL_ID" : sender.uid + targetId,
                    "TITLE" : _title,
                    "SENDER_INFO" : sender,
                    "TARGET_INFO" : targetInfo.data
                  });
                }
                if (_channelCheck2.length > 0){
                  Navigator.pushNamed(context, "/messages", arguments: {
                    "CHANNEL_ID" : targetId + sender.uid,
                    "TITLE" : _title,
                    "SENDER_INFO" : sender,
                    "TARGET_INFO" : targetInfo.data
                  });
                }
              }
            },
            child: Card(
              color: Colors.white,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Image(
                      image: AssetImage("assets/${targetInfo.data.image}"),
                    ),
                  ),
                ),
                title: Text(
                  _title,
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
