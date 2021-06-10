import 'package:authentication_repository/authentication_repository.dart';
import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_app/authentication/authentication.dart';
import 'package:result_app/connectivity/bloc/connectivity_bloc.dart';
import 'package:result_app/home/home.dart';
import 'package:result_app/login/login.dart';
import 'package:result_app/splash/splash.dart';

class DecideLayout extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => DecideLayout());
  }
  const DecideLayout({Key? key}) : super(key: key);

  @override
  State createState() => _DecideLayout();
}

class _DecideLayout extends State<DecideLayout> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LayoutBuilder(
        builder: (context, constraints) {
          print(constraints.maxWidth);
          if (constraints.maxWidth > 800) {
            return Text("PC");
          }
          else {
            switch (BlocProvider.of<AuthenticationBloc>(context).state.status) {
              case AuthenticationStatus.authenticated:
              return HomePage();

                break;
              case AuthenticationStatus.unauthenticated:
                return LoginPage();
                break;
              case AuthenticationStatus.failed:
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text("Wrong username or password.")));
                break;
              default:
                break;
            }
          }

          throw UnimplementedError();
        }
      );
  }
}