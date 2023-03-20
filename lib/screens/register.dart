import 'package:flutter/material.dart';
import 'package:products_app/providers/login_form_provider.dart';
import 'package:products_app/services/services.dart';
import 'package:products_app/ui/input_decoration.dart';
import 'package:products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: _ChildCardLogin(),
      ),
    );
  }
}

class _ChildCardLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 200),
          CardScreen(
              child: Column(
            children: [
              const Text('Crear Cuenta',
                  style: TextStyle(color: Colors.black, fontSize: 30)),
              const SizedBox(height: 30),
              ChangeNotifierProvider(
                create: (_) => LoginFormProvider(),
                child: const _FormLogin(),
              )
            ],
          )),
          const SizedBox(height: 30),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'login');
            },
            child: Text('Ya tienes una cuenta?',
                style: Theme.of(context).textTheme.headline6),
          ),
        ],
      ),
    );
  }
}

class _FormLogin extends StatelessWidget {
  const _FormLogin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginFormProvider = Provider.of<LoginFormProvider>(context);

    final authService = Provider.of<AuthService>(context);

    return Form(
      key: loginFormProvider.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            onChanged: (value) => LoginFormProvider.email = value,
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

              RegExp regExp = RegExp(pattern);

              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'El email es incorrecto';
            },
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: AuthInputDecoration.authInputDecoration(
                hintText: 'jhon.doe@doe.com',
                labelText: 'Correo electronico',
                prefixIcon: Icons.alternate_email),
          ),
          const SizedBox(height: 30),
          TextFormField(
            onChanged: (value) => LoginFormProvider.password = value,
            validator: (value) {
              return value != null
                  ? value.length < 7
                      ? 'La contrasena debe ser superior a 7 caracteres'
                      : null
                  : 'Ingrese la contrasena';
            },
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            decoration: AuthInputDecoration.authInputDecoration(
                hintText: '', labelText: 'Contrasena', prefixIcon: Icons.lock),
          ),
          const SizedBox(height: 40),
          MaterialButton(
            onPressed: loginFormProvider.isValidForm()
                ? null
                : () async {
                    FocusScope.of(context).unfocus();

                    if (!loginFormProvider.isValidForm()) return;

                    loginFormProvider.isLoading = true;

                    final resp = await authService.createUser(
                        LoginFormProvider.email, LoginFormProvider.password);

                    if (resp == null) {
                      Navigator.pushReplacementNamed(context, 'products');
                    } else {
                      NotificationsService.showSnacBar(resp);
                      loginFormProvider.isLoading = false;
                    }
                  },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.deepPurple,
            child: Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                width: 300,
                child: Text(
                    loginFormProvider.isLoading ? 'Espere ...' : 'Crear',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))),
          )
        ],
      ),
    );
  }
}
