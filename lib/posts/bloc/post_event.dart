part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PostFetchedOnline extends PostEvent {
  PostFetchedOnline(this.context) : super();

  final BuildContext context;
}

class PostFetchedOffline extends PostEvent {
  PostFetchedOffline() : super();
}