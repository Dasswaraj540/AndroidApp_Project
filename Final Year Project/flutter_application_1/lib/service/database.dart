import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<Stream<QuerySnapshot>> getUserData() async {
    return await FirebaseFirestore.instance
        .collection("UsersData")
        .orderBy("TimeStamp", descending: true)
        .snapshots();
  }
}
