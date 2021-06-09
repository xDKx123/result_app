export 'bloc/connectivity_bloc.dart';

///Handles the current state of connectivity
///# connected - user is connected to internet via wifi or mobile data
///##request server for new data
///##can refresh for new data
///
///# disconnected - user is not connected to internet
///##data taken from local storage
///##cannot refresh for new data