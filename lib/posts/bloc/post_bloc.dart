import 'dart:async';
import 'dart:convert';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:result_app/connectivity/bloc/connectivity_bloc.dart';
import 'package:result_app/connectivity/connectivity.dart';
import 'package:result_app/posts/posts.dart';
import 'package:http/http.dart' as http;
import 'package:utility_repository/utility_repository.dart';
//import 'package:rxdart/rxdart.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:result_app/authentication/authentication.dart';

part 'post_event.dart';
part 'post_state.dart';

//const _postLimit = 20;

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(const PostState());

  @override
  Stream<Transition<PostEvent, PostState>> transformEvents(
      Stream<PostEvent> events,
      TransitionFunction<PostEvent, PostState> transitionFn,
      ) {
    return super.transformEvents(
      events,
      transitionFn,
    );
  }

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is PostFetchedOnline) {
      yield await _mapPostFetchedToStateOnline(state);
    }
    else if (event is PostFetchedOffline) {
      yield await _mapPostFetchedToStateOffline(state);
    }
  }

  Future<PostState> _mapPostFetchedToStateOnline(PostState state) async {
    //if (state.hasReachedMax) return state;
    try {
      if (state.status == PostStatus.initial) {
        final posts = await _fetchPostsOnline();
        return state.copyWith(
          status: PostStatus.success,
          posts: posts,
          //hasReachedMax: true,
        );
      }
      final posts = await _fetchPostsOnline();
      return state.copyWith(
        status: PostStatus.success,
        posts: List.of(state.posts)..addAll(posts),
        //hasReachedMax: true,
      );
    } on Exception {
      return state.copyWith(status: PostStatus.failure);
    }
  }

  Future<PostState> _mapPostFetchedToStateOffline(PostState state) async {
    //if (state.hasReachedMax) return state;
    try {
      final posts = await _fetchPostsOffline();
      return state.copyWith(
        status: PostStatus.success,
        posts: posts,
      );
    } on Exception {
      return state.copyWith(status: PostStatus.failure);
    }
  }

  Future<List<Post>> _fetchPostsOnline() async {
    final response = await HttpMethods.getContracts(await LocalStorageHelper.getToken());
    if (response == null) {
      return [];
    }

    final body = response as List;
    return body.map((dynamic json) {
      return Post(
        content: json as Map<String, dynamic>
      );
    }).toList();
    throw Exception('error fetching posts');
  }

  Future<List<Post>> _fetchPostsOffline() async {
    final response = await LocalStorageHelper.getContracts();

    final body = response as List;
    return body.map((dynamic json) {
      return Post(
          content: json as Map<String, dynamic>
      );
    }).toList();
    throw Exception('error fetching posts');
  }
}