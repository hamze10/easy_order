import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_order/src/models/product/product.dart';
import 'package:easy_order/src/models/suppliers/supplier.dart';
import 'package:easy_order/src/repositories/product/firebase_product_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'manage_product_event.dart';
part 'manage_product_state.dart';

class ManageProductBloc extends Bloc<ManageProductEvent, ManageProductState> {
  final FirebaseProductRepository _productRepository;

  ManageProductBloc({
    @required FirebaseProductRepository productRepository,
  })  : assert(productRepository != null),
        _productRepository = productRepository;

  @override
  ManageProductState get initialState => ManageProductState.inital();

  @override
  Stream<ManageProductState> mapEventToState(
    ManageProductEvent event,
  ) async* {
    if (event is AddProduct) {
      yield* _mapAddProductToState(event);
    } else if (event is UpdateProduct) {
      yield* _mapUpdateProductToState(event);
    } else if (event is DeleteProduct) {
      yield* _mapDeleteProductToState(event);
    }
  }

  Stream<ManageProductState> _mapAddProductToState(AddProduct event) async* {
    yield ManageProductState.loading();
    try {
      await _productRepository.addProduct(event.product, event.supplier);
      yield ManageProductState.success();
    } catch (_) {
      yield ManageProductState.failure();
    }
  }

  Stream<ManageProductState> _mapUpdateProductToState(
      UpdateProduct event) async* {
    yield ManageProductState.loading();
    try {
      await _productRepository.updateProduct(event.product);
      yield ManageProductState.success();
    } catch (_) {
      yield ManageProductState.failure();
    }
  }

  Stream<ManageProductState> _mapDeleteProductToState(
      DeleteProduct event) async* {
    yield ManageProductState.loading();
    try {
      await _productRepository.deleteProduct(event.product, event.supplier);
      yield ManageProductState.success();
    } catch (_) {
      yield ManageProductState.failure();
    }
  }
}
