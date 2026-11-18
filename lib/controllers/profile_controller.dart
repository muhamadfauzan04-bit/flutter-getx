import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class UserModel {
  final int id;
  final String name;
  final String email;

  UserModel({required this.id, required this.name, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '-',
      email: json['email']?.toString() ?? '-',
    );
  }
}

class ProfileController extends GetxController {
  final tmp = GetStorage();
  final _storage = const FlutterSecureStorage();

  var isLoading = true.obs;
  var user = Rxn<UserModel>();
  var errorMessage = ''.obs;

  static const String baseUrl = 'http://127.0.0.1:8000/api';

  @override
  void onInit() {
    super.onInit();
    final cachedName = tmp.read('name');
    final cachedEmail = tmp.read('email');
    final cachedId = tmp.read('id');
    if (cachedName != null || cachedEmail != null) {
      user.value = UserModel(
        id: int.tryParse(cachedId?.toString() ?? '0') ?? 0,
        name: cachedName?.toString() ?? '-',
        email: cachedEmail?.toString() ?? '-',
      );
    }
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading(true);
      errorMessage('');

      String? token = tmp.read('token');
      token ??= await _storage.read(key: 'token');

      if (token == null || token.isEmpty) {
        errorMessage('Token tidak ditemukan. Silakan login kembali.');
        return;
      }

      // Diarahkan langsung ke endpoint /api/user sesuai routes/api.php
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userJson = data['user'] ?? data['data'] ?? data;
        user.value = UserModel.fromJson(userJson);

        tmp.write('id', user.value?.id);
        tmp.write('name', user.value?.name);
        tmp.write('email', user.value?.email);
      } else {
        errorMessage(
          'Gagal memuat data dari /api/profile (${response.statusCode}).',
        );
      }
    } catch (e) {
      errorMessage('Gagal terhubung ke server Laravel.');
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      String? token = tmp.read('token');
      token ??= await _storage.read(key: 'token');

      if (token != null && token.isNotEmpty) {
        await http.post(
          Uri.parse('$baseUrl/logout'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
    } catch (_) {
      // Tetap lanjut hapus sesi lokal meski server offline
    } finally {
      await tmp.erase();
      await _storage.deleteAll();
      Get.offAllNamed('/login');
    }
  }
}