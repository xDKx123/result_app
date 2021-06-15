import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:equatable/equatable.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  ConnectivityBloc({
  required ConnectivityRepository connectivityRepository,
  }) : _connectivityRepository = connectivityRepository,
      super(const ConnectivityState.disconnected()) {
    _connectivityStatusSubscription = _connectivityRepository.status.listen((status) => add(ConnectivityStatusChanged(status)));
  }

  final ConnectivityRepository _connectivityRepository;
  late StreamSubscription<ConnectivityStatus> _connectivityStatusSubscription;

  @override
  Future<void> close() {
    _connectivityStatusSubscription.cancel();
    return super.close();
  }

  @override
  Stream<ConnectivityState> mapEventToState(
      ConnectivityEvent event,
      ) async* {
    if (event is ConnectivityStatusChanged) {
      yield await _mapConnectivityStatusChangedToState(event);
    }
  }

  Future<ConnectivityState> _mapConnectivityStatusChangedToState(
      ConnectivityStatusChanged event,
      ) async {
    switch (event.status) {
      case ConnectivityStatus.connected:
        return ConnectivityState.connected();
      case ConnectivityStatus.disconnected:
        return ConnectivityState.disconnected();
      default:
        return const ConnectivityState.none();
    }
  }
}
