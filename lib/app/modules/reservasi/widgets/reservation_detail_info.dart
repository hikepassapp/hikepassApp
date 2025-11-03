import 'package:flutter/material.dart';

class ReservationDetailInfo extends StatelessWidget {
  // Ubah dari Map<String, String> ke Map<String, dynamic>
  final Map<String, dynamic> data;

  const ReservationDetailInfo({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul
          Text(
            data['title'] ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),

          // Subtitle
          Text(
            data['subtitle'] ?? '',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Baris 1
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: _infoColumn(
                  'Lokasi',
                  data['location'] ??
                      'Kopi Malabar, Pangalengan\nKab. Bandung', // fallback lokasi default
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                flex: 4,
                child: _infoColumn('Biaya Simaksi', data['harga'] ?? '-'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Baris 2
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: _infoColumn(
                  'No Telepon',
                  data['phoneNumber'] ?? '+6281234567890',
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                flex: 4,
                child: _infoColumn(
                  'Estimasi Perjalanan',
                  data['estimasi'] ?? data['duration'] ?? '-',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }
}
