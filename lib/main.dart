import 'package:flutter/material.dart';

import 'package:products_app/screens/screens.dart';
import 'package:products_app/services/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsServices()),
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mis Patas Sucias',
      initialRoute: 'checking',
      scaffoldMessengerKey: NotificationsService.messengerKey,
      routes: {
        'checking': (_) => const CheckingScreen(),
        'home': (_) => const HomeScreen(),
        'products': (_) => const ProductsScreen(),
        'productsDetail': (_) => const ProductDetailScreen(),
        'login': (_) => const LoginScreen(),
        'register': (_) => const RegisterScreen(),
      },
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[200],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.indigo,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            elevation: 0,
            backgroundColor: Colors.indigo,
          )),
    );
  }
}
