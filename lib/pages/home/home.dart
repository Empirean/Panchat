import 'package:flutter/material.dart';
import 'package:panchat/models/logininfo.dart';
import 'package:panchat/models/users.dart';
import 'package:panchat/pages/home/chats.dart';
import 'package:panchat/pages/home/interactions.dart';
import 'package:panchat/services/database.dart';
import 'package:panchat/styles/headerstyle.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _currentIndex = 0;
  List<String> _title = <String>[
    "Chats",
    "Requests"
  ];
  List<Widget> _widgetList = <Widget>[
    Chats(),
    Interactions(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final loginInfo = Provider.of<LoginInfo>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: FlatButton.icon(
          onPressed: (){
            Navigator.pushNamed(context, "/actions");
          },
          icon: CircleAvatar(
            backgroundColor: Colors.black,
            child: StreamBuilder(
              stream: DatabaseService(path: "people").watchUserInfo(field:"UID", filter: loginInfo.uid),
              builder: (context, AsyncSnapshot<PanchatUser> panchatUser) {
                if (panchatUser.hasData){
                  return Image(
                    image: AssetImage("assets/" + panchatUser.data.image),
                  );
                }
                else{
                  return Image(
                    image: AssetImage("assets/pandi_00.png"),
                  );
                }
              }
            )
          ),
          label: Text(
            _title[_currentIndex],
            style: headerStyle,
          )
        ),
      ),
      body: _widgetList[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        unselectedItemColor: Colors.grey,
        unselectedIconTheme: IconThemeData(
          color: Colors.grey,
        ),
        fixedColor: Colors.white,
        items:[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
            ),
            label: "Chats"
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.contact_mail,
            ),
            label: "People"
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onTap,

      ),
    );
  }
}
