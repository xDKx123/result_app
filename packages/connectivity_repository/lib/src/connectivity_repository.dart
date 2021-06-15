import 'dart:async';
import 'package:flutter/services.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectivityStatus {connected, disconnected}

class ConnectivityRepository {
  late StreamSubscription<ConnectivityResult> _subscription;
  final _controller = StreamController<ConnectivityStatus>();
  final Connectivity _connectivity = Connectivity();

  Stream<ConnectivityStatus> get status async* {
    //yield ConnectivityStatus.connected;
    initConnectivity();

    //handles connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    yield* _controller.stream;
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      //yield()
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      _controller.add(ConnectivityStatus.disconnected);
    }
    else {
      _controller.add(ConnectivityStatus.connected);
    }
    //_controller.add(result);
  }
}