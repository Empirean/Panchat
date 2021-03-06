import 'package:firebase_auth/firebase_auth.dart';
import 'package:panchat/models/logininfo.dart';
import 'package:panchat/models/users.dart';

import 'database.dart';

class AuthenticationService{

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<LoginInfo> get loginInfo{
    return _firebaseAuth.userChanges().map(_loginInfoFromStream);
  }

  LoginInfo _loginInfoFromStream(User user)
  {
    return user != null ? LoginInfo(uid: user.uid) : null;
  }

  Future signOut() async {
    try{
      return await _firebaseAuth.signOut();
    }
    on FirebaseAuthException catch(e)
    {
      return e.message;
    }
    catch(e)
    {
      return null;
    }
  }


  Future signUpEmail(String email, String password, String firstName, String lastName) async {
    try{

      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      String uid = result.user.uid;

      Map<String, dynamic> data = {
        "UID" : uid,
        "FIRST_NAME" : firstName,
        "LAST_NAME" : lastName,
        "IMAGE" : "pandi_00.png"
      };
      await DatabaseService(path: "people").insert(data);
    }
    on FirebaseAuthException catch(e)
    {
      return e.message;
    }
    catch (e){
      return null;
    }
  }

  Future signInEmail(String email, String password) async {
    try{
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    }
    on FirebaseAuthException catch(e) {
      return e.message;
    }
    catch(e) {
      return null;
    }
  }

}