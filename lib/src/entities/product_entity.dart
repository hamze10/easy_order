import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_order/src/models/product/currency.dart';
import 'package:easy_order/src/utils/currency_converter.dart';
import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String typeProduct;
  final Currency currency;
  final double price;
  final String picture;

  const ProductEntity(
    this.id,
    this.name,
    this.description,
    this.typeProduct,
    this.currency,
    this.price,
    this.picture,
  );

  Map<String, Object> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "typeProduct": typeProduct,
      "currency": currency,
      "price": price,
      "picture": picture,
    };
  }

  @override
  List<Object> get props =>
      [id, name, description, typeProduct, currency, price, picture];

  @override
  String toString() =>
      'ProductEntity : { id : $id, name : $name, description : $description, typeProduct : $typeProduct, currency : $currency, price : $price, picture : $picture}';

  static ProductEntity fromJson(Map<String, Object> json) {
    return ProductEntity(
      json["id"] as String,
      json["name"] as String,
      json["description"] as String,
      json["typeProduct"] as String,
      json["currency"] as Currency,
      json["price"] as double,
      json["picture"] as String,
    );
  }

  static ProductEntity fromSnapshot(DocumentSnapshot snap) {
    return ProductEntity(
      snap.documentID,
      snap.data["name"],
      snap.data["description"],
      snap.data["typeProduct"],
      CurrencyConvertor.toCurrency(snap.data["currency"]),
      snap.data["price"],
      snap.data["picture"],
    );
  }

  Map<String, Object> toDocument() {
    return {
      "name": name,
      "description": description,
      "typeProduct": typeProduct,
      "currency": CurrencyConvertor.convert(currency),
      "price": price,
      "picture": picture,
    };
  }
}
