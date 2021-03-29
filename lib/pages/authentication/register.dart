import 'package:flutter/material.dart';
import 'package:panchat/services/authenticate.dart';
import 'package:panchat/styles/buttonstyles.dart';
import 'package:panchat/styles/fieldStyle.dart';
import 'package:panchat/styles/headerstyle.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({ this.toggleView });
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  String _firstName = "";
  String _lastName = "";
  String _email = "";
  String _password = "";
  String _errorText = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text("Register",
            style: headerStyle,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.login),
            onPressed: (){
              setState(() {
                widget.toggleView();
              });
            }
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              TextFormField(
                cursorColor: Colors.black,
                validator: ((val) {
                    return val.isEmpty ? "enter an email" : null;
                  }
                ),
                onChanged: (val) {
                  setState(() {
                    _email = val;
                  });
                },
                decoration: fieldStyle.copyWith(
                  hintText: "email"
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                cursorColor: Colors.black,
                validator: ((val) {
                    return val.length > 6 ? null : "must be longer than 6 characters";
                  }
                ),
                onChanged: (val) {
                  setState(() {
                    _password = val;
                  });
                },
                obscureText: true,
                decoration: fieldStyle.copyWith(
                  hintText: "password"
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                cursorColor: Colors.black,
                validator: ((val) {
                    return val == _password ? null : "password does not match";
                  }
                ),
                obscureText: true,
                decoration: fieldStyle.copyWith(
                  hintText: "confirm password",
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
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
                    "Register",
                    style: buttonLabel,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()){
                      dynamic result = AuthenticationService().signUpEmail(_email, _password, _firstName, _lastName);

                      setState(() {
                        if (result is String)
                        {
                          _errorText = result;
                        }
                      });
                    }
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
