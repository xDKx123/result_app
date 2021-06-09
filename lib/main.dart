import 'package:authentication_repository/authentication_repository.dart';
import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:result_app/app.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(App(
    authenticationRepository: AuthenticationRepository(),
    connectivityRepository: ConnectivityRepository(),
  ));
}
