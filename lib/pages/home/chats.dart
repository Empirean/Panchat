import 'package:flutter/material.dart';
import 'package:panchat/models/users.dart';
import 'package:panchat/shared/chatslisttile.dart';
import 'package:provider/provider.dart';
import 'package:panchat/services/database.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {

    final panchatUser =  Provider.of<PanchatUser>(context, listen:false);

    return FutureBuilder(
      future: DatabaseService(path: "people").getDocuments(field: "UID", filter: panchatUser.uid),
      builder: (context, userInfo) {
        if (userInfo.hasData){
          var _user = userInfo.data.docs;

          return StreamBuilder(
            stream: DatabaseService(path: "people/" + _user[0].id + "/friends").watchAll(),
            builder: (context, friendsInfo) {

              if (friendsInfo.hasData){
                var _friends = friendsInfo.data.docs;

                return ListView.builder(
                  itemCount: _friends.length,
                  itemBuilder: (context, index){
                    return ChatListTile(senderId: panchatUser.uid, targetId: _friends[index]["UID"],);
                  }
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
      }
    );
  }
}
