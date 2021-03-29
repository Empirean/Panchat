import 'package:flutter/material.dart';
import 'package:panchat/models/users.dart';
import 'package:panchat/styles/listtilestyle.dart';
import 'package:provider/provider.dart';

class PanchatMessagesListTile extends StatelessWidget {

  final String senderId;
  final String panchatMessage;

  PanchatMessagesListTile({this.senderId, this.panchatMessage});

  @override
  Widget build(BuildContext context) {

    final panchatUser = Provider.of<PanchatUser>(context, listen: false);
    bool isOwned = panchatUser.uid == senderId;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: isOwned ? 3 : 0,
              child: SizedBox(
                width: isOwned ? 30 : 0,
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
                child: SizedBox(
                  width: isOwned ? 0 : 30,
                )
            ),
          ]
        ),
      ],
    );
  }
}
