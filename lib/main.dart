import 'package:easy_order/src/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:easy_order/src/blocs/entreprises_bloc/entreprises_bloc.dart';
import 'package:easy_order/src/repositories/firebase_entreprise_repository.dart';
import 'package:easy_order/src/repositories/user_repository.dart';
import 'package:easy_order/src/views/entreprise/entreprise_page.dart';
import 'package:easy_order/src/views/entreprise/manage_entreprise_screen.dart';
import 'package:easy_order/src/views/login/login_screen.dart';
import 'package:easy_order/src/views/splash_screen.dart';
import 'package:easy_order/src/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository userRepository = UserRepository();
  final FirebaseEntrepriseRepository firebaseEntrepriseRepository =
      FirebaseEntrepriseRepository();

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
      ],
      child: App(
        userRepository: userRepository,
      ),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({
    Key key,
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/manageEntreprise': (context) {
          return ManageEntrepriseScreen(
            onSave: (entreprise, editing) {
              if (editing) {
                BlocProvider.of<EntreprisesBloc>(context)
                    .add(UpdateEntreprise(entreprise));
              } else {
                BlocProvider.of<EntreprisesBloc>(context)
                    .add(AddEntreprise(entreprise));
              }
            },
            onDelete: (entreprise) {
              BlocProvider.of<EntreprisesBloc>(context)
                  .add(DeleteEntreprise(entreprise));
            },
          );
        },
      },
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationSuccess) {
            BlocProvider.of<EntreprisesBloc>(context).add(LoadEntreprises());
            return EntreprisePage(
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
