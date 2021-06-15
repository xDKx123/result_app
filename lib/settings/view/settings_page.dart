import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_app/authentication/authentication.dart';
import 'package:utility_repository/utility_repository.dart';

///Settings page, current only with sign out button
class SettingsPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SettingsPage());
  }

  const SettingsPage({Key? key}) : super(key: key);

  @override
  State createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  _buildWeb() {
    return SafeArea(
      child:  Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 6,
          ),
          //_buildMobile(state),
          Expanded(
            child: _buildMobile(),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 6,
          ),
        ],
      ),
    );
  }

  _buildMobile() {
    return ListView(
      children: [
        Card(
          child: InkWell(
            onTap: () async {
              context.read<AuthenticationBloc>().add(AuthenticationLogoutRequested());

              //Navigator.pushAndRemoveUntil(context, LoginPage.route(), (route) => false);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ListTile(
                leading: Icon(Icons.close),
                title: const Text('Log Out'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          switch (ScreenWidth.determineScreen(constraints.maxWidth)) {
            case ScreenWidthStatus.ExtraSmall:
              return _buildMobile();

            case ScreenWidthStatus.Small:
              return _buildMobile();

            case ScreenWidthStatus.Medium:
              return _buildWeb();

            case ScreenWidthStatus.Large:
              return _buildWeb();
          }
        }
      ),
    );
  }
}