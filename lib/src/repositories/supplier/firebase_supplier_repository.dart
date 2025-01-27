import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_order/src/entities/entreprise_entity.dart';
import 'package:easy_order/src/entities/supplier.entity.dart';
import 'package:easy_order/src/models/entreprise/entreprise.dart';
import 'package:easy_order/src/models/suppliers/supplier.dart';
import 'package:easy_order/src/repositories/supplier/supplier_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseSupplierRepository implements SupplierRepository {
  final entrepriseCollection = Firestore.instance.collection('entreprises');
  final supplierCollection = Firestore.instance.collection('suppliers');
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadAndGetImageForStorage(String img) async {
    StorageTaskSnapshot snapshot = await _firebaseStorage
        .ref()
        .child("suppliers/$img")
        .putFile(File(img))
        .onComplete;

    if (snapshot.error == null) {
      return await snapshot.ref.getDownloadURL();
    }

    return null;
  }

  @override
  Future<void> addNewSupplier(Supplier supplier, Entreprise entreprise) async {
    Supplier withPicture = supplier.copyWith();
    if (!supplier.picture.startsWith("http") &&
        !supplier.picture.startsWith("images/")) {
      final String dlURL = await uploadAndGetImageForStorage(supplier.picture);
      if (dlURL != null) {
        withPicture = withPicture.copyWith(picture: dlURL);
      }
    }
    try {
      return supplierCollection
          .add(withPicture.toEntity().toDocument())
          .then((value) {
        entrepriseCollection.document(entreprise.id).get().then((snapshot) {
          Entreprise ent =
              Entreprise.fromEntity(EntrepriseEntity.fromSnapshot(snapshot));
          Supplier toAdd = withPicture.copyWith(id: value.documentID);
          List<Supplier> supp = List<Supplier>.from(ent.suppliers)..add(toAdd);
          ent = ent.copyWith(suppliers: supp);
          entrepriseCollection
              .document(entreprise.id)
              .updateData(ent.toEntity().toDocument());
        });
      });
    } catch (e) {
      print("Error addSupplier : $e");
    }
  }

  @override
  Future<void> deleteSupplier(Supplier supplier, Entreprise entreprise) {
    return supplierCollection.document(supplier.id).delete().then((value) {
      entrepriseCollection.document(entreprise.id).get().then((snapshot) {
        Entreprise ent =
            Entreprise.fromEntity(EntrepriseEntity.fromSnapshot(snapshot));
        List<Supplier> supp = List<Supplier>.from(ent.suppliers)
          ..removeWhere((e) => e.id == supplier.id);
        ent = ent.copyWith(suppliers: supp);
        entrepriseCollection
            .document(entreprise.id)
            .updateData(ent.toEntity().toDocument());
      });
    });
  }

  Future<List<String>> _getSupplier(String idEntreprise) async {
    DocumentSnapshot snap =
        await entrepriseCollection.document(idEntreprise).get();
    return List<String>.from(snap.data['suppliers']);
  }

  @override
  Stream<List<Supplier>> suppliers(String idEntreprise) async* {
    List<String> supp = await _getSupplier(idEntreprise);
    yield* supplierCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .where((element) => supp.contains(element.documentID))
          .map((e) => Supplier.fromEntity(SupplierEntity.fromSnapshot(e)))
          .toList();
    });
  }

  @override
  Future<void> updateSupplier(Supplier supplier) async {
    Supplier withPicture = supplier.copyWith();
    if (!supplier.picture.startsWith("http") &&
        !supplier.picture.startsWith("images/")) {
      final String dlURL = await uploadAndGetImageForStorage(supplier.picture);
      if (dlURL != null) {
        withPicture = withPicture.copyWith(picture: dlURL);
      }
    }
    try {
      return supplierCollection
          .document(supplier.id)
          .updateData(withPicture.toEntity().toDocument());
    } catch (e) {
      print("Error updateSupplier : $e");
    }
  }
}
