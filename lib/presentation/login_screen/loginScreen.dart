import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jetrideruser/domain/firebase_auth/firebaseAuthManager.dart';
import 'package:jetrideruser/presentation/login_screen/bloc/login_screen_bloc.dart';
import 'package:jetrideruser/presentation/progress_dialog/progress_dialog.dart';
import 'package:jetrideruser/routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  static Widget builder(BuildContext context) {
    return LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Entrar',
          style: TextStyle(
            color: Colors.white
          ),
        ),
        centerTitle: true,
        actions: <Widget> [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.registerScreen);
            },
            child: const Text('Criar Conta',
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: BlocProvider(
          create: (context) => LoginScreenBloc(authRepo: context.read<EmailAndPassAuth>()),
          child: _loginForm(context),
        ),
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      children: <Widget> [ 
        Column(
        children: [
          Image.asset("images/logouser.png"),
          const SizedBox(height: 10),
          Center(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: <Widget>[
                  _usernameField(),
                  _passwordField(),
                  _loginButton(),
                  _forgetPasswordButton(),
                ],
              ),
            ),
          ),
        ],
      )],
    );
  }

  Widget _passwordField() {
    return BlocBuilder<LoginScreenBloc, LoginScreenState>(
      builder: (context, state) {
        return TextFormField(
          autocorrect: false,
          obscureText: true,
          decoration: const InputDecoration(
            icon: Icon(Icons.security),
              hintText: 'Password',
            ),
              validator: (value) => state.isValidPassword ? null : 'password is too short',
              onChanged: (value) => context.read<LoginScreenBloc>().add(LoginPasswordChanged(password: value),
          ));
      }
    );
}

  Widget _usernameField() {
  return BlocBuilder<LoginScreenBloc, LoginScreenState>(
    builder: (context, state) {
      return TextFormField(
        obscureText: false,
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        decoration: const InputDecoration(
          icon: Icon(Icons.person),
          hintText: 'E-mail',
        ),
        validator: (value) => state.isValidUsername ? null : 'email is too short',
        onChanged: ((value) => context.read<LoginScreenBloc>().add(LoginUserNameChanged(username: value),
        )
      ));
    }
  );
}

Widget _loginButton() {
  return BlocListener<LoginScreenBloc, LoginScreenState>(
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
      } else if (state.formStatus is SubmissionFailed) {
          Navigator.of(context).pop();
        _showSnackBar(context, (state.formStatus as SubmissionFailed).exception);
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.loginScreen, (route)=> false);
          
      }
    },
    child: BlocBuilder<LoginScreenBloc, LoginScreenState>(
      builder: (context, state) {
        return ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              const Color.fromARGB(255, 4, 125, 141),
            ),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<LoginScreenBloc>().add(LoginSubmited());
            }
          },
          child: const Text(
            'Logar',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    ),
  );
}


Widget _forgetPasswordButton() {
  return Align(
    alignment: Alignment.centerRight,
    child: Padding(
      padding: EdgeInsets.zero,
      child: TextButton(
        onPressed: () {},
        child: const Text('Esqueci minha senha'),
      ),
    ),
  );
}

void _showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}