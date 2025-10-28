import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import 'paket_wisata_card.dart';

class PaketWisataList extends StatelessWidget {
  final List<PaketWisataModel> paketList;

  const PaketWisataList({
    Key? key,
    required this.paketList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: paketList.length,
        itemBuilder: (context, index) {
          return PaketWisataCard(paket: paketList[index]);
        },
      ),
    );
  }
}