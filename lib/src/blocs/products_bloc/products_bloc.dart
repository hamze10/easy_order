import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_order/src/models/product/product.dart';
import 'package:easy_order/src/models/suppliers/supplier.dart';
import 'package:easy_order/src/repositories/product/firebase_product_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final FirebaseProductRepository _productRepository;
  StreamSubscription _productSubscription;

  ProductsBloc({
    @required FirebaseProductRepository productRepository,
  })  : assert(productRepository != null),
        _productRepository = productRepository;

  @override
  ProductsState get initialState => ProductsLoadInProgress();

  @override
  Stream<ProductsState> mapEventToState(
    ProductsEvent event,
  ) async* {
    if (event is LoadProducts) {
      yield* _mapLoadProductsToState(event);
    } else if (event is ProductsUpdated) {
      yield* _mapProductsUpdateToState(event);
    }
  }

  Stream<ProductsState> _mapLoadProductsToState(LoadProducts event) async* {
    Supplier sup = event.supplier;
    _productSubscription?.cancel();
    _productSubscription = _productRepository
        .products(event.supplier.id)
        .listen((product) => add(ProductsUpdated(product, sup)));
  }

  Stream<ProductsState> _mapProductsUpdateToState(
      ProductsUpdated event) async* {
    yield ProductsLoadSuccess(event.products, event.supplier);
  }

  @override
  Future<void> close() {
    _productSubscription?.cancel();
    return super.close();
  }
}
