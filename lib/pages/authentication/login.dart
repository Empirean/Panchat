import 'package:flutter/material.dart';
import 'package:panchat/services/authenticate.dart';
import 'file:///C:/flutter/panchat/lib/styles/fieldStyle.dart';
import 'package:panchat/styles/buttonstyles.dart';
import 'package:panchat/styles/headerstyle.dart';

class Login extends StatefulWidget {

  final Function toggleView;
  Login({this.toggleView });

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String _username = "";
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
          child: Text('Login',
            style: headerStyle,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.app_registration),
            onPressed: () {
              setState(() {
                widget.toggleView();
              });
            }
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 20,),
            TextFormField(
              cursorColor: Colors.black,
              validator: (val) {
                return val.isEmpty ? 'enter an email' : null ;
              },
              decoration: fieldStyle.copyWith(
                hintText: "email",
              ),
              onChanged: (val) {
                setState(() {
                  _username = val;
                });
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              cursorColor: Colors.black,
              validator: (val){
                return val.length > 6 ? null : 'must be longer than 6 characters';
              },
              obscureText: true,
              decoration: fieldStyle.copyWith(
                hintText: "password"
              ),
              onChanged: (val) {
                setState(() {
                  _password = val;
                });
              },
            ),
            Text(_errorText),
            ButtonTheme(
              buttonColor: Colors.black,
              minWidth: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15),
              child: RaisedButton(
                child: Text('Login',
                  style: buttonLabel,
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()){
                    dynamic _result = await AuthenticationService().signInEmail(_username, _password);
                    setState(() {
                      _errorText = _result;
                    });
                  }
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
