import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreMixin {
  FirebaseFirestore get store => FirebaseFirestore.instance;
}
