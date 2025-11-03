import 'package:flutter/material.dart';

class TicketSummaryCard extends StatelessWidget {
  final Map<String, dynamic>? data;

  const TicketSummaryCard({super.key, required this.data});

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
          Text(
            data?['title'] ?? 'Reservasi Tiket',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data?['subtitle'] ?? 'Detail reservasi tiket pendakian',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: _infoColumn(
                  'Lokasi',
                  data?['location'] ??
                      'Kopi Malabar, Pangalengan\nKab. Bandung',
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                flex: 4,
                child: _infoColumn('Biaya Simaksi', data?['price'] ?? 'Rp 0'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: _infoColumn(
                  'No Telepon',
                  data?['phone'] ?? '+6281234567890',
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                flex: 4,
                child: _infoColumn(
                  'Estimasi Perjalanan',
                  data?['duration'] ?? '2-3 hari',
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
