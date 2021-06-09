import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_app/authentication/authentication.dart';
import 'package:result_app/login/view/login_page.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body:
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
    );
  }
}