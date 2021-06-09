part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PostFetchedOnline extends PostEvent {
  PostFetchedOnline() : super();
}

class PostFetchedOffline extends PostEvent {
  PostFetchedOffline() : super();
}