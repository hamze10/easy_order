import 'package:easy_order/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:easy_order/src/blocs/entreprises_bloc/entreprises_bloc.dart';
import 'package:easy_order/src/blocs/products_bloc/products_bloc.dart';
import 'package:easy_order/src/blocs/suppliers_bloc/suppliers_bloc.dart';
import 'package:easy_order/src/repositories/entreprise/firebase_entreprise_repository.dart';
import 'package:easy_order/src/repositories/product/firebase_product_repository.dart';
import 'package:easy_order/src/repositories/supplier/firebase_supplier_repository.dart';
import 'package:easy_order/src/repositories/user/user_repository.dart';
import 'package:easy_order/src/views/entreprise/entreprise_screen.dart';
import 'package:easy_order/src/views/entreprise/manage_entreprise_screen.dart';
import 'package:easy_order/src/views/login/login_screen.dart';
import 'package:easy_order/src/views/products/manage_product_screen.dart';
import 'package:easy_order/src/views/products/product_screen.dart';
import 'package:easy_order/src/views/splash_screen.dart';
import 'package:easy_order/src/repositories/repositories.dart';
import 'package:easy_order/src/views/suppliers/manage_supplier_screen.dart';
import 'package:easy_order/src/views/suppliers/supplier_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository userRepository = UserRepository();
  final FirebaseEntrepriseRepository firebaseEntrepriseRepository =
      FirebaseEntrepriseRepository();
  final FirebaseSupplierRepository firebaseSupplierRepository =
      FirebaseSupplierRepository();
  final FirebaseProductRepository firebaseProductRepository =
      FirebaseProductRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) {
            return AuthenticationBloc(userRepository: userRepository)
              ..add(AuthenticationStarted());
          },
        ),
        BlocProvider<EntreprisesBloc>(
          create: (context) {
            return EntreprisesBloc(
                entrepriseRepository: firebaseEntrepriseRepository)
              ..add(LoadEntreprises());
          },
        ),
        BlocProvider<SuppliersBloc>(
          create: (context) {
            return SuppliersBloc(
                supplierRepository: firebaseSupplierRepository);
          },
        ),
        BlocProvider<ProductsBloc>(
          create: (context) {
            return ProductsBloc(productRepository: firebaseProductRepository);
          },
        ),
      ],
      child: App(
        userRepository: userRepository,
        entrepriseRepository: firebaseEntrepriseRepository,
        supplierRepository: firebaseSupplierRepository,
        productRepository: firebaseProductRepository,
      ),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;
  final FirebaseEntrepriseRepository _entrepriseRepository;
  final FirebaseSupplierRepository _supplierRepository;
  final FirebaseProductRepository _productRepository;

  App({
    Key key,
    @required UserRepository userRepository,
    @required FirebaseEntrepriseRepository entrepriseRepository,
    @required FirebaseSupplierRepository supplierRepository,
    @required FirebaseProductRepository productRepository,
  })  : assert(userRepository != null &&
            entrepriseRepository != null &&
            supplierRepository != null &&
            productRepository != null),
        _userRepository = userRepository,
        _entrepriseRepository = entrepriseRepository,
        _supplierRepository = supplierRepository,
        _productRepository = productRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/manageEntreprise': (context) {
          return ManageEntrepriseScreen(
            entrepriseRepository: _entrepriseRepository,
          );
        },
        '/suppliers': (context) {
          return SupplierScreen();
        },
        '/manageSupplier': (context) {
          return ManageSupplierScreen(
            supplierRepository: _supplierRepository,
          );
        },
        '/products': (context) {
          return ProductScreen();
        },
        '/manageProduct': (context) {
          return ManageProductScreen(
            productRepository: _productRepository,
          );
        },
      },
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationSuccess) {
            BlocProvider.of<EntreprisesBloc>(context).add(LoadEntreprises());
            return EntrepriseScreen(
              displayName: state.displayName,
            );
          }
          if (state is AuthenticationFailure) {
            return LoginScreen(
              userRepository: _userRepository,
            );
          }
          return SplashScreen();
        },
      ),
    );
  }
}
