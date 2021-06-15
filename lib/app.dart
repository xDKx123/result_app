import 'package:authentication_repository/authentication_repository.dart';
import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_app/authentication/authentication.dart';
import 'package:result_app/connectivity/bloc/connectivity_bloc.dart';
import 'package:result_app/home/home.dart';
import 'package:result_app/introduction/introduction.dart';
import 'package:result_app/splash/splash.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.authenticationRepository,
    required this.connectivityRepository,
  }) : super(key: key);

  final AuthenticationRepository authenticationRepository;
  final ConnectivityRepository connectivityRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
            ),
            //child: AppView(),
          ),
          BlocProvider(
            create: (context) => ConnectivityBloc(
                connectivityRepository: connectivityRepository),
          ),
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<ConnectivityBloc, ConnectivityState>(
          listener: (context, state) {},
          child: BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              //_navigator.pushAndRemoveUntil<void>(DecideLayout.route(), (route) => false);
              switch (state.status) {
                case AuthenticationStatus.authenticated:
                //return HomePage();
                  _navigator.pushAndRemoveUntil<void>(
                    HomePage.route(),
                        (route) => false,
                  );
                  break;
                case AuthenticationStatus.unauthenticated:
                  _navigator.pushAndRemoveUntil<void>(
                    IntroductionPage.route(),
                        (route) => false,
                  );
                  break;
                case AuthenticationStatus.failed:
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text("Wrong username or password.")));
                  break;
                default:
                  break;
              }
            },
            child: child,
          ),
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}