import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panchat/models/users.dart';
import 'package:panchat/services/authenticate.dart';
import 'package:panchat/services/database.dart';
import 'package:panchat/styles/buttonstyles.dart';
import 'package:panchat/styles/fieldStyle.dart';
import 'package:panchat/styles/headerstyle.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String _firstName = "";
  String _lastName = "";
  String _errorText = "";
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    final pachatUser = Provider.of<PanchatUser>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Profile",
          style: headerStyle,
        ),
      ),
      body: FutureBuilder(
        future: DatabaseService(path: "people").getDocuments(field: "UID", filter: pachatUser.uid),
        builder: (context, userInfo){


          if (userInfo.hasData) {
            var _user = userInfo.data.docs;

            _firstName = _user[0]["FIRST_NAME"];
            _lastName = _user[0]["LAST_NAME"];
            _firstnameController.text = _firstName;
            _lastnameController.text = _lastName;

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _firstnameController,
                      cursorColor: Colors.black,
                      validator: ((val) {
                        return val.isEmpty ? "enter first name" : null;
                      }
                      ),
                      onChanged: (val) {
                        _firstName = val;
                      },
                      decoration: fieldStyle.copyWith(
                        hintText: "first name",
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: _lastnameController,
                      cursorColor: Colors.black,
                      validator: ((val) {
                        return val.isEmpty ? "enter last name" : null;
                      }
                      ),
                      onChanged: (val) {
                        _lastName = val;
                      },
                      decoration: fieldStyle.copyWith(
                          hintText: "last name"
                      ),
                    ),
                    Text(_errorText),
                    ButtonTheme(
                      minWidth: double.infinity,
                      buttonColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: RaisedButton(
                          child: Text(
                            "Update",
                            style: buttonLabel,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()){
                              Map<String, dynamic> userUpdate = {
                                "FIRST_NAME" : _firstName,
                                "LAST_NAME" : _lastName,
                              };

                              await DatabaseService(path: "people").update(userUpdate, _user[0].id);
                              Navigator.pop(context);
                            }
                          }
                      ),
                    )
                  ],
                ),
              ),
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
