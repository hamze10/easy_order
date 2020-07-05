import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_order/src/entities/product_entity.dart';
import 'package:easy_order/src/entities/supplier.entity.dart';
import 'package:easy_order/src/models/suppliers/supplier.dart';
import 'package:easy_order/src/models/product/product.dart';
import 'package:easy_order/src/repositories/product/product_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseProductRepository implements ProductRepository {
  final supplierCollection = Firestore.instance.collection("suppliers");
  final productCollection = Firestore.instance.collection("products");
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadAndGetImageForStorage(String img) async {
    StorageTaskSnapshot snapshot = await _firebaseStorage
        .ref()
        .child("products/$img")
        .putFile(File(img))
        .onComplete;

    if (snapshot.error == null) {
      return await snapshot.ref.getDownloadURL();
    }

    return null;
  }

  @override
  Future<void> addProduct(Product product, Supplier supplier) async {
    Product withPicture = product.copyWith();
    if (!product.picture.startsWith("http") &&
        !product.picture.startsWith("images/")) {
      final String dlURL = await uploadAndGetImageForStorage(product.picture);
      if (dlURL != null) {
        withPicture = withPicture.copyWith(picture: dlURL);
      }
    }
    return productCollection
        .add(withPicture.toEntity().toDocument())
        .then((value) {
      supplierCollection.document(supplier.id).get().then((snapshot) {
        Supplier sup =
            Supplier.fromEntity(SupplierEntity.fromSnapshot(snapshot));
        Product toAdd = withPicture.copyWith(id: value.documentID);
        List<Product> prod = List<Product>.from(sup.products)..add(toAdd);
        sup = sup.copyWith(products: prod);
        supplierCollection
            .document(supplier.id)
            .updateData(sup.toEntity().toDocument());
      });
    });
  }

  @override
  Future<void> deleteProduct(Product product, Supplier supplier) {
    return productCollection.document(product.id).delete().then((value) {
      supplierCollection.document(supplier.id).get().then((snapshot) {
        Supplier sup =
            Supplier.fromEntity(SupplierEntity.fromSnapshot(snapshot));
        List<Product> prod = List<Product>.from(sup.products)
          ..removeWhere((element) => element.id == product.id);
        sup = sup.copyWith(products: prod);
        supplierCollection
            .document(supplier.id)
            .updateData(sup.toEntity().toDocument());
      });
    });
  }

  @override
  Stream<List<Product>> products(List<Product> fromSupplier) async* {
    yield* productCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .where((element) =>
              fromSupplier.map((e) => e.id).contains(element.documentID))
          .map((e) => Product.fromEntity(ProductEntity.fromSnapshot(e)))
          .toList();
    });
  }

  @override
  Future<void> updateProduct(Product product) async {
    Product withPicture = product.copyWith();
    if (!product.picture.startsWith("http") &&
        !product.picture.startsWith("images/")) {
      final String dlURL = await uploadAndGetImageForStorage(product.picture);
      if (dlURL != null) {
        withPicture = withPicture.copyWith(picture: dlURL);
      }
    }
    return productCollection
        .document(product.id)
        .updateData(withPicture.toEntity().toDocument());
  }
}
