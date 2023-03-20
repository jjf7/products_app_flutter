import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:products_app/models/models.dart';

class ProductsServices extends ChangeNotifier {
  final String _baseURL = 'flutter-products-9dcd1-default-rtdb.firebaseio.com';

  final List<Product> products = [];
  bool isLoading = true;
  bool isSaving = false;

  final storage = FlutterSecureStorage();

  late Product productSelected;
  File? newPictureFile;

  ProductsServices() {
    this.loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();

    products.clear();

    final url = Uri.https(
        _baseURL, 'products.json', {"auth": await storage.read(key: 'token')});

    final response = await http.get(url);

    final Map<String, dynamic> mapRes = json.decode(response.body);

    mapRes.forEach((key, value) {
      Product tempProduct = Product.fromJson(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();

    return products;
  }

  Future<void> createOrUpdateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      // CREAR
      await createProduct(product);
    } else {
      // ACTUALIZAR
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseURL, 'products/${product.id}.json',
        {"auth": await storage.read(key: 'token')});

    await http.put(url, body: jsonEncode(product.toJson()));

    products[products.indexWhere((x) => x.id == product.id)] = product;

    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(
        _baseURL, 'products.json', {"auth": await storage.read(key: 'token')});

    final response = await http.post(url, body: jsonEncode(product.toJson()));

    final decodedData = json.decode(response.body);

    //print(decodedData);

    final String id = decodedData['name'];

    product.id = id;

    products.add(product);

    return 'id';
  }

  void updateSelectedProductImage(String path) {
    productSelected.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/xxx/image/upload?upload_preset=xxx');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode != 200 && response.statusCode != 201) {
      return null;
    }

    newPictureFile = null;

    final decodedData = json.decode(response.body);

    return decodedData['secure_url'];
  }
}
