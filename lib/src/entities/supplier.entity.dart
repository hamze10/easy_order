import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SupplierEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String picture;
  final List<dynamic> products;
  final String tel;

  const SupplierEntity(
      this.id, this.email, this.name, this.picture, this.products, this.tel);

  Map<String, Object> toJson() {
    return {
      "id": id,
      "email": email,
      "name": name,
      "picture": picture,
      "products": products,
      "tel": tel,
    };
  }

  @override
  List<Object> get props => [id, email, name, picture, products, tel];

  @override
  String toString() =>
      'SupplierEntity : {id : $id, email : $email, name : $name, picture : $picture, products : $products, tel : $tel}';

  static SupplierEntity fromJson(Map<String, Object> json) {
    return SupplierEntity(
      json["id"] as String,
      json["email"] as String,
      json["name"] as String,
      json["picture"] as String,
      json["products"] as List<dynamic>,
      json["tel"] as String,
    );
  }

  static SupplierEntity fromSnapshot(DocumentSnapshot snap) {
    return SupplierEntity(
      snap.documentID,
      snap.data['email'],
      snap.data['name'],
      snap.data['picture'],
      snap.data['products'],
      snap.data['tel'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      "email": email,
      "name": name,
      "picture": picture,
      "products": products,
      "tel": tel,
    };
  }
}
