import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:janin/provider/prediksi.dart';
import 'package:provider/provider.dart';

class PrediksiService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void tambahData(context) {
    CollectionReference prediksi = firestore.collection("hasil_prediksi");

    PrediksiProvider prediksiProvider = Provider.of(context, listen: false);

    prediksi.add({
      'result': prediksiProvider.result,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Object?>> streamPrediksi() {
    CollectionReference data = firestore.collection("hasil_prediksi");
    return data.snapshots();
  }

  Future<DocumentSnapshot<Object?>> getByIDPrediksi(String id) async {
    DocumentReference docRef = firestore.collection("hasil_prediksi").doc(id);
    return docRef.get();
  }

  Stream<QuerySnapshot> streamPrediksiByUserId(String id) {
    return firestore
        .collection("hasil_prediksi") // Replace with your collection name
        .where('id', isEqualTo: id) // Replace with your field name
        .snapshots();
  }
}
