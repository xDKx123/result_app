import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_app/login/login.dart';
import 'package:result_app/login/view/login_page.dart';
import 'package:utility_repository/utility_repository.dart';

class IntroductionPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => IntroductionPage());
  }
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  State createState() => _IntroductionPage();
}

class _IntroductionPage extends State<IntroductionPage> {

  Widget _buildLoginPopup(BuildContext context) {
    return AlertDialog(
      title: const Text("Log in"),
      insetPadding: EdgeInsets.all(20),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.3,
        child: BlocProvider(
          create: (context) {
            return LoginBloc(
              authenticationRepository:
              RepositoryProvider.of<AuthenticationRepository>(context),
            );
          },
          child: LoginForm(),
        ),
      ),
    );
  }


  _buildWeb() {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              showDialog(context: context, builder: (BuildContext context) => _buildLoginPopup(context));
            },
            child: Text("Login in"),
          ),

          TextButton(
            onPressed: (){
              //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text("Register"),
          ),
        ],
      ),
    );
  }

  _buildMobile() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(height: MediaQuery.of(context).size.height * 0.2),
            const Text("Result App", textScaleFactor: 3),
            Container(height: MediaQuery.of(context).size.height * 0.45),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text("Log in"),
              ),
            ),

            Container(height: MediaQuery.of(context).size.height * 0.02,),

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text("Register"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return LayoutBuilder(
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
      },
    );
  }
}