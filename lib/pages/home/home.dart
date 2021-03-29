import 'package:flutter/material.dart';
import 'package:panchat/pages/home/chats.dart';
import 'package:panchat/pages/home/requests.dart';
import 'package:panchat/services/authenticate.dart';
import 'package:panchat/styles/headerstyle.dart';

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
    Requests(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          _title[_currentIndex],
          style: headerStyle,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              setState(() {
                AuthenticationService().signOut();
              });
            }
          )
        ],
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
              Icons.email,
            ),
            label: "Requests"
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onTap,

      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.find_in_page),
        onPressed: () {
          Navigator.pushNamed(context, "/people");
        },
      ),
    );
  }
}
