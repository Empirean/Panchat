import 'package:flutter/material.dart';
import 'package:panchat/models/logininfo.dart';
import 'package:panchat/models/users.dart';
import 'package:panchat/services/database.dart';
import 'package:panchat/shared/messageslisttile.dart';
import 'package:panchat/styles/fieldStyle.dart';
import 'package:panchat/styles/headerstyle.dart';
import 'package:provider/provider.dart';

class PanchatMessages extends StatefulWidget {
  @override
  _PanchatMessagesState createState() => _PanchatMessagesState();
}

class _PanchatMessagesState extends State<PanchatMessages> {

  Map _channelInfo = {};
  String _channelId;
  String _title;
  PanchatUser _sender;
  PanchatUser _target;

  @override
  Widget build(BuildContext context) {

    final loginInfo = Provider.of<LoginInfo>(context, listen: false);

    final _controller = TextEditingController();
    final _scrollController = ScrollController();


    _channelInfo = ModalRoute.of(context).settings.arguments;

    if (_channelInfo != null){
      _channelId = _channelInfo["CHANNEL_ID"];
      _title = _channelInfo["TITLE"];
      _sender = _channelInfo["SENDER_INFO"];
      _target = _channelInfo["TARGET_INFO"];
    }

    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          _title,
          style: headerStyle,
        ),
      ),
      body: FutureBuilder(
          future: DatabaseService(path: "channels").getDocuments(field: "CHANNEL_ID", filter: _channelId),
          builder: (context, channelKey){
            if (channelKey.hasData){
              var _channelKey = channelKey.data.docs;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 9,
                    child: StreamBuilder(
                      stream: DatabaseService(path: "channels/" + _channelKey[0].id + "/messages").watchAndSortAll(field: "DATE_SENT"),
                      builder: (context, messageInfo){
                        if (messageInfo.hasData) {
                          var _messages = messageInfo.data.docs;
                          return ListView.builder(
                            controller: _scrollController,
                            itemCount: _messages.length,
                            itemBuilder: (context, index){
                              WidgetsBinding.instance.addPostFrameCallback((_) {_scrollController.jumpTo(_scrollController.position.maxScrollExtent);});
                              return PanchatMessagesListTile(
                                panchatMessage:  _messages[index]["MESSAGE"],
                                senderId:  _messages[index]["SENDER_ID"],
                                sender: _sender,
                                target: _target,
                              );
                            }
                          );
                        }
                        else{
                          return Container();
                        }
                      }
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (val){

                          String panchatMessage = val.trim();

                          if (panchatMessage.length > 0) {
                            Map<String, dynamic> messageData = {
                              "MESSAGE" : panchatMessage,
                              "SENDER_ID" : loginInfo.uid,
                              "DATE_SENT" : DateTime.now(),
                            };
                            DatabaseService(path: "channels/" + _channelKey[0].id + "/messages").insert(messageData);

                          }
                          setState(() {
                            _controller.clear();
                          });
                        },
                        decoration: fieldStyle.copyWith(hintText: "message"),
                      ),
                    ),
                  )
                ],
              );
            }
            else{
              return Container();
            }
          },
        ),
    );
  }
}
