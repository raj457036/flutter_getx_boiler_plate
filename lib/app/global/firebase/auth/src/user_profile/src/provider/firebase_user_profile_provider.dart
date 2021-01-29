import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../mixins/firebase_mixins.dart';
import '../models/user_profile.dart';

abstract class FirebaseUserProfileProvider {
  String get collectionPath;
  Future<UserProfile> getUser(String uid);
  Future<UserProfile> updateProfile(UserProfile updatedProfile);
  Future<bool> deleteProfile(String uid);
  Future<void> deleteProfileWithDocId(String docId);
  Future<UserProfile> createProfile(UserProfile newProfile);
}

class FirebaseUserProfileProviderImpl
    with FireStoreMixin
    implements FirebaseUserProfileProvider {
  @override
  String get collectionPath => "users";

  CollectionReference get collection => store.collection(collectionPath);

  @override
  Future<UserProfile> createProfile(UserProfile newProfile) async {
    final docRef = await collection.add(newProfile.toMap());
    return newProfile.copyWith(id: docRef.id);
  }

  @override
  Future<bool> deleteProfile(String uid) async {
    final docRef = await collection.where("uid", isEqualTo: uid).limit(1).get();
    if (docRef.docs.isEmpty) {
      await docRef.docs.first.reference.delete();
      return true;
    }
    return false;
  }

  @override
  Future<void> deleteProfileWithDocId(String docId) async {
    await collection.doc(docId).delete();
  }

  @override
  Future<UserProfile> getUser(String uid) async {
    final docs = await collection.where('uid', isEqualTo: uid).limit(1).get();

    if (docs.docs.isEmpty) return null;
    return UserProfile.fromMap({
      "id": docs.docs.first.id,
      ...docs.docs.first.data(),
    });
  }

  @override
  Future<UserProfile> updateProfile(UserProfile updatedProfile) async {
    await collection
        .doc(updatedProfile.id)
        .set(updatedProfile.toMap(), SetOptions(merge: true));
    return updatedProfile;
  }
}
