import 'package:cloud_firestore/cloud_firestore.dart';

class TentangService{
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Object?>> streamTentang(){
    CollectionReference data = firestore.collection("tentang");
    return data.snapshots();
  }
}