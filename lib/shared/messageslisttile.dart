import 'package:flutter/material.dart';
import 'package:panchat/models/logininfo.dart';
import 'package:panchat/models/users.dart';
import 'package:panchat/styles/listtilestyle.dart';
import 'package:provider/provider.dart';

class PanchatMessagesListTile extends StatelessWidget {
  final String senderId;
  final String panchatMessage;
  final PanchatUser sender;
  final PanchatUser target;

  PanchatMessagesListTile({this.senderId, this.panchatMessage, this.sender, this.target});

  @override
  Widget build(BuildContext context) {

    final loginInfo = Provider.of<LoginInfo>(context, listen: false);
    bool isOwned = loginInfo.uid == senderId;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: isOwned ? 3 : 0,
              child: isOwned ? SizedBox(
                width: isOwned ? 30 : 0,
              )
                  :
              CircleAvatar(
                backgroundColor: Colors.black,
                child: Image(
                  image: AssetImage("assets/${target.image}"),
                ),
              )
            ),
            Expanded(
              flex: 7,
              child: Card(
                color: isOwned ? Colors.white : Colors.white70,
                child: ListTile(
                  title: Text(
                    panchatMessage,
                    textAlign: isOwned ? TextAlign.right : TextAlign.left,
                    style: listStyle,
                  ),
                ),
              ),
            ),
            Expanded(
                flex: isOwned ? 0 : 3,
                child: isOwned ? CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Image(
                    image: AssetImage("assets/${sender.image}"),
                  ),
                )
                    :
                SizedBox(
                  width: isOwned ? 0 : 30,
                )
            ),
          ]
        ),
      ],
    );
  }
}
