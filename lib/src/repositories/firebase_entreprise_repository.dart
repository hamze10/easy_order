import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_order/src/entities/entreprise_entity.dart';
import 'package:easy_order/src/models/entreprise.dart';
import 'package:easy_order/src/repositories/entreprise_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class FirebaseEntrepriseRepository implements EntrepriseRepository {
  final entrepriseCollection = Firestore.instance.collection('entreprises');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadAndGetImageForStorage(String img) async {
    String image = img
        .substring(img.lastIndexOf("/"), img.lastIndexOf("."))
        .replaceAll("/", "");
    final Directory dir = Directory.systemTemp;
    final byteData = await rootBundle.load(img);
    String imageWithExtension = img.substring(img.indexOf(image), img.length);
    File file = File('${dir.path}/$imageWithExtension');
    await file.writeAsBytes(byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    ));
    StorageTaskSnapshot snapshot = await _firebaseStorage
        .ref()
        .child("entreprises/$image")
        .putFile(file)
        .onComplete;
    if (snapshot.error == null) {
      return await snapshot.ref.getDownloadURL();
    }

    return null;
  }

  @override
  Future<void> addNewEntreprise(Entreprise entreprise) async {
    String _userID = (await _firebaseAuth.currentUser()).uid;
    Entreprise withOwner = entreprise.copyWith(owners: [_userID]);
    if (!entreprise.picture.startsWith("http")) {
      final String dlURL =
          await uploadAndGetImageForStorage(entreprise.picture);
      if (dlURL != null) {
        withOwner = withOwner.copyWith(picture: dlURL);
      }
    }
    return entrepriseCollection.add(withOwner.toEntity().toDocument());
  }

  @override
  Future<void> deleteNewEntreprise(Entreprise entreprise) {
    return entrepriseCollection.document(entreprise.id).delete();
  }

  @override
  Stream<List<Entreprise>> entreprises() async* {
    String _userID = (await _firebaseAuth.currentUser()).uid;
    yield* entrepriseCollection
        .where('owners', arrayContains: _userID)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents
          .map((doc) =>
              Entreprise.fromEntity(EntrepriseEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> updateEntreprise(Entreprise entreprise) async {
    String _userID = (await _firebaseAuth.currentUser()).uid;
    Entreprise withOwner = entreprise.copyWith(owners: [_userID]);
    if (!entreprise.picture.startsWith("http")) {
      final String dlURL =
          await uploadAndGetImageForStorage(entreprise.picture);
      if (dlURL != null) {
        withOwner = withOwner.copyWith(picture: dlURL);
      }
    }
    return entrepriseCollection
        .document(entreprise.id)
        .updateData(withOwner.toEntity().toDocument());
  }
}
