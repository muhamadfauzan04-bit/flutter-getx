import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import '../theme/app_theme.dart';
import 'profile_page.dart';
import 'schedule_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());

    final List<Widget> pages = [
      _buildHomeTab(controller),
      _buildKegiatanTab(controller),
      const SchedulePage(),
      const ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          switch (controller.tabIndex.value) {
            case 0:
              return const Text('Dashboard');
            case 1:
              return const Text('Manajemen Kegiatan');
            case 2:
              return const Text('Schedule & Penugasan');
            case 3:
              return const Text('Akun');
            default:
              return const Text('Siajag');
          }
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              controller.totalKegiatan.refresh();
              controller.agendaHariIni.refresh();
              controller.publikasiSelesai.refresh();
              controller.totalArsip.refresh();
            },
          ),
        ],
      ),
      body: Obx(() => pages[controller.tabIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.tabIndex.value,
          onTap: controller.changeTabIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note_outlined),
              activeIcon: Icon(Icons.event_note),
              label: 'Kegiatan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_calendar_outlined),
              activeIcon: Icon(Icons.edit_calendar),
              label: 'Schedule',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // Tampilan Tab Beranda dengan Tema Hijau Olive
  Widget _buildHomeTab(DashboardController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Utama dengan Gradasi Hijau Olive
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryOlive, Color(0xFF6B8E5F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryOlive.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                  size: 36,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Text(
                  'Halo ${controller.username.value.isNotEmpty ? controller.username.value : "Pengguna"}!',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Panel Kontrol Manajemen Kegiatan & Publikasi',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Statistik Sistem',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard(
                'Total Kegiatan',
                controller.totalKegiatan.value.toString(),
                Icons.event_note,
                AppTheme.primaryOlive,
              ),
              _buildStatCard(
                'Agenda Hari Ini',
                controller.agendaHariIni.value.toString(),
                Icons.today,
                Colors.amber.shade800,
              ),
              _buildStatCard(
                'Publikasi Selesai',
                controller.publikasiSelesai.value.toString(),
                Icons.check_circle_outline,
                Colors.teal,
              ),
              _buildStatCard(
                'Total Arsip',
                controller.totalArsip.value.toString(),
                Icons.folder_open,
                Colors.brown.shade400,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKegiatanTab(DashboardController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daftar Agenda & Kegiatan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: [
                _buildActivityItem(
                  'Rapat Koordinasi Humas',
                  'Hari ini, 09:00 WIB',
                  AppTheme.primaryOlive,
                ),
                _buildActivityItem(
                  'Publikasi Konten Website',
                  'Besok, 13:30 WIB',
                  Colors.amber.shade800,
                ),
                _buildActivityItem(
                  'Peliputan Kegiatan Daerah',
                  '15 November 2026',
                  Colors.teal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(title, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(Icons.task, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
        subtitle: Text(time, style: TextStyle(color: Colors.grey[600])),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey,
        ),
      ),
    );
  }
}
