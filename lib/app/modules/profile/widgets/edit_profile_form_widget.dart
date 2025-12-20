import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class EditProfileFormWidget extends GetView<ProfileController> {
  const EditProfileFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Informasi Profil Section
          Text(
            'Informasi Profil',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),

          // NIK Field
          _buildLabel('NIK', required: true),
          _buildTextField(
            initialValue: controller.nik.value,
            readOnly: false,
            fillColor: Colors.grey[100],
          ),
          SizedBox(height: 16),

          // Nama Lengkap Field
          _buildLabel('Nama Lengkap', required: true),
          _buildTextField(
            initialValue: controller.namaLengkap.value,
            onChanged: (value) => controller.namaLengkap.value = value,
          ),
          SizedBox(height: 16),

          // Kontak Field
          _buildLabel('Kontak', required: true),
          Row(
            children: [
              Container(
                width: 80,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Obx(
                    () => Text(
                      controller.countryCode.value,
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildTextField(
                  initialValue: controller.kontak.value,
                  onChanged: (value) => controller.kontak.value = value,
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Tanggal Lahir & Usia
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Tanggal Lahir', required: true),
                    _buildTextField(
                      initialValue: controller.tanggalLahir.value,
                      onChanged: (value) =>
                          controller.tanggalLahir.value = value,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              // Expanded(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       _buildLabel('Usia'),
              //       _buildTextField(
              //         initialValue: controller.usia.value,
              //         readOnly: true,
              //         fillColor: Colors.grey[100],
              //         textAlign: TextAlign.center,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          SizedBox(height: 16),

          // Jenis Kelamin
          _buildLabel('Jenis Kelamin', required: true),
          SizedBox(height: 8),
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: _buildRadioButton(
                    title: 'Laki-laki',
                    value: 'Laki-laki',
                    groupValue: controller.jenisKelamin.value,
                    onChanged: (value) => controller.setGender(value!),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildRadioButton(
                    title: 'Perempuan',
                    value: 'Perempuan',
                    groupValue: controller.jenisKelamin.value,
                    onChanged: (value) => controller.setGender(value!),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Alamat
          _buildLabel('Alamat', required: true),
          _buildTextField(
            initialValue: controller.alamat.value,
            onChanged: (value) => controller.alamat.value = value,
            maxLines: 4,
          ),
          SizedBox(height: 32),

          // Email dan Username Section
          Text(
            'Email dan Username',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),

          // Username
          _buildLabel('Username', required: true),
          _buildTextField(
            initialValue: controller.username.value,
            onChanged: (value) => controller.username.value = value,
          ),
          SizedBox(height: 16),

          // Email
          _buildLabel('Email', required: true),
          _buildTextField(
            initialValue: controller.email.value,
            onChanged: (value) => controller.email.value = value,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 8),

          // Info message
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF4A7C59).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFF4A7C59), size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Semua informasi transaksi dan keamanan akunmu akan dikirim ke email ini',
                    style: TextStyle(fontSize: 12, color: Color(0xFF4A7C59)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => controller.updateProfile(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4A7C59),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Ubah Profil',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(fontSize: 14, color: Colors.black87),
          children: required
              ? [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ]
              : [],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String initialValue,
    Function(String)? onChanged,
    bool readOnly = false,
    Color? fillColor,
    TextInputType? keyboardType,
    int maxLines = 1,
    TextAlign textAlign = TextAlign.start,
  }) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      readOnly: readOnly,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textAlign: textAlign,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFF4A7C59), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: maxLines > 1 ? 16 : 12,
        ),
      ),
      style: TextStyle(fontSize: 15, color: Colors.black87),
    );
  }

  Widget _buildRadioButton({
    required String title,
    required String value,
    required String groupValue,
    required Function(String?) onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: groupValue == value ? Color(0xFF4A7C59) : Colors.grey[300]!,
            width: groupValue == value ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: Color(0xFF4A7C59),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            SizedBox(width: 4),
            Text(title, style: TextStyle(fontSize: 14, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
