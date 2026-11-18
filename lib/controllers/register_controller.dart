import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class RegisterController extends GetxController {
  // Inisialisasi Storage agar sama dengan ProfileController
  final tmp = GetStorage();
  final _storage = const FlutterSecureStorage();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  var isPasswordVisible = false.obs;
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  Future<void> register() async {
    final nameInput = nameController.text.trim();
    final emailInput = emailController.text.trim();
    final passwordInput = passwordController.text.trim();

    if (nameInput.isEmpty || emailInput.isEmpty || passwordInput.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Nama, Email, dan password tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade100,
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': nameInput,
          'email': emailInput,
          'password': passwordInput,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // 1. Ambil token dan data user dari respons Laravel Sanctum
        final token = data['access_token'] ?? data['token'] ?? data['data']?['token'];
        final userJson = data['user'] ?? data['data'] ?? data;

        // 2. Simpan token ke GetStorage & FlutterSecureStorage
        if (token != null) {
          await tmp.write('token', token);
          await _storage.write(key: 'token', value: token);
        }

        // 3. Simpan data profil user agar langsung tampil di ProfilePage
        if (userJson is Map<String, dynamic>) {
          if (userJson['id'] != null) await tmp.write('id', userJson['id']);
          if (userJson['name'] != null) await tmp.write('name', userJson['name']);
          if (userJson['email'] != null) await tmp.write('email', userJson['email']);
        }

        Get.snackbar(
          'Sukses',
          data['message'] ?? 'Registrasi berhasil!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
        );

        // Pindah ke dashboard, profil akan otomatis membaca data yang baru disimpan
        Get.offAllNamed('/dashboard');
      } else {
        final errorData = jsonDecode(response.body);

        String errorMessage =
            errorData['message'] ?? 'Gagal melakukan registrasi';

        if (errorData['errors'] != null) {
          errorMessage = errorData['errors'].values.first[0];
        }

        Get.snackbar(
          'Gagal Registrasi',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Koneksi',
        'Gagal terhubung ke server: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}