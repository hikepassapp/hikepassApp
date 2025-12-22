import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reservasi_controller.dart';
import 'reservation_form_view.dart';
import 'package:hikepass_app/app/shared/theme/app_colors.dart';

class HikersListView extends GetView<ReservasiController> {
  const HikersListView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pendaki'),
        backgroundColor: AppColors.secondary,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            final count = controller.ticketCount.value;
            controller.ensureHikersCount(count);

            return ListView.separated(
              itemCount: count,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final hiker = controller.getHiker(index) ?? {};
                final hasData = hiker.isNotEmpty;

                return InkWell(
                  onTap: () {
                    Get.to(
                      () => ReservationFormView(),
                      arguments: {'index': index, 'reservation': data},
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Text('${index + 1}'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hasData
                                    ? (hiker['nama'] ?? 'Pendaki ${index + 1}')
                                          .toString()
                                    : 'Pendaki ${index + 1}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                hasData
                                    ? (hiker['nik'] ?? '').toString()
                                    : 'Tekan untuk mengisi data',
                                style: TextStyle(
                                  color: hasData ? Colors.black54 : Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.to(
                              () => ReservationFormView(),
                              arguments: {'index': index, 'reservation': data},
                            );
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            height: 48,
            child: Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.areAllHikersComplete.value
                      ? AppColors.secondary
                      : Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: controller.areAllHikersComplete.value
                    ? () {
                        Get.toNamed('/reservation-payment', arguments: data);
                      }
                    : null,
                child: Text(
                  'Lanjutkan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: controller.areAllHikersComplete.value
                        ? Colors.white
                        : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
