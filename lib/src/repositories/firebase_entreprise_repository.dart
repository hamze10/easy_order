import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_order/src/entities/entreprise_entity.dart';
import 'package:easy_order/src/models/entreprise.dart';
import 'package:easy_order/src/repositories/entreprise_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseEntrepriseRepository implements EntrepriseRepository {
  final entrepriseCollection = Firestore.instance.collection('entreprises');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> addNewEntreprise(Entreprise entreprise) async {
    String _userID = (await _firebaseAuth.currentUser()).uid;
    Entreprise withOwner = entreprise.copyWith(owners: [_userID]);
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
    return entrepriseCollection
        .document(entreprise.id)
        .updateData(withOwner.toEntity().toDocument());
  }
}
