import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class DashboardController extends GetxController {
  final tmp = GetStorage();

  var token = ''.obs;
  var username = ''.obs;
  var email = ''.obs;

  final isLoading = false.obs;
  
  // Tab Bar Index (0: Beranda, 1: Kegiatan, 2: Profil)
  var tabIndex = 0.obs;

  // Variabel Statistik Kegiatan & Publikasi
  final totalKegiatan = 0.obs;
  final agendaHariIni = 0.obs;
  final publikasiSelesai = 0.obs;
  final totalArsip = 0.obs;

  final String baseUrl = 'http://127.0.0.1:8000/api';

  @override
  void onInit() {
    super.onInit();
    token.value = tmp.read('token') ?? '';
    username.value = tmp.read('name') ?? '';
    email.value = tmp.read('email') ?? '';
    
    fetchDashboardData();
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  Future<void> fetchDashboardData() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dashboard'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.value}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        totalKegiatan.value = data['total_kegiatan'] ?? 0;
        agendaHariIni.value = data['agenda_hari_ini'] ?? 0;
        publikasiSelesai.value = data['publikasi_selesai'] ?? 0;
        totalArsip.value = data['total_arsip'] ?? 0;
      }
    } catch (e) {
      // Tangani error jaringan
    } finally {
      isLoading.value = false;
    }
  }
}