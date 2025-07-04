import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarInfoScreen extends StatelessWidget {
  CarInfoScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  static Widget builder(BuildContext context) {
    return CarInfoScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastre os dados do seu Jet',
          style: TextStyle(
            color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 61, 107),
      ),
      body: Form(
        key: _formKey,
        child: _registerForm(),
      ),
    );
  }

  Widget _registerForm() {
    return Center(
      child: Column(
        children: [
          Image.asset("images/brand.png"),
          const SizedBox(height: 10),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              children: <Widget>[
                _jetModelField(),
                const SizedBox(height: 16),
                _jetYearField(),
                const SizedBox(height: 16),
                _JetMainColorField(),
                const SizedBox(height: 16),
                _JetSecondColorField(),
                const SizedBox(height: 16),
                _registerButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _jetModelField() {
        return TextFormField(
          autocorrect: false,
          obscureText: false,
          decoration: const InputDecoration(
            icon: Icon(Icons.branding_watermark_rounded),
            hintText: 'MOdelo do Jetsky (Seado/Yamaha/...)',
          ),
          //validator: ((value) => state.isValidUsername ? null : 'Username invalid is too short'),
          //onChanged: (value) => context.read<RegisterScreenBloc>().add(RegisterUserNameChanged(username: value)),
          );
        }


  Widget _jetYearField() {
        return TextFormField(
          autocorrect: false,
          obscureText: false,
          decoration: const InputDecoration(
            icon: Icon(Icons.email),
            hintText: 'Ano de Fabricação',
          ),
          //validator: (value) => state.isValidemail ? null : 'email is not valid',
          //onChanged: (value) => context.read<RegisterScreenBloc>().add(RegisterEmailChanged(email: value)),
        );
      }

  Widget _JetMainColorField() {
        return TextFormField(
          autocorrect: false,
          obscureText: true,
          decoration: const InputDecoration(
            icon: Icon(Icons.security),
            hintText: 'Cor principal',
          ),
          //validator: (value) => state.isValidPassword ? null : 'password is too short',
          //onChanged: (value) => context.read<RegisterScreenBloc>().add(RegisterPasswordChanged(password: value)),
        );
      }

  Widget _JetSecondColorField() {
    return TextFormField(
      autocorrect: false,
      obscureText: true,
      decoration: const InputDecoration(
        icon: Icon(Icons.security),
        hintText: 'Cor secundaria',
      ),
          //validator: (value) => state.isValidConfirmedPassword ? null : 'Confirmed Password needs to be same as Password',
          //onChanged: (value) => context.read<RegisterScreenBloc>().add(RegisterConfirmedPasswordChanged(confirmedPassword: value)),
    );
  }

  Widget _registerButton() {
    return ElevatedButton(
      style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(
       const Color.fromARGB(255, 0, 128, 192)),
      ),
      onPressed: () {
              //if (_formKey.currentState!.validate()) {
               // context.read<RegisterScreenBloc>().add(RegisterSubmited());
               // if (state.formStatus is SubmissionSuccess){
                //  Navigator.of(context).pushNamed(AppRoutes.baseScreen);
      },
      child: const Text(
        'Cadastrar veiculo',
        style: TextStyle(color: Colors.white),
      )
    );
  }

void _showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}