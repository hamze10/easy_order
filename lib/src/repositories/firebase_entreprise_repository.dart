import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_order/src/entities/entreprise_entity.dart';
import 'package:easy_order/src/models/entreprise.dart';
import 'package:easy_order/src/repositories/entreprise_repository.dart';

class FirebaseEntrepriseRepository implements EntrepriseRepository {
  final entrepriseCollection = Firestore.instance.collection('entreprises');

  @override
  Future<void> addNewEntreprise(Entreprise entreprise) {
    return entrepriseCollection.add(entreprise.toEntity().toDocument());
  }

  @override
  Future<void> deleteNewEntreprise(Entreprise entreprise) {
    return entrepriseCollection.document(entreprise.id).delete();
  }

  @override
  Stream<List<Entreprise>> entreprises() {
    return entrepriseCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) =>
              Entreprise.fromEntity(EntrepriseEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> updateEntreprise(Entreprise entreprise) {
    return entrepriseCollection
        .document(entreprise.id)
        .updateData(entreprise.toEntity().toDocument());
  }
}
