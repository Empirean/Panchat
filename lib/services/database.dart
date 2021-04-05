import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:panchat/models/users.dart';

class DatabaseService{

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String path;
  CollectionReference ref;

  DatabaseService({ this.path, }) {
    ref = _db.collection(path);
  }

  Future insert(Map data ) {
    return ref.add(data);
  }

  Future update(Map<String, dynamic> data, String id){
    return ref.doc(id).update(data);
  }

  Future delete(String id) {
    return ref.doc(id).delete();
  }

  Future<QuerySnapshot> getDocuments({String field, String filter}) {
    return ref.where(field, isEqualTo: filter).get();
  }

  Stream<QuerySnapshot> watchDocuments({String field, String filter}) {
    return getDocuments(field: field, filter: filter).asStream();
  }

  Stream<QuerySnapshot> watchAll() {
    return ref.snapshots();
  }

  Stream<QuerySnapshot> watchAndSortAll({String field}) {
    return ref.orderBy(field, descending: false).snapshots();
  }

  Stream<PanchatUser> watchUserInfo({String field, String filter})  {
    return watchDocuments(field: field, filter: filter).map(_panchatUserFromStream);
  }

  Future<PanchatUser> getUserInfo({String field, String filter})  {
    return watchDocuments(field: field, filter: filter).map(_panchatUserFromStream).first;
  }

  PanchatUser _panchatUserFromStream(QuerySnapshot user)
  {
    return user.docs.map((doc){
      return PanchatUser(
        uid: doc["UID"] ?? "",
        id: doc.id ?? "",
        image: doc["IMAGE"] ?? "",
        firstName: doc["FIRST_NAME"] ?? "",
        lastName: doc["LAST_NAME"] ?? "",
      );
    }).toList()[0];
  }
}