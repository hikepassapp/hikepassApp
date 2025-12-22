import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../models/laporan_model.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_typography.dart';
import '../widgets/detail_info_row.dart';

class LaporanDetailView extends StatelessWidget {
  const LaporanDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final LaporanModel laporan = Get.arguments as LaporanModel;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.navy),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Detail Laporan',
          style: AppTypography.h3.copyWith(color: AppColors.navy),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        toolbarHeight: 60,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (laporan.fotoUrl != null && laporan.fotoUrl!.isNotEmpty)
              _buildPhotoSection(laporan.fotoUrl!),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          laporan.namaPelapor,
                          style: AppTypography.h2.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Dilaporkan',
                          style: AppTypography.sRegular.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  DetailInfoRow(
                    icon: Icons.calendar_today,
                    label: 'Tanggal Kejadian',
                    value: DateFormat(
                      'EEEE, dd MMMM yyyy',
                      'id_ID',
                    ).format(laporan.tanggalKejadian),
                  ),
                  const SizedBox(height: 12),
                  DetailInfoRow(
                    icon: Icons.location_on,
                    label: 'Lokasi Kejadian',
                    value: laporan.lokasiKejadian,
                  ),
                  const SizedBox(height: 12),
                  DetailInfoRow(
                    icon: Icons.access_time,
                    label: 'Waktu Pelaporan',
                    value: laporan.createdAt != null
                        ? DateFormat(
                            'dd MMM yyyy, HH:mm',
                            'id_ID',
                          ).format(laporan.createdAt!)
                        : '-',
                  ),
                  const SizedBox(height: 24),
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 24),
                  Text(
                    'Deskripsi Kejadian',
                    style: AppTypography.h3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Text(
                      laporan.deskripsiKejadian,
                      style: AppTypography.mRegular.copyWith(
                        color: Colors.grey[800],
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection(String photoUrl) {
    return Hero(
      tag: 'laporan-photo-$photoUrl',
      child: Container(
        width: double.infinity,
        height: 300,
        color: Colors.black,
        child: Image.network(
          photoUrl,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
