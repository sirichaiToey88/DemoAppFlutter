import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

Future<void> readQrCodeFromGallery(
  MobileScannerController controller,
  Function() onFail,
  Function() onCancel,
  Function(String) onSuccess,
) async {
  final ImagePicker picker = ImagePicker();
  final image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    if (!await controller.analyzeImage(image.path)) {
      onFail();
    } else {
      // อ่าน QR code สำเร็จ
      onSuccess(controller.facing as String); // ส่งค่า QR code กลับไปให้ใช้งานต่อ
    }
  } else {
    onCancel();
  }
}
