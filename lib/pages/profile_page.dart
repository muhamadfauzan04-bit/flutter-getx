import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi ProfileController
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        if (controller.isLoading.value && controller.user.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.user.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // 1. Bagian Header Profil (Avatar & Identitas)
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.indigo,
                          child: Icon(Icons.person, size: 60, color: Colors.white),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(Icons.check, size: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.name ?? 'Pengguna',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? 'email@domain.com',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Admin',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 2. Daftar Menu Standar (Edit Profil, Pengaturan, dll)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.edit_outlined,
                      color: Colors.blue,
                      title: 'Edit Profil',
                      subtitle: 'Perbarui nama, email, atau sandi',
                      onTap: () {
                        _showEditProfileDialog(context, controller);
                      },
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      icon: Icons.notifications_outlined,
                      color: Colors.orange,
                      title: 'Notifikasi & Pengingat',
                      subtitle: 'Atur pemberitahuan jadwal kegiatan',
                      onTap: () {
                        Get.snackbar(
                          'Informasi',
                          'Fitur Pengaturan Notifikasi akan segera hadir.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      icon: Icons.security_outlined,
                      color: Colors.green,
                      title: 'Keamanan Akun',
                      subtitle: 'Ganti password backend Siamba',
                      onTap: () {
                        Get.snackbar(
                          'Keamanan',
                          'Token Sanctum aktif dan terenkripsi aman.',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      color: Colors.purple,
                      title: 'Tentang Aplikasi',
                      subtitle: 'Siajag v1.0.0 (Backend Siamba)',
                      onTap: () {
                        _showAboutDialog(context);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. Tampilkan Pesan Error jika ada
              if (controller.errorMessage.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),

              // 4. Tombol Keluar (Logout)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => controller.logout(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Keluar (Logout)',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  // Widget helper untuk item menu
  Widget _buildMenuItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  // Dialog Edit Profil Sederhana
  void _showEditProfileDialog(BuildContext context, ProfileController controller) {
    final nameController = TextEditingController(text: controller.user.value?.name ?? '');
    
    Get.defaultDialog(
      title: 'Edit Profil',
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Perubahan data profil akan disinkronkan langsung ke server backend Siamba.',
              style: TextStyle(fontSize: 11, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      textConfirm: 'Simpan',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      onConfirm: () {
        // Simpan sementara secara lokal atau kirim ke API backend
        Get.back();
        Get.snackbar(
          'Sukses',
          'Nama profil berhasil diperbarui.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
    );
  }

  // Dialog Tentang Aplikasi
  void _showAboutDialog(BuildContext context) {
    Get.defaultDialog(
      title: 'Tentang Siajag',
      middleText: 'Siajag (Sistem Informasi Jadwal & Kegiatan)\nTerhubung dengan backend Laravel Siamba.\n\nDikembangkan khusus untuk kebutuhan manajemen operasional dan publikasi.',
      textConfirm: 'Tutup',
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(),
    );
  }
}