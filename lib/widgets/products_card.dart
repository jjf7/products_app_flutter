import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductsCard extends StatelessWidget {
  final Product product;
  const ProductsCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
          width: double.infinity,
          height: 450,
          decoration: _boxDecoration(),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              _BackgroundProductImage(picture: product.picture),
              _ProductDetails(title: product.name, subTitle: product.id!),
              Positioned(
                top: 0,
                right: 0,
                child: _ProductPriceTag(price: product.price),
              ),
              if (!product.available)
                Positioned(
                  top: 0,
                  left: 0,
                  child: _ProductNotAvailable(),
                ),
            ],
          )),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: const [
        BoxShadow(
          blurRadius: 10,
          offset: Offset(0, 5),
          color: Colors.black12,
        ),
      ],
    );
  }
}

class _ProductNotAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: 120,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.yellow[700],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: const FittedBox(
        fit: BoxFit.cover,
        child: Text(
          'Not available...',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class _ProductPriceTag extends StatelessWidget {
  final double price;

  const _ProductPriceTag({super.key, required this.price});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: 120,
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.cover,
        child: Text(
          '\$$price',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final String title;
  final String subTitle;

  const _ProductDetails(
      {super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        height: 70,
        decoration: _boxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(
              'ID: $subTitle',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return const BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ));
  }
}

class _BackgroundProductImage extends StatelessWidget {
  final String? picture;

  const _BackgroundProductImage({this.picture});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 450,
        child: picture == null
            ? const FadeInImage(
                placeholder: AssetImage('assets/jar-loading.gif'),
                image: AssetImage('assets/no-image.png'),
                fit: BoxFit.cover)
            : FadeInImage(
                placeholder: const AssetImage('assets/jar-loading.gif'),
                image: NetworkImage(picture!),
                fit: BoxFit.cover),
      ),
    );
  }
}
