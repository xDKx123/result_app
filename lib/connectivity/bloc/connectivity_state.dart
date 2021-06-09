part of 'connectivity_bloc.dart';

class ConnectivityState extends Equatable {
  const ConnectivityState._({
    this.status = ConnectivityStatus.disconnected,
  });

  const ConnectivityState.none() : this._();
  const ConnectivityState.disconnected() : this._(status: ConnectivityStatus.disconnected);
  const ConnectivityState.connected() : this._(status: ConnectivityStatus.connected);

  final ConnectivityStatus status;

  @override
  List<Object> get props => [status];
}