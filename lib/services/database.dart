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

  /*---------------------------------------------------------------------*/

  Future<QuerySnapshot> getDocumentId({String field, String filter}) {
    return ref.where(filter, isEqualTo: field).get();
  }

  Stream<QuerySnapshot> watchDocumentId({String field, String filter}) {
    return getDocumentId(filter: filter, field: field).asStream();
  }

  Stream<QuerySnapshot> requestList({String field, List<String> filter, bool isEqual}) {
    if (filter.length > 0){
      if(isEqual) {
        return ref.where(field,whereIn: filter).snapshots();
      }
      else{
        return ref.where(field,whereNotIn: filter).snapshots();
      }
    }
    return ref.snapshots();
  }


  Stream<QuerySnapshot> friendList({String field, List<String> filter, bool isEqual}) {
    if (filter.length > 0){
      if (isEqual) {
        return ref.where(field, whereIn: filter).snapshots();
      }
      else{
        return ref.where(field, whereNotIn: filter).snapshots();
      }
    }

    return ref.snapshots();
  }


  Stream<List<PanchatUser>> get userList{
    return ref.snapshots().map((e) => _userFromStream(e));
  }

  Stream<List<PanchatUser>> peopleList({String field, List<String> filter, bool isEqual}){

    if (filter.length > 0){
      if (isEqual){
        return ref.where(field, whereIn: filter).snapshots().map((e) => _userFromStream(e));
      }
      else{
        return ref.where(field, whereNotIn: filter).snapshots().map((e) => _userFromStream(e));
      }
    }

    return ref.snapshots().map((e) => _userFromStream(e));
  }

  List<PanchatUser> _userFromStream(QuerySnapshot snapshot,){
    return snapshot.docs.map((doc) {
      return PanchatUser(
        uid: doc["UID"] ?? "",
        firstName: doc["FIRST_NAME"] ?? "",
        lastName: doc["LAST_NAME"] ?? "",
        id: doc.id ?? "",
      );
    }).toList();
  }

}