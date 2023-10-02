// สร้าง class ใหม่เพื่อจัดการ Permission
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerService {
  static Future<bool> checkAndRequestPermissions() async {
    // Check if the permissions are already granted
    if (await _arePermissionsGranted()) {
      return true; // ได้รับสิทธิ์แล้ว
    }

    // If no permission request is currently in progress, start the request
    if (!isRequestingPermission) {
      isRequestingPermission = true;
      // Request the permissions
      await _requestPermissions();
      isRequestingPermission = false;
    }

    // ตรวจสอบอีกครั้งหลังจากที่ได้ทำการขอสิทธิ์แล้ว
    return await _arePermissionsGranted();
  }

  static bool isRequestingPermission = false;

  static Future<bool> _arePermissionsGranted() async {
    return await Permission.camera.isGranted && await Permission.storage.isGranted && await Permission.location.isGranted && await Permission.locationAlways.isGranted && await Permission.locationWhenInUse.isGranted;
  }

  static Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
      Permission.location,
      Permission.locationAlways,
      Permission.locationWhenInUse,
    ].request();

    // ตรวจสอบสถานะการขอสิทธิ์และทำการจัดการตามที่ต้องการ
    if (statuses[Permission.camera]!.isDenied || statuses[Permission.storage]!.isDenied || statuses[Permission.location]!.isDenied || statuses[Permission.locationAlways]!.isDenied || statuses[Permission.locationWhenInUse]!.isDenied) {
      // ทำการแสดงข้อความหรือกระทำตามที่คุณต้องการเมื่อขอสิทธิ์ถูกปฏิเสธ
    } else {
      // ทำการแสดงข้อความหรือกระทำตามที่คุณต้องการเมื่อขอสิทธิ์ได้รับการอนุญาต
    }
  }
}
