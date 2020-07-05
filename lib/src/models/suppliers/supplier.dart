import 'package:easy_order/src/entities/supplier.entity.dart';
import 'package:easy_order/src/models/product/product.dart';

class Supplier {
  final String id;
  final String email;
  final String name;
  final String picture;
  final List<Product> products;
  final String tel;

  Supplier({
    this.id,
    this.email,
    this.name,
    this.picture,
    this.products,
    this.tel,
  });

  Supplier copyWith({
    String id,
    String email,
    String name,
    String picture,
    List<Product> products,
    String tel,
  }) {
    return Supplier(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      picture: picture ?? this.picture,
      products: products ?? this.products,
      tel: tel ?? this.tel,
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      name.hashCode ^
      picture.hashCode ^
      products.hashCode ^
      tel.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Supplier &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name &&
          picture == other.picture &&
          products == other.products &&
          tel == other.tel;

  @override
  String toString() =>
      'Supplier : {id : $id, email : $email, name : $name, picture : $picture, products : $products, tel : $tel}';

  SupplierEntity toEntity() {
    return SupplierEntity(
      id,
      email,
      name,
      picture,
      products,
      tel,
    );
  }

  static Supplier fromEntity(SupplierEntity entity) {
    return Supplier(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      picture: entity.picture,
      products: entity.products,
      tel: entity.tel,
    );
  }
}
