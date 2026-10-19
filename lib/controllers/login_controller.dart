import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future<void> login() async {
    var response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': emailController.text, //emilys
        'password': passwordController.text, //emilyspass
      }),
    );

    if (response.statusCode == 200) {
      Get.snackbar(
        "Success",
        "Selamat Datang",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offNamed('/dashboard');
    } else {
      final error = jsonDecode(response.body);
      Get.snackbar(
        'Error',
        'Login gagal ' + error['message'],
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}