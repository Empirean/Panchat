import 'package:flutter/material.dart';
import 'package:panchat/pages/home/people.dart';
import 'package:panchat/pages/home/requests.dart';

class Interactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black12,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
            backgroundColor: Colors.black,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(icon: Icon(Icons.email),),
                Tab(icon: Icon(Icons.people),),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Requests(),
            People()
          ],
        ),
      ),
    );
  }
}
