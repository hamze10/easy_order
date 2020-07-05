import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_order/src/models/suppliers/supplier.dart';
import 'package:equatable/equatable.dart';

class EntrepriseEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String address;
  final List<dynamic> owners;
  final List<Supplier> suppliers;
  final String tel;
  final String picture;

  const EntrepriseEntity(this.id, this.name, this.email, this.address,
      this.owners, this.suppliers, this.tel, this.picture);

  Map<String, Object> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "address": address,
      "owners": owners,
      "suppliers": suppliers,
      "tel": tel,
      "picture": picture,
    };
  }

  @override
  List<Object> get props =>
      [id, name, email, address, owners, suppliers, tel, picture];

  @override
  String toString() =>
      'EntrepriseEntity : { id: $id, name: $name, email: $email, address: $address, owners : $owners, suppliers : $suppliers, tel : $tel, picture : $picture }';

  static EntrepriseEntity fromJson(Map<String, Object> json) {
    return EntrepriseEntity(
      json["id"] as String,
      json["name"] as String,
      json["email"] as String,
      json["address"] as String,
      json["owners"] as List<dynamic>,
      json["suppliers"] as List<Supplier>,
      json["tel"] as String,
      json["picture"] as String,
    );
  }

  static EntrepriseEntity fromSnapshot(DocumentSnapshot snap) {
    return EntrepriseEntity(
      snap.documentID,
      snap.data['name'],
      snap.data['email'],
      snap.data['address'],
      snap.data['owners'],
      stringToSupplier(List<String>.from(snap.data['suppliers'])),
      snap.data['tel'],
      snap.data['picture'],
    );
  }

  static List<Supplier> stringToSupplier(List<String> list) {
    List<Supplier> toSend = [];
    for (String s in list) {
      toSend.add(Supplier(id: s));
    }
    return toSend;
  }

  static List<String> supplierToString(List<Supplier> list) {
    List<String> toSend = [];
    for (Supplier s in list) {
      toSend.add(s.id);
    }
    return toSend;
  }

  Map<String, Object> toDocument() {
    return {
      "name": name,
      "email": email,
      "address": address,
      "owners": owners,
      "suppliers": supplierToString(suppliers),
      "tel": tel,
      "picture": picture,
    };
  }
}
