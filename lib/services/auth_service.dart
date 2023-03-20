import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = "identitytoolkit.googleapis.com";
  final String _firebeseToken = "xxxx";

  final storage = FlutterSecureStorage();

  Future<String?> createUser(String email, String password) async {
    Map<String, dynamic> data = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final url = Uri.https(_baseUrl, 'v1/accounts:signUp', {
      'key': _firebeseToken,
    });

    final resp = await http.post(url, body: json.encode(data));

    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      // Guardar token en lugar seguro
      await storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp["error"]["message"];
    }
  }

  Future<String?> login(String email, String password) async {
    Map<String, dynamic> data = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final url = Uri.https(_baseUrl, 'v1/accounts:signInWithPassword', {
      'key': _firebeseToken,
    });

    final resp = await http.post(url, body: json.encode(data));

    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      // Guardar token en lugar seguro
      await storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp["error"]["message"];
    }
  }

  Future signOut() async {
    return await storage.delete(key: 'token');
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
