import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_order/src/entities/entreprise_entity.dart';
import 'package:easy_order/src/entities/supplier.entity.dart';
import 'package:easy_order/src/models/entreprise.dart';
import 'package:easy_order/src/models/supplier.dart';
import 'package:easy_order/src/repositories/supplier_repository.dart';
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
    Supplier withPicture = supplier.copyWith(products: []);
    if (!supplier.picture.startsWith("http") &&
        !supplier.picture.startsWith("images/")) {
      final String dlURL = await uploadAndGetImageForStorage(supplier.picture);
      if (dlURL != null) {
        withPicture = supplier.copyWith(picture: dlURL);
      }
    }
    return await supplierCollection
        .add(withPicture.toEntity().toDocument())
        .then((value) async {
      await entrepriseCollection
          .document(entreprise.id)
          .get()
          .then((snapshot) async {
        Entreprise ent =
            Entreprise.fromEntity(EntrepriseEntity.fromSnapshot(snapshot));
        Supplier toAdd = supplier.copyWith(id: value.documentID);
        List<Supplier> supp = List<Supplier>.from(ent.suppliers)..add(toAdd);
        ent = ent.copyWith(suppliers: supp);
        await entrepriseCollection
            .document(entreprise.id)
            .updateData(ent.toEntity().toDocument());
      });
    });
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

  @override
  Stream<List<Supplier>> suppliers(List<Supplier> fromEntreprise) async* {
    yield* supplierCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .where((element) =>
              fromEntreprise.map((e) => e.id).contains(element.documentID))
          .map((e) => Supplier.fromEntity(SupplierEntity.fromSnapshot(e)))
          .toList();
    });
  }

  @override
  Future<void> updateSupplier(Supplier supplier) async {
    Supplier withPicture = supplier.copyWith(products: []);
    if (!supplier.picture.startsWith("http") &&
        !supplier.picture.startsWith("images/")) {
      final String dlURL = await uploadAndGetImageForStorage(supplier.picture);
      if (dlURL != null) {
        withPicture = supplier.copyWith(picture: dlURL);
      }
    }
    return supplierCollection
        .document(supplier.id)
        .updateData(withPicture.toEntity().toDocument());
  }
}
