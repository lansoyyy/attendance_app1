import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addReport() async {
  final docUser = FirebaseFirestore.instance.collection('Reports').doc();

  final json = {
    'dateTime': DateTime.now(),
    'day': DateTime.now().day,
    'month': DateTime.now().month,
    'year': DateTime.now().year,
    'uid': FirebaseAuth.instance.currentUser!.uid,
    'id': docUser.id,
  };

  await docUser.set(json);
}
