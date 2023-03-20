import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:products_app/providers/product_form_provider.dart';

import 'package:products_app/services/products_services.dart';
import 'package:provider/provider.dart';

import '../ui/input_decoration.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsServices = Provider.of<ProductsServices>(context);

    return ChangeNotifierProvider(
        create: (BuildContext context) =>
            ProductFormProvider(productsServices.productSelected),
        child: _ProductsBodyDetails(productsServices: productsServices));
  }
}

class _ProductsBodyDetails extends StatelessWidget {
  const _ProductsBodyDetails({
    Key? key,
    required this.productsServices,
  }) : super(key: key);

  final ProductsServices productsServices;

  @override
  Widget build(BuildContext context) {
    final productFormProvider = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                _ProductImage(
                    picture: productsServices.productSelected.picture),
                Positioned(
                  top: 50,
                  left: 30,
                  child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 50,
                      )),
                ),
                Positioned(
                  top: 50,
                  right: 50,
                  child: IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? pickedFile = await picker.pickImage(
                          source: ImageSource.camera,
                          imageQuality: 100,
                        );

                        if (pickedFile == null) {
                          return;
                        }

                        productsServices
                            .updateSelectedProductImage(pickedFile.path);
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 50,
                      )),
                ),
              ],
            ),
            const _FormProduct(),
            const SizedBox(height: 90),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
          onPressed: productsServices.isSaving
              ? null
              : () async {
                  if (!productFormProvider.isValidForm()) return;

                  final String? imageURL = await productsServices.uploadImage();

                  if (imageURL != null) {
                    productFormProvider.product.picture = imageURL;
                  }

                  await productsServices
                      .createOrUpdateProduct(productFormProvider.product);

                  Navigator.pop(context);
                },
          child: productsServices.isSaving
              ? const CircularProgressIndicator(
                  color: Colors.white,
                )
              : const Icon(Icons.save)),
    );
  }
}

class _FormProduct extends StatelessWidget {
  const _FormProduct({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productFormProvider = Provider.of<ProductFormProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        width: double.infinity,
        height: 380,
        decoration: _boxDecoration(),
        child: Form(
          key: productFormProvider.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                initialValue: productFormProvider.product.name,
                onChanged: (value) => productFormProvider.product.name = value,
                validator: (value) {
                  if (value == null || value.length < 2) {
                    return "Debe ingresar al menos dos letras.";
                  }
                },
                decoration: AuthInputDecoration.authInputDecoration(
                  hintText: 'Nombre del producto',
                  labelText: 'Nombre',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: '${productFormProvider.product.price}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}')),
                ],
                onChanged: (value) {
                  if (double.tryParse(value) == null) {
                    productFormProvider.product.price = 0;
                  } else {
                    productFormProvider.product.price = double.parse(value);
                  }
                },
                keyboardType: TextInputType.number,
                decoration: AuthInputDecoration.authInputDecoration(
                  hintText: '\$150',
                  labelText: 'Precio',
                ),
              ),
              const SizedBox(height: 20),
              SwitchListTile.adaptive(
                value: productFormProvider.product.available,
                activeColor: Colors.indigo,
                title: const Text('Disponible'),
                onChanged: productFormProvider.updateAvailability,
              ),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() => const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(45),
            bottomRight: Radius.circular(45),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            )
          ]);
}

class _ProductImage extends StatelessWidget {
  final String? picture;

  const _ProductImage({this.picture});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        width: double.infinity,
        height: 450,
        decoration: _boxDecoration(),
        child: Opacity(
          opacity: 0.8,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(45),
              topLeft: Radius.circular(45),
            ),
            child: _imagePicture(picture),
          ),
        ),
      ),
    );
  }

  Widget _imagePicture(String? picture) {
    if (picture == null) {
      return const FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'),
          image: AssetImage('assets/no-image.png'),
          fit: BoxFit.cover);
    }

    if (picture.startsWith('http')) {
      return FadeInImage(
          placeholder: const AssetImage('assets/jar-loading.gif'),
          image: NetworkImage(picture),
          fit: BoxFit.cover);
    }

    return Image.file(
      File(picture),
      fit: BoxFit.cover,
    );
  }

  BoxDecoration _boxDecoration() => BoxDecoration(
          color: Colors.black,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(45),
            topLeft: Radius.circular(45),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ]);
}
