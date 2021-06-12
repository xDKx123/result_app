
import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_app/connectivity/bloc/connectivity_bloc.dart';
import 'package:result_app/posts/posts.dart';
import 'package:result_app/posts/widgets/post_list_item.dart';
import 'package:http/http.dart' as http;
import 'package:result_app/settings/view/settings_page.dart';
import 'package:utility_repository/utility_repository.dart';

///Listview of contracts
class PostsList extends StatefulWidget {
  const PostsList({Key? key}) : super(key: key);

  @override
  PostsListState createState() => PostsListState();
}

class PostsListState extends State<PostsList> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshData() async {
    refreshKey.currentState?.show(
      atTop:  true);
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

  _buildWeb(BuildContext context, PostState state) {
    return SafeArea(
      child:  Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 6,
          ),
          //_buildMobile(state),
          Expanded(
            child: _buildMobile(state),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 6,
          ),
        ],
      ),
    );
  }


  _buildMobile(PostState state) {
    switch (state.status) {
      case PostStatus.failure:
        return const Center(child: Text('failed to fetch posts'));
      case PostStatus.success:
        if (state.posts.isEmpty) {
          return const Center(child: Text('no posts'));
        }
        return RefreshIndicator(
          key: refreshKey,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return PostListItem(post: state.posts[index]);
              },
              itemCount: state.posts.length,

            ),
          onRefresh: refreshData);
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              switch (ScreenWidth.DetermineScreen(constraints.maxWidth)) {
                case ScreenWidthStatus.ExtraSmall:
                  return _buildMobile(state);

                case ScreenWidthStatus.Small:
                  return _buildMobile(state);

                case ScreenWidthStatus.Medium:
                  return _buildWeb(context, state);

                case ScreenWidthStatus.Large:
                  return _buildWeb(context, state);
              }
          }
        );
      }
    );
  }
}