import 'package:easy_order/src/entities/entreprise_entity.dart';
import 'package:easy_order/src/models/supplier.dart';

class Entreprise {
  final String id;
  final String name;
  final String email;
  final String address;
  final List<dynamic> owners;
  final List<Supplier> suppliers;
  final String tel;
  final String picture;

  Entreprise({
    this.name,
    this.id,
    this.email,
    this.address = '',
    this.owners = const [],
    this.suppliers = const [],
    this.tel,
    this.picture = "",
  });

  Entreprise copyWith({
    String id,
    String name,
    String email,
    String address,
    List<dynamic> owners,
    List<Supplier> suppliers,
    String tel,
    String picture,
  }) {
    return Entreprise(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      owners: owners ?? this.owners,
      suppliers: suppliers ?? this.suppliers,
      tel: tel ?? this.tel,
      picture: picture ?? this.picture,
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      address.hashCode ^
      owners.hashCode ^
      suppliers.hashCode ^
      tel.hashCode ^
      picture.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entreprise &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          address == other.address &&
          owners == other.owners &&
          suppliers == other.suppliers &&
          tel == other.tel &&
          picture == other.picture;

  @override
  String toString() =>
      'Entreprise : { id: $id, name: $name, email: $email, address: $address, owners : $owners, suppliers : $suppliers, tel : $tel, picture : $picture }';

  EntrepriseEntity toEntity() {
    return EntrepriseEntity(
        id, name, email, address, owners, suppliers, tel, picture);
  }

  static Entreprise fromEntity(EntrepriseEntity entity) {
    return Entreprise(
      address: entity.address,
      email: entity.email,
      id: entity.id,
      name: entity.name,
      owners: entity.owners,
      picture: entity.picture,
      suppliers: entity.suppliers,
      tel: entity.tel,
    );
  }
}
