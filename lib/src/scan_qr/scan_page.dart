import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeGalleryReaderPage extends StatefulWidget {
  const QrCodeGalleryReaderPage({super.key});

  @override
  _QrCodeGalleryReaderPageState createState() => _QrCodeGalleryReaderPageState();
}

class _QrCodeGalleryReaderPageState extends State<QrCodeGalleryReaderPage> {
  String qrCodeData = '';
  MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
    formats: [
      BarcodeFormat.qrCode
    ],
    facing: CameraFacing.back,
  );

  Future<void> readQrCodeFromGallery() async {
    final ImagePicker picker = ImagePicker();
    // final image = await picker.pickImage(source: ImageSource.gallery);
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // อ่าน QR code จากภาพที่เลือก
      await controller.analyzeImage(image.path);
      // print("QR code image.path: ${image.path}");
      // print("QR code analyzeImage: ${controller.analyzeImage(image.path).toString()}");
    } else {
      // ผู้ใช้ยกเลิกกระบวนการเลือกภาพ
      // print("User cancelled the operation");
    }
  }

  @override
  // void initState() {
  //   super.initState();
  //   controller.start(); // เริ่มการสแกน
  // }

  @override
  void dispose() {
    controller.dispose(); // หยุดการสแกน
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code Gallery Reader"),
      ),
      body: Column(
        children: [
          // แสดง QR code ที่อ่านได้
          Text(
            "QR Code data: $qrCodeData",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          // ปุ่มเพื่อเลือกภาพจากแกลเลอรี
          ElevatedButton(
            onPressed: readQrCodeFromGallery,
            child: const Text("Select Image from Gallery"),
          ),
          const SizedBox(height: 16),
          // กล้องถ่ายรูปที่ใช้สำหรับการสแกน QR code
          MobileScanner(
            key: GlobalKey(),
            controller: controller,
            onDetect: (barcode) async {
              if (barcode.raw != null) {
                // อ่าน QR code สำเร็จ
                // print("QR code data: ${barcode.raw[0]['rawValue']}");
                setState(() {
                  qrCodeData = barcode.raw[0]['rawValue']!;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
