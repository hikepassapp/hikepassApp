import 'package:flutter/material.dart';
import '../../../models/riwayat_model.dart';
import '../../../models/payment_model.dart';

class RiwayatCardItem extends StatelessWidget {
  const RiwayatCardItem({super.key, required this.riwayat, required this.onDetail});
  final RiwayatModel riwayat;
  final VoidCallback onDetail;

  String _fmt(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  @override
  Widget build(BuildContext context) {
    final start = _fmt(riwayat.reservasi.startDate);
    final hikersInfo = riwayat.reservasi.totalTickets > 1
        ? '${riwayat.reservasi.hikerName} +${riwayat.reservasi.totalTickets - 1}'
        : riwayat.reservasi.hikerName;

    final bool isPaid = riwayat.payment?.status == PaymentStatus.paid;
    final paymentTagColor = isPaid ? const Color(0xFFE1F6EB) : const Color(0xFFFFE4C7);
    final paymentTextColor = isPaid ? const Color(0xFF1B8E6A) : const Color(0xFFB05E00);
    final paymentLabel = riwayat.payment == null
        ? 'Menunggu'
        : (isPaid ? 'Lunas' : 'Menunggu');

    final hikingLabel = () {
      switch (riwayat.hikingStatus) {
        case HikingHistoryStatus.waiting:
          return 'Menunggu';
        case HikingHistoryStatus.hiking:
          return 'Mendaki';
        case HikingHistoryStatus.finished:
          return 'Selesai';
      }
    }();

    final hikingColors = () {
      switch (riwayat.hikingStatus) {
        case HikingHistoryStatus.waiting:
          return (bg: const Color(0xFFFFE4C7), fg: const Color(0xFFB05E00));
        case HikingHistoryStatus.hiking:
          return (bg: const Color(0xFFE2EFFF), fg: const Color(0xFF2F6BBA));
        case HikingHistoryStatus.finished:
          return (bg: const Color(0xFFE1F6EB), fg: const Color(0xFF1B8E6A));
      }
    }();

    return Material(
      elevation: 2,
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kode Reservasi',
                        style: TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        riwayat.reservasi.code.isNotEmpty ? riwayat.reservasi.code : '-',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Row(
                  children: [
                    _Chip(text: paymentLabel, bg: paymentTagColor, fg: paymentTextColor),
                    const SizedBox(width: 6),
                    _Chip(text: hikingLabel, bg: hikingColors.bg, fg: hikingColors.fg),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        riwayat.reservasi.mountainName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        riwayat.reservasi.hikingTrail,
                        style: const TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                      Text(start, style: const TextStyle(color: Colors.black54, fontSize: 13)),
                      Text(
                        'Pendaki: $hikersInfo',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: onDetail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E4A45),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text('Detail', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text, required this.bg, required this.fg});
  final String text;
  final Color bg;
  final Color fg;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }
}
