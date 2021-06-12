//import 'dart:js';

import 'package:connectivity_repository/connectivity_repository.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_app/connectivity/bloc/connectivity_bloc.dart';
import 'package:result_app/login/login.dart';

///Login form has username and password input field and button to submit
class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                  content: Text('Authentication Failure'),
              ),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _UsernameInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _PasswordInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _LoginButton(),
          ],
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_usernameInput_textField'),
          onChanged: (username) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(username)),
          decoration: InputDecoration(
            labelText: 'username',
            errorText: state.username.invalid ? 'Invalid username' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          textInputAction: TextInputAction.go,
          onSubmitted: (_) {
            context.read<LoginBloc>().add(const LoginSubmitted());
          },
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'password',
            errorText: state.password.invalid ? 'Invalid password' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  dynamic  _buttonEvent(BuildContext context, LoginState state) {
    if (BlocProvider.of<ConnectivityBloc>(context).state.status == ConnectivityStatus.disconnected) {
      ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: const Text("Enable internet connection")));
      return ElevatedButton(
        key: const Key('loginForm_continue_raisedButton'),
        child: const Text('Login'),
        onPressed: state.status.isValidated
            ? () {
          context.read<LoginBloc>().add(const LoginSubmitted());
        }
            : null,);
    }
    
    if (state.status.isSubmissionInProgress) {
      return const CircularProgressIndicator();
    }
    else {
      return ElevatedButton(
          key: const Key('loginForm_continue_raisedButton'),
          child: const Text('Login'),
          onPressed: state.status.isValidated
              ? () {
            context.read<LoginBloc>().add(const LoginSubmitted());
          }
              : null,);
    }
    
    
    return state.status.isSubmissionInProgress
        ? const CircularProgressIndicator()
        : ElevatedButton(
      key: const Key('loginForm_continue_raisedButton'),
      child: const Text('Login'),
      onPressed: state.status.isValidated
          ? () {
        context.read<LoginBloc>().add(const LoginSubmitted());
      }
          : null,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                child: const Text('Login'),
                onPressed: () {
                  if (BlocProvider.of<ConnectivityBloc>(context).state.status == ConnectivityStatus.disconnected) {
                    ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: const Text("Enable internet connection")));
                    return;
                  }

                  if (state.status.isValidated) {
                    context.read<LoginBloc>().add(const LoginSubmitted());
                  }

                  /*state.status.isValidated
                      ? () {
                    context.read<LoginBloc>().add(const LoginSubmitted());
                  }
                      : null,*/
                }
              );
      },
    );
  }
}
