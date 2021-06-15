import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:utility_repository/utility_repository.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated, failed, wrongUsernameOrPassword }

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
    required BuildContext context,
  }) async {
    dynamic response = await HttpMethods.login(username, password);

    if (response == null) {
      _controller.add(AuthenticationStatus.failed);
      //print("is null");
      return;
    }

    dynamic body = jsonDecode(response.body);

    ///200 success
    ///401 wrong username/password
    switch (response.statusCode) {
      case 200:
        _controller.add(AuthenticationStatus.authenticated);
        await LocalStorageHelper.setToken(body['token']);
        //return jsonDecode(response.body);
        break;
      case 401:
        _controller.add(AuthenticationStatus.wrongUsernameOrPassword);
        ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(body["Message"])));
        break;
      default:
        _controller.add(AuthenticationStatus.failed);
        ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: const Text("Unknown error.")));
        break;
        //return jsonDecode(response.body);
    }

    /*
    if (res.containsKey('token')) {
      _controller.add(AuthenticationStatus.authenticated);
      await LocalStorageHelper.setToken(res['token']);
    }
    else {
      _controller.add(AuthenticationStatus.failed);
    }*/


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