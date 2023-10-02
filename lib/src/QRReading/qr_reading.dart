import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class QRReading extends StatefulWidget {
  const QRReading({super.key});

  @override
  State<QRReading> createState() => _QRReadingState();
}

class _QRReadingState extends State<QRReading> {
  File? image;

  Future<void> getImageFromAlbum() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });

      // Call the QR code reading function
      // _readQRCode(_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
