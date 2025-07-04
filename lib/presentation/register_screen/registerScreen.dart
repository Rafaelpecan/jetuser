import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jetrideruser/core/utils/firebase_erros.dart';
import 'package:jetrideruser/domain/firebase_auth/firebaseAuthManager.dart';
import 'package:jetrideruser/presentation/progress_dialog/progress_dialog.dart';
import 'package:jetrideruser/presentation/register_screen/bloc/register_screen_bloc.dart';
import 'package:jetrideruser/routes/app_routes.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  static Widget builder(BuildContext context) {
    return RegisterScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Crie sua Conta', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 61, 107),
      ),
      body: BlocProvider(
        create: (context) =>
            RegisterScreenBloc(authRepo: context.read<EmailAndPassAuth>()),
        child: Form(
          key: _formKey,
          child: _registerForm(),
        ),
      ),
    );
  }
Widget _registerForm() {
  return BlocListener<RegisterScreenBloc, RegisterScreenState>(
    listener: (context, state) {
      final formStatus = state.formStatus;
      if (formStatus is SubmissionFailed) {
        _showSnackBar(
            context, getErrorString(formStatus.exception.toString()));
      }
    },
    child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      children: [ 
        Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset("images/logouser.png")),
          const SizedBox(height:10),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 320, // Adjust the height as needed
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                children: <Widget>[
                  _usernameField(),
                  const SizedBox(height: 16),
                  _emailField(),
                  const SizedBox(height: 16),
                  _passwordField(),
                  const SizedBox(height: 16),
                  _confirmField(),
                  const SizedBox(height: 16),
                  _registerButton(),
                ],
              ),
            ),
          ),
        ],
      )],
    ),
  );
}

  Widget _usernameField() {
    return BlocBuilder<RegisterScreenBloc, RegisterScreenState>(
      builder: (context, state) {
        return TextFormField(
          autocorrect: false,
          obscureText: false,
          decoration: const InputDecoration(
            icon: Icon(Icons.person),
            hintText: 'Nome Completo',
          ),
          validator: ((value) =>
              state.isValidUsername ? null : 'Username invalid is too short'),
          onChanged: (value) => context
              .read<RegisterScreenBloc>()
              .add(RegisterUserNameChanged(username: value)),
        );
      },
    );
  }

  Widget _emailField() {
    return BlocBuilder<RegisterScreenBloc, RegisterScreenState>(
      builder: (context, state) {
        return TextFormField(
          autocorrect: false,
          obscureText: false,
          decoration: const InputDecoration(
            icon: Icon(Icons.email),
            hintText: 'email',
          ),
          validator: (value) =>
              state.isValidemail ? null : 'email is not valid',
          onChanged: (value) => context
              .read<RegisterScreenBloc>()
              .add(RegisterEmailChanged(email: value)),
        );
      },
    );
  }

  Widget _passwordField() {
    return BlocBuilder<RegisterScreenBloc, RegisterScreenState>(
      builder: (context, state) {
        return TextFormField(
          autocorrect: false,
          obscureText: true,
          decoration: const InputDecoration(
            icon: Icon(Icons.security),
            hintText: 'Password',
          ),
          validator: (value) =>
              state.isValidPassword ? null : 'password is too short',
          onChanged: (value) => context
              .read<RegisterScreenBloc>()
              .add(RegisterPasswordChanged(password: value)),
        );
      },
    );
  }

  Widget _confirmField() {
    return BlocBuilder<RegisterScreenBloc, RegisterScreenState>(
      builder: (context, state) {
        return TextFormField(
          autocorrect: false,
          obscureText: true,
          decoration: const InputDecoration(
            icon: Icon(Icons.security),
            hintText: 'Confirm Password',
          ),
          validator: (value) => state.isValidConfirmedPassword
              ? null
              : 'Confirmed Password needs to be same as Password',
          onChanged: (value) => context
              .read<RegisterScreenBloc>()
              .add(RegisterConfirmedPasswordChanged(confirmedPassword: value)),
        );
      },
    );
  }

Widget _registerButton() {
  return BlocListener<RegisterScreenBloc, RegisterScreenState>(
    listener: (context, state) {
      if (state.formStatus is FormSubmitting) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext c) {
            return ProgressDialog(
              message: "Carregando, por favor espere",
            );
          },
        );
      } else if (state.formStatus is SubmissionSuccess) {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(AppRoutes.baseScreen);
      }
    },
    child: BlocBuilder<RegisterScreenBloc, RegisterScreenState>(
      builder: (context, state) {
        return ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              const Color.fromARGB(255, 4, 125, 141),
            ),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<RegisterScreenBloc>().add(RegisterSubmited());
            }
          },
          child: const Text(
            'Criar conta',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    ),
  );
}

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
