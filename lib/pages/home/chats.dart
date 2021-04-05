import 'package:flutter/material.dart';
import 'package:panchat/models/logininfo.dart';
import 'package:panchat/models/users.dart';
import 'package:panchat/shared/chatslisttile.dart';
import 'package:panchat/styles/emptyStyle.dart';
import 'package:provider/provider.dart';
import 'package:panchat/services/database.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    final loginInfo = Provider.of<LoginInfo>(context, listen: false);

    return FutureBuilder(
      future: DatabaseService(path: "people").getUserInfo(field: "UID", filter: loginInfo.uid),
      builder: (context, AsyncSnapshot<PanchatUser> panchatUser) {
        if (panchatUser.hasData) {

          return StreamBuilder(
              stream: DatabaseService(path: "people/${panchatUser.data.id}/friends").watchAll(),
              builder: (context, friendsInfo) {

                if (friendsInfo.hasData){
                  var _friends = friendsInfo.data.docs;

                  if (_friends.length > 0) {
                    return ListView.builder(
                        itemCount: _friends.length,
                        itemBuilder: (context, index){
                          return ChatListTile(sender: panchatUser.data, targetId: _friends[index]["UID"],);
                        }
                    );
                  }
                  else{
                    return Center(
                      child: Text("Chats",
                        style: emptyStyle,
                      ),
                    );
                  }
                }
                else{
                  return Container();
                }
              }
          );
        }
        else {
          return Container();
        }
      },

    );
  }
}
