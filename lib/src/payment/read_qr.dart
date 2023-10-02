import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

Future<void> readQrCodeFromGallery() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    // อ่าน QR code จากภาพที่เลือก
    final MobileScannerController controller = MobileScannerController(
      torchEnabled: false,
      formats: [
        BarcodeFormat.qrCode
      ],
      facing: CameraFacing.back,
    );

    await controller.start(); // เริ่มการสแกน
    await controller.analyzeImage(image.path);

    if (controller.barcodes.isBroadcast) {
      await for (final barcodeCapture in controller.barcodes) {
        final barcode = barcodeCapture.barcodes;
        if (barcode.isNotEmpty) {
          // final qrCodeData = barcode[0].rawValue;
          // print("QR code data: $qrCodeData");

          await controller.stop(); // หยุดการสแกนหลังจากอ่าน QR code เสร็จสิ้น
          return; // ออกจากฟังก์ชันเมื่ออ่าน QR code เสร็จสิ้น
        } else {
          // ไม่พบหมายเลข QR code ในภาพ
          // print("No QR code found in the image");
        }
      }
    } else {
      // ไม่สามารถอ่าน barcode ได้ หยุดการสแกน
      await controller.stop();
      // print("Failed to read barcode");
    }
  } else {
    // ผู้ใช้ยกเลิกกระบวนการเลือกภาพ
    // print("User cancelled the operation");
  }
}
