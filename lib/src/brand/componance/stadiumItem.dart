import 'dart:io';

import 'package:demo_app/src/brand/componance/ImagePickerBottomSheet.dart';
import 'package:demo_app/utils/textFromField/text_from_field_number_event.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StadiumItem extends StatelessWidget {
  final StadiumInfo stadiumInfo;
  final VoidCallback onDelete;
  final List<String> typeStadiumOptions;
  final String? selectedTypeStadium;
  final ValueChanged<String?> onTypeStadiumChanged;
  final String? courtPriceError;
  final String? courtNumberError;
  final VoidCallback onDeleteImage;
  final PickedFile? pickedImage;
  String? stadiumNumber;
  String? stadiumPrice;
  final TextEditingController stadiumNumberController = TextEditingController();
  final TextEditingController stadiumPriceController = TextEditingController();
  StadiumItem({
    super.key,
    required this.stadiumInfo,
    required this.onDelete,
    required this.typeStadiumOptions,
    required this.selectedTypeStadium,
    required this.onTypeStadiumChanged,
    this.courtPriceError,
    this.courtNumberError,
    required this.onDeleteImage,
    this.pickedImage,
  }) {
    stadiumNumberController.text = stadiumInfo.stadiumNumber ?? '';
    stadiumPriceController.text = stadiumInfo.stadiumPrice ?? '';
  }

  void _onImagePickerPressed(BuildContext context) {
    ImagePickerBottomSheet.show(context, (PickedFile? pickedFile) {
      if (pickedFile != null) {
        onDeleteImage();
        stadiumInfo.image = PickedFile(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: stadiumInfo.typeStadium ?? 'pleaseSelect'.tr(),
          items: [
            DropdownMenuItem<String>(
              value: 'pleaseSelect'.tr(),
              child: Text('pleaseSelect'.tr()),
            ),
            ...typeStadiumOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ],
          onChanged: (newValue) {
            onTypeStadiumChanged(newValue);
            stadiumInfo.typeStadium = newValue; // อัพเดท typeStadium ใน stadiumInfo
          },
          decoration: InputDecoration(labelText: 'typeStadium'.tr()),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () async {
            final imagePicker = ImagePicker();
            final pickedFile = await imagePicker.pickImage(
              source: ImageSource.gallery, // เปิดอัลบั้ม (ใช้ ImageSource.camera เพื่อเปิดกล้อง)
            );
            if (pickedFile != null) {
              onDeleteImage();
              stadiumInfo.image = PickedFile(pickedFile.path);
            }
          },
          child: Row(
            children: [
              const Icon(Icons.camera), // แสดงไอคอนกล้องหรืออัลบั้ม
              const SizedBox(width: 8), // ขยายช่องว่างเพื่อเว้นระยะห่างจากไอคอน
              Text('image'.tr()), // แสดงข้อความ 'image' สำหรับป้ายกำกับ
            ],
          ),
        ),
        if (stadiumInfo.image != null)
          Column(
            children: [
              Image.file(File(stadiumInfo.image!.path), height: 200),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  stadiumInfo.image = null;
                  onDeleteImage();
                },
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete_sweep,
                      color: Colors.red,
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ],
          ),
        TextFromFieldNumberEvent(
          controller: stadiumNumberController,
          lableText: 'stadiumNumber'.tr(),
          keyboardType: TextInputType.number,
          maxLength: 2,
          onChanged: (value) {
            stadiumInfo.stadiumNumber = value;
          },
          validator: (value) {
            return null;
          },
          errorMessage: courtNumberError,
        ),
        TextFromFieldNumberEvent(
          controller: stadiumPriceController,
          lableText: 'stadiumPrice'.tr(),
          keyboardType: TextInputType.number,
          maxLength: 3,
          onChanged: (value) {
            stadiumInfo.stadiumPrice = value;
          },
          validator: (value) {
            return null;
          },
          errorMessage: courtPriceError,
        ),
        IconButton(
          icon: const Icon(Icons.delete_sweep_outlined),
          color: Colors.red,
          onPressed: onDelete,
        ),
      ],
    );
  }
}

class StadiumInfo {
  String? typeStadium;
  String? stadiumNumber;
  String? stadiumPrice;
  PickedFile? image;

// เพิ่มเมธอด onSave
  bool onSave() {
    bool isValid = true;

    // ตรวจสอบและกำหนดข้อความผิดพลาดของ stadiumNumber
    if (stadiumNumber == null || stadiumNumber!.isEmpty) {
      isValid = false;
    }

    // ตรวจสอบและกำหนดข้อความผิดพลาดของ stadiumPrice
    if (stadiumPrice == null || stadiumPrice!.isEmpty) {
      isValid = false;
    }

    return isValid;
  }
}
