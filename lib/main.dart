import 'package:easy_order/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:easy_order/src/blocs/entreprises_bloc/entreprises_bloc.dart';
import 'package:easy_order/src/blocs/suppliers_bloc/suppliers_bloc.dart';
import 'package:easy_order/src/repositories/firebase_entreprise_repository.dart';
import 'package:easy_order/src/repositories/firebase_supplier_repository.dart';
import 'package:easy_order/src/repositories/user_repository.dart';
import 'package:easy_order/src/views/entreprise/entreprise_screen.dart';
import 'package:easy_order/src/views/entreprise/manage_entreprise_screen.dart';
import 'package:easy_order/src/views/login/login_screen.dart';
import 'package:easy_order/src/views/splash_screen.dart';
import 'package:easy_order/src/repositories/repositories.dart';
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
      ],
      child: App(
        userRepository: userRepository,
        entrepriseRepository: firebaseEntrepriseRepository,
      ),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;
  final FirebaseEntrepriseRepository _entrepriseRepository;

  App({
    Key key,
    @required UserRepository userRepository,
    @required FirebaseEntrepriseRepository entrepriseRepository,
  })  : assert(userRepository != null && entrepriseRepository != null),
        _userRepository = userRepository,
        _entrepriseRepository = entrepriseRepository,
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
        }
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
