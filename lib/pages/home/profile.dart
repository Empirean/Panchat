import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panchat/models/users.dart';
import 'package:panchat/services/database.dart';
import 'package:panchat/shared/stickerlist.dart';
import 'package:panchat/styles/buttonstyles.dart';
import 'package:panchat/styles/emptyStyle.dart';
import 'package:panchat/styles/fieldStyle.dart';
import 'package:panchat/styles/headerstyle.dart';

class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {



  String _errorText = "";

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String _image = "pandi_00.png";

  PanchatUser _panchatUser;
  Map _data = {};

  @override
  void initState() {

    Future.delayed(Duration.zero,() {
      _data = ModalRoute.of(context).settings.arguments;
      if (_data != null){
        _panchatUser = _data["USER_INFO"];

        setState(() {
          _firstNameController.text = _panchatUser.firstName;
          _lastNameController.text = _panchatUser.lastName;
          _image = _panchatUser.image;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Profile",
          style: headerStyle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  AlertDialog alertDialog = AlertDialog(
                    backgroundColor: Colors.black87,
                    title: Text("Select Avatar",
                      style: emptyStyle,
                    ),
                    content: StatefulBuilder(
                      builder: (context, setInnerState){
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          child: GridView.count(
                            crossAxisSpacing: 3.0,
                            mainAxisSpacing: 3.0,
                            crossAxisCount: 4,
                            children: List.generate(stickerList.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  setInnerState(() {
                                    setState(() {
                                      _image = stickerList[index];
                                      Navigator.pop(context);
                                    });
                                  });
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: Image(
                                    image: AssetImage("assets/${stickerList[index]}"),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    ),
                  );

                  showDialog(
                    context: context,
                    builder: (_) => alertDialog,
                  );
                },
                child: CircleAvatar(
                  minRadius: 50.0,
                  maxRadius: 80.0,
                  backgroundColor: Colors.black,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Image(
                      image: AssetImage("assets/" + _image),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _firstNameController,
                cursorColor: Colors.black,
                validator: ((val) {
                  return val.isEmpty ? "enter first name" : null;
                }
                ),
                decoration: fieldStyle.copyWith(
                  hintText: "first name",
                ),
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _lastNameController,
                cursorColor: Colors.black,
                validator: ((val) {
                  return val.isEmpty ? "enter last name" : null;
                }),
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
                          "FIRST_NAME" : _firstNameController.text,
                          "LAST_NAME" : _lastNameController.text,
                          "IMAGE" : _image
                        };

                        await DatabaseService(path: "people").update(userUpdate, _panchatUser.id);

                        Navigator.popUntil(context, (route) => route.isFirst);
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
