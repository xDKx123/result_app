import 'dart:async';
import 'package:flutter/material.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:utility_repository/utility_repository.dart';
//import 'package:authentication_repository/src/http_methods.dart';
//import 'package:localstorage/localstorage.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated, failed }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    //await Future<void>.delayed(const Duration(seconds: 1));
    String token = await LocalStorageHelper.getToken();
    if (token != "") {
      yield AuthenticationStatus.authenticated;
    }
    else {
      yield AuthenticationStatus.unauthenticated;
    }
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    dynamic res = await HttpMethods.login(username, password);

    if (res == null) {
      _controller.add(AuthenticationStatus.failed);
      //print("is null");
      return;
    }

    if (res.containsKey('token')) {
      _controller.add(AuthenticationStatus.authenticated);
      await LocalStorageHelper.setToken(res['token']);
    }
    else {
      _controller.add(AuthenticationStatus.failed);
    }


    //print("login prožen");
    //await Future.delayed(
    //  const Duration(milliseconds: 300),
      //    () => _controller.add(AuthenticationStatus.authenticated),
    //);
  }

  void logOut() async {
    await LocalStorageHelper.clearStorage();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}