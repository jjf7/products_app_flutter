import 'package:flutter/material.dart';
import 'package:products_app/screens/screens.dart';
import 'package:products_app/services/services.dart';

import 'package:products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsServices = Provider.of<ProductsServices>(context);
    final authService = Provider.of<AuthService>(context);

    if (productsServices.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products App'),
        leading: IconButton(
            onPressed: () {
              authService.signOut();
              Navigator.pushReplacementNamed(context, 'login');
            },
            icon: const Icon(Icons.logout_rounded)),
      ),
      body: productsServices.products.isEmpty
          ? const Center(child: Text('No hay productos cargados'))
          : RefreshIndicator(
              onRefresh: () async {
                await productsServices.loadProducts();
              },
              child: ListView.builder(
                itemCount: productsServices.products.length,
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () {
                    productsServices.productSelected =
                        productsServices.products[i].copy();

                    Navigator.pushNamed(context, 'productsDetail');
                  },
                  child: ProductsCard(product: productsServices.products[i]),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productsServices.productSelected = Product(
            available: false,
            name: '',
            price: 0,
          );
          Navigator.pushNamed(context, 'productsDetail');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
