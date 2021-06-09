
import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_app/connectivity/bloc/connectivity_bloc.dart';
import 'package:result_app/posts/posts.dart';
import 'package:result_app/posts/widgets/post_list_item.dart';
import 'package:http/http.dart' as http;

///Listview of contracts
class PostsList extends StatefulWidget {
  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  Future<void> _refreshData() async {
    switch(BlocProvider.of<ConnectivityBloc>(context).state.status) {
      case ConnectivityStatus.connected:
        setState(() {
          PostBloc()..add(PostFetchedOnline());
        });
        break;
      case ConnectivityStatus.disconnected:
        ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: const Text("Not connected to internet")));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        switch (state.status) {
          case PostStatus.failure:
            return const Center(child: Text('failed to fetch posts'));
          case PostStatus.success:
            if (state.posts.isEmpty) {
              return const Center(child: Text('no posts'));
            }
            return RefreshIndicator(child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return PostListItem(post: state.posts[index]);
              },
              itemCount: state.posts.length,

            ), onRefresh: _refreshData);
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }


}