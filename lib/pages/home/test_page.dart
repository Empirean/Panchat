import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:panchat/models/users.dart';
import 'package:panchat/services/database.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: new StreamBuilder<QuerySnapshot>(
        stream: db.collection("people/oOAqq5cT2RGK3Zz5gdsj/requests")
            //.doc("oOAqq5cT2RGK3Zz5gdsj")
            //.collection("requests")
            .snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            var doc = snapshot.data.docs;
            return new ListView.builder(
              itemCount: doc.length,
              itemBuilder: (context, index) {
                return Text(doc[index].id);
              }
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
