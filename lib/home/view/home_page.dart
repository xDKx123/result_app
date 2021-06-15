import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_app/authentication/authentication.dart';
import 'package:result_app/connectivity/bloc/connectivity_bloc.dart';
import 'package:result_app/posts/bloc/post_bloc.dart';
import 'package:result_app/posts/posts.dart';
import 'package:result_app/settings/settings.dart';
import 'package:http/http.dart' as http;
import 'package:utility_repository/utility_repository.dart';

class HomePage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }
  const HomePage({Key? key}) : super(key: key);

  @override
  State createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final GlobalKey<PostsListState> _key = GlobalKey();


  _homeButtonWidget() {
    return IconButton(
        onPressed: () async {
          await _key.currentState?.refreshData();
        },
        icon: Icon(Icons.home),
      );
  }

  _homeButton(double width) {
    switch (ScreenWidth.determineScreen(width)) {
      case ScreenWidthStatus.Small:
        return _homeButtonWidget();
      case ScreenWidthStatus.Medium:
       return _homeButtonWidget();
      case ScreenWidthStatus.Large:
        return _homeButtonWidget();
      default:
        return Container(width: 0);
    }
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Result app'),
          centerTitle: true,
          actions: [
            _homeButton(constraints.maxWidth),

            IconButton(icon: Icon(Icons.settings), onPressed: () async {
              Navigator.push(context, SettingsPage.route());
              //setState(() { });
            }
            ),

          ],
        ),
        body: BlocProvider(
          ///if user connected fetch posts from server, else use local storage
          create: (BuildContext context) => PostBloc()..add(BlocProvider.of<ConnectivityBloc>(context).state.status == ConnectivityStatus.connected ? PostFetchedOnline(context) : PostFetchedOffline()),
          child: PostsList(key: _key),
        ),
      );
    });
  }
}