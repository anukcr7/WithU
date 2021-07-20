import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CrudMethods {
  Future<void> addData(blogData) async {
    print(blogData);
    FirebaseFirestore.instance
        .collection("blogs")
        .add(blogData)
        .then((value) => print(value))
        .catchError((e) {
      print(e);
    });
  }

  getData() async {
    return await FirebaseFirestore.instance.collection("blogs").get();
  }
}
