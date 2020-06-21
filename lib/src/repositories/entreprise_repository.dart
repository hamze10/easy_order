import 'package:easy_order/src/models/entreprise.dart';

abstract class EntrepriseRepository {
  Future<void> addNewEntreprise(Entreprise entreprise);
  Future<void> deleteNewEntreprise(Entreprise entreprise);
  Stream<List<Entreprise>> entreprises();
  Future<void> updateEntreprise(Entreprise entreprise);
}
