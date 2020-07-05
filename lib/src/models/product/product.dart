import 'package:easy_order/src/entities/product_entity.dart';
import 'package:easy_order/src/models/product/currency.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final String typeProduit;
  final Currency currency;
  final double price;
  final String picture;

  Product({
    this.id,
    this.name,
    this.description,
    this.typeProduit,
    this.currency,
    this.price,
    this.picture,
  });

  Product copyWith({
    String id,
    String name,
    String description,
    String typeProduit,
    Currency currency,
    double price,
    String picture,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      typeProduit: typeProduit ?? this.typeProduit,
      currency: currency ?? this.currency,
      price: price ?? this.price,
      picture: picture ?? this.picture,
    );
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      typeProduit.hashCode ^
      currency.hashCode ^
      price.hashCode ^
      picture.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          typeProduit == other.typeProduit &&
          currency == other.currency &&
          price == other.price &&
          picture == other.picture;

  @override
  String toString() =>
      'Product : { id : $id, name : $name, description : $description, typeProduit : $typeProduit, currency : $currency, price : $price, picture : $picture }';

  ProductEntity toEntity() {
    return ProductEntity(
      id,
      name,
      description,
      typeProduit,
      currency,
      price,
      picture,
    );
  }

  static Product fromEntity(ProductEntity entity) {
    return Product(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      typeProduit: entity.typeProduit,
      currency: entity.currency,
      price: entity.price,
      picture: entity.picture,
    );
  }
}
