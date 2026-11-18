import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/schedule_controller.dart';
import '../theme/app_theme.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScheduleController controller = Get.put(ScheduleController());

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form Card Input Admin
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.edit_calendar, color: AppTheme.primaryOlive, size: 24),
                      SizedBox(width: 10),
                      Text(
                        'Input Acara & Penugasan Admin',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Nama Acara
                  TextField(
                    controller: controller.titleController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Acara / Kegiatan',
                      hintText: 'Contoh: Peliputan Rapat Pimpinan',
                      prefixIcon: Icon(Icons.event_outlined, color: AppTheme.primaryOlive),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Tanggal & Waktu
                  TextField(
                    controller: controller.dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal & Waktu',
                      hintText: 'Pilih tanggal pelaksanaan',
                      prefixIcon: Icon(Icons.calendar_today_outlined, color: AppTheme.primaryOlive),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2025),
                        lastDate: DateTime(2030),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: AppTheme.primaryOlive,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedDate != null) {
                        controller.dateController.text =
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                      }
                    },
                  ),
                  const SizedBox(height: 14),

                  // Dropdown Kategori Kegiatan
                  Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedCategory.value,
                        decoration: const InputDecoration(
                          labelText: 'Kategori Kegiatan',
                          prefixIcon: Icon(Icons.category_outlined, color: AppTheme.primaryOlive),
                        ),
                        items: controller.categoryOptions.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            controller.selectedCategory.value = newValue;
                          }
                        },
                      )),
                  const SizedBox(height: 14),

                  // Dropdown Penugasan Staff / PIC
                  Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedPic.value,
                        decoration: const InputDecoration(
                          labelText: 'Penugasan Staff (PIC)',
                          prefixIcon: Icon(Icons.assignment_ind_outlined, color: AppTheme.primaryOlive),
                        ),
                        items: controller.picOptions.map((String pic) {
                          return DropdownMenuItem<String>(
                            value: pic,
                            child: Text(pic),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            controller.selectedPic.value = newValue;
                          }
                        },
                      )),
                  const SizedBox(height: 14),

                  // Catatan / Instruksi
                  TextField(
                    controller: controller.descController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Catatan / Instruksi Tugas',
                      hintText: 'Tambahkan instruksi khusus...',
                      prefixIcon: Icon(Icons.notes_outlined, color: AppTheme.primaryOlive),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tombol Simpan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => controller.addSchedule(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryOlive,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.save_outlined, color: Colors.white),
                      label: const Text(
                        'Simpan & Buat Penugasan',
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Daftar Jadwal & Penugasan Aktif',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 12),

            // List Daftar Jadwal
            Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.scheduleList.length,
                  itemBuilder: (context, index) {
                    final item = controller.scheduleList[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item['title'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textDark,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryOlive.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item['category'] ?? '',
                                  style: const TextStyle(
                                    color: AppTheme.primaryOlive,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 14, color: AppTheme.textGrey),
                              const SizedBox(width: 6),
                              Text(
                                item['date'] ?? '',
                                style: const TextStyle(fontSize: 13, color: AppTheme.textGrey),
                              ),
                              const SizedBox(width: 16),
                              const Icon(Icons.person_outline, size: 14, color: AppTheme.textGrey),
                              const SizedBox(width: 6),
                              Text(
                                item['pic'] ?? '',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textDark),
                              ),
                            ],
                          ),
                          if ((item['desc'] ?? '').isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              item['desc']!,
                              style: const TextStyle(color: AppTheme.textGrey, fontSize: 13),
                            ),
                          ]
                        ],
                      ),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}