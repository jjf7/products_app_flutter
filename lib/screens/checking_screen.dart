import 'package:flutter/material.dart';
import 'package:products_app/screens/screens.dart';
import 'package:products_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class CheckingScreen extends StatelessWidget {
  const CheckingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.readToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) return const Text('Validando...');

            if (snapshot.data != "") {
              // todo ha ido bien muchachote, enviame al listado de productos
              Future.microtask(() => Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const ProductsScreen(),
                      transitionDuration: const Duration(seconds: 0),
                    ),
                  ));
            } else {
              Future.microtask(() => Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const LoginScreen(),
                      transitionDuration: const Duration(seconds: 0),
                    ),
                  ));
            }

            return Container();
          },
        ),
      ),
    );
  }
}
