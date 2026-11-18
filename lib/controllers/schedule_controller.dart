import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ScheduleController extends GetxController {
  final tmp = GetStorage();

  // Form Controllers
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final descController = TextEditingController();

  // Pilihan Dropdown Fungsional untuk Admin
  var selectedPic = 'Fauzan (Staff Humas)'.obs;
  var selectedCategory = 'Rapat Koordinasi'.obs;

  final List<String> picOptions = [
    'Fauzan (Staff Humas)',
    'Asep (Dokumentasi & Media)',
    'Siti (Publikasi Web)',
    'Tim Humas & Protokol',
  ];

  final List<String> categoryOptions = [
    'Rapat Koordinasi',
    'Publikasi Konten',
    'Peliputan Lapangan',
    'Arsip Dokumen',
  ];

  final isLoading = false.obs;
  var token = ''.obs;

  // Daftar jadwal lokal untuk preview langsung di UI
  var scheduleList = [
    {
      'title': 'Rapat Koordinasi Bulanan',
      'date': '2026-11-15 09:00',
      'pic': 'Fauzan (Staff Humas)',
      'category': 'Rapat Koordinasi',
      'desc': 'Evaluasi konten dan perencanaan publikasi minggu depan.',
    }
  ].obs;

  // URL Endpoint Laravel Anda
  final String baseUrl = 'http://127.0.0.1:8000/api';

  @override
  void onInit() {
    super.onInit();
    token.value = tmp.read('token') ?? '';
  }

  // Fungsi Tambah Jadwal dengan integrasi API Laravel & Fallback lokal
  Future<void> addSchedule() async {
    if (titleController.text.isEmpty || dateController.text.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Judul Acara dan Tanggal wajib diisi!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade800,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Mengirim data ke API Laravel backend (siamba)
      final response = await http.post(
        Uri.parse('$baseUrl/schedules'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${token.value}',
        },
        body: json.encode({
          'title': titleController.text,
          'date': dateController.text,
          'pic': selectedPic.value,
          'category': selectedCategory.value,
          'description': descController.text,
        }),
      );

      // Tambahkan ke list lokal untuk preview instan di UI
      scheduleList.insert(0, {
        'title': titleController.text,
        'date': dateController.text,
        'pic': selectedPic.value,
        'category': selectedCategory.value,
        'desc': descController.text,
      });

      // Bersihkan form setelah input
      titleController.clear();
      dateController.clear();
      descController.clear();

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Sukses',
          'Jadwal & penugasan berhasil disimpan ke server!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4B6043), // Olive Green
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Tersimpan Lokal',
          'Data ditambahkan ke tampilan (Status API: ${response.statusCode})',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      // Fallback jika endpoint /api/schedules di Laravel belum dibuat
      scheduleList.insert(0, {
        'title': titleController.text,
        'date': dateController.text,
        'pic': selectedPic.value,
        'category': selectedCategory.value,
        'desc': descController.text,
      });
      
      titleController.clear();
      dateController.clear();
      descController.clear();

      Get.snackbar(
        'Info',
        'Jadwal ditambahkan ke daftar lokal (Mode Offline/Backend belum siap).',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}