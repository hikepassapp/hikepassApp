import 'package:flutter/material.dart';
import 'rules_item_widget.dart';

class RulesList extends StatelessWidget {
  const RulesList({Key? key}) : super(key: key);

  static const List<String> rules = [
    'pendaki wajib mengisi form registrasi',
    'wajib meninggalkan identitas di ambil waktu turun',
    'pendaki wajib mengikuti briefing atau arahan petugas',
    'dilarang membuat jalur sendiri',
    'dilarang mendirikan tenda di SUN RISE VIEW',
    'dilarang merusak atau mengambil apapun milik petani di sepanjang jalur pendakian',
    'sampah wajib di bawa turun sesuai yang di bawa naik',
    'dilarang membuat api unggun atau yg lainya yg bisa mengakibatkan kebakaran',
    'dilarang membunuh hewan apapun di sepenjang jalur',
    'dilarang membuat keributan yg bisa mengganggu ketertiban umum',
    'dilarang merusak atau melubangi pipa yg ada di jalur pendakian',
    'dilarang foto di tempat yang berbahaya',
    'dilarang membuang sisa makanan sembarangan (sisa makanan wajib untuk di kubur)',
    'pendaki wajib mengikuti peraturan yg berlaku di base camp atau masyarakat sekitar',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        rules.length,
        (index) => RulesItem(
          number: index + 1,
          text: rules[index],
        ),
      ),
    );
  }
}