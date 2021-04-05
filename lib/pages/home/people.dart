import 'package:flutter/material.dart';
import 'package:panchat/models/logininfo.dart';
import 'package:panchat/services/database.dart';
import 'package:panchat/models/users.dart';
import 'package:panchat/shared/peoplelisttile.dart';
import 'package:panchat/styles/emptyStyle.dart';
import 'package:provider/provider.dart';

class People extends StatefulWidget {
  @override
  _PeopleState createState() => _PeopleState();
}

class _PeopleState extends State<People> {

  List<String> filterList = new List<String>();

  @override
  Widget build(BuildContext context) {
    final loginInfo = Provider.of<LoginInfo>(context, listen: false);

    filterList.clear();
    filterList.add(loginInfo.uid);

    return FutureBuilder(
          future: DatabaseService(path: "people").getUserInfo(field: "UID", filter: loginInfo.uid),
          builder: (context, AsyncSnapshot<PanchatUser> userInfo){
            if (userInfo.hasData) {

              return StreamBuilder(

                stream: DatabaseService(path: "people/" + userInfo.data.id + "/friends").watchAll(),
                builder: (context, friendsInfo){

                  if (friendsInfo.hasData) {

                    var _friends = friendsInfo.data.docs;

                    for (var friendId in _friends) {
                      filterList.add(friendId["UID"]);
                    }

                    return StreamBuilder(
                      stream: DatabaseService(path: "people").watchAll(),
                      builder: (context, peopleInfo) {
                        if (peopleInfo.hasData) {
                          var _peopleInfo = peopleInfo.data.docs;
                          List<String> peopleList = new List<String>();

                          for (var people in _peopleInfo) {
                            peopleList.add(people["UID"]);
                          }

                          for (var filter in filterList) {
                            peopleList.remove(filter);
                          }

                          if (peopleList.length > 0) {
                            return ListView.builder(
                                itemCount: peopleList.length,
                                itemBuilder: (context, index) {
                                  return PeopleListTile(senderId: loginInfo.uid ,targetId: peopleList[index],);
                                }
                            );
                          }
                          else {
                            return Center(
                              child: Text("People",
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
            else {
              return Container();
            }
          },
    );
  }
}
