import 'package:flutter/material.dart';
import 'package:panchat/services/database.dart';
import 'package:panchat/styles/listtilestyle.dart';

class PeopleListTile extends StatefulWidget {

  final String senderId;
  final String targetId;

  PeopleListTile({this.senderId, this.targetId});

  @override
  _PeopleListTileState createState() => _PeopleListTileState();
}

class _PeopleListTileState extends State<PeopleListTile> {


  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: DatabaseService(path: "people").getDocuments(field: "UID", filter: widget.targetId),
        builder: (context, target) {

          if (target.hasData) {

            var targetData = target.data.docs;

            return Card(
              child:Row(
                children: [
                  Expanded(
                    flex: 70,
                    child: ListTile(
                      title: Text(
                        targetData[0]["FIRST_NAME"] + " " + targetData[0]["LAST_NAME"],
                        style: listStyle,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 30,
                      child: StreamBuilder(
                        stream: DatabaseService(path: "people/" + targetData[0].id + "/requests").watchDocuments(field: "UID", filter: widget.senderId),
                        builder: (context, requests) {
                          if (requests.hasData) {

                            var request = requests.data.docs;

                            int requestsCount = request.length;

                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 8.0),
                              child: RaisedButton(
                                  color: Colors.black,
                                  child: Text(
                                    requestsCount == 0 ? "Invite" : "Cancel",
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      if (requestsCount == 0) {

                                        Map<String, dynamic> requestData = {
                                          "UID" : widget.senderId
                                        };

                                        DatabaseService(path: "people/" + targetData[0].id + "/requests").insert(requestData);
                                      }
                                      else {

                                        for (var tempReq in request) {
                                          DatabaseService(path: "people/" + targetData[0].id + "/requests").delete(tempReq.id);
                                        }

                                      }
                                    });
                                  }
                              ),
                            );

                          }
                          else{
                            return Container();
                          }
                        },
                      )
                  ),
                ],
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
