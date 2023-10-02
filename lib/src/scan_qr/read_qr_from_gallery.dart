import 'package:demo_app/route/route.dart';
import 'package:demo_app/src/payment/payment_method.dart';
import 'package:demo_app/src/payment/payment_screen/promptpay_payment_detail_screen.dart';
import 'package:demo_app/utils/custom_toast/show_toast_top.dart';
import 'package:demo_app/utils/read_code_qr/transfer_qr.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeGalleryReaderPage extends StatefulWidget {
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

  Future<void> showQrCodeGalleryReaderPage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // อ่าน QR code จากภาพที่เลือก
      bool status = await controller.analyzeImage(image.path);
      if (status == false) {
        Navigator.pop(context);
        Navigator.pushNamed(context, AppRoute.paymentMethod);
        showCustomToastTop('QR not correct', backgroundColor: Colors.red, textColor: Colors.white);
      }
      // print("controller =>> ${status}");
      // print("Path ${image.path}");
    }

    // ปิดหน้า UI
    // Navigator.pop(context, false);
  }

  @override
  void initState() {
    super.initState();
    controller.start();
    // เรียกใช้ฟังก์ชันเปิดอัลบั้มทันทีเมื่อทำการเข้าสู่หน้า
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      showQrCodeGalleryReaderPage();
    });
  }

  @override
  void dispose() {
    controller.dispose(); // หยุดการสแกน
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      key: GlobalKey(),
      controller: controller,
      onDetect: (barcode) async {
        if (barcode.raw != null) {
          // อ่าน QR code สำเร็จ
          // print("QR code data000: ${barcode.raw}");
          var qrCodeValue = barcode.raw[0]['rawValue'];
          _buildReadQR(qrCodeValue);

          // setState(() {
          //   qrCodeData = barcode.raw[0]['rawValue']!;
          // });
        }
      },
    );
  }

  _buildReadQR(String qrCodeValue) {
    TransferQrData qrData = readQrCodeData(qrCodeValue);
    CircularProgressIndicator();
    if (qrData.isValid) {
      if (qrData is TransferQrPromptPay) {
        // Navigator.popUntil(context, (route) => route.isFirst);
        // Navigator.popUntil(context, ModalRoute.withName('/promptpay_payment_detail_screen'));

        if (qrData.typeDestinationAccount.isNotEmpty) {
          // Navigator.pop(context);
          // Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PromptPayDetailsScreen(qrData: qrData),
            ),
          );
        }

        // print("PromptPay QR Data:");
        // print("Version: ${qrData.version}");
        // print("Type: ${qrData.type}");
        // print("Tag: ${qrData.tag}");
        // print("Transfer Type: ${qrData.transferType}");
        // print("Merchant: ${qrData.merchant}");
        // print("Type Destination Accountffffff: ${qrData.typeDestinationAccount}");
        // print("Destination Account: ${qrData.destinationAccount}");
        // print("OTA: ${qrData.ota}");
        // print("Bank Code: ${qrData.bankCode}");
        if (qrData.qrAdditionalField != null) {
          // print("\nAdditional Field:");
          // print(qrData.qrAdditionalField.toString());
        }
      } else if (qrData is TransferQrBillPayment) {
        // print("Bill Payment QR Data:");
        // print("Version: ${qrData.version}");
        // print("Type: ${qrData.type}");
        // print("Tag: ${qrData.tag}");
        // print("Transfer Type: ${qrData.transferType}");
        // print("Merchant: ${qrData.merchant}");
        // print("AID: ${qrData.aid}");
        // print("Biller ID: ${qrData.billerId}");
        // print("Reference 1: ${qrData.reference1}");
        // print("Reference 2: ${qrData.reference2}");
        if (qrData.qrAdditionalField != null) {
          // print("\nAdditional Field:");
          // print(qrData.qrAdditionalField.toString());
        }
      } else if (qrData is TransferQrVerifySlip) {
        // print("Verify Slip QR Data:");
        // print("Version: ${qrData.version}");
        // print("Type: ${qrData.type}");
        // print("Tag: ${qrData.tag}");
        // print("Bank ID: ${qrData.bankId}");
        // print("API ID: ${qrData.apiId}");
        // print("Transaction Ref: ${qrData.transactionRef}");
      } else {
        // print("QR Data:");
        // print("Version: ${qrData.version}");
        // print("Type: ${qrData.type}");
        // print("Tag: ${qrData.tag}");
        // print("Transfer Type: ${qrData.transferType}");
        // print("Merchant: ${qrData.merchant}");
        // print("Country Code: ${qrData.countryCode}");
        // print("Currency Code: ${qrData.currencyCode}");
        // print("Amount: ${qrData.amount}");
        // print("County: ${qrData.county}");
        // print("Merchant Name: ${qrData.merchantName}");
        // print("Merchant City: ${qrData.merchantCity}");
        // print("CheckSum: ${qrData.checkSum}");
        if (qrData.qrAdditionalField != null) {
          // print("\nAdditional Field:");
          // print(qrData.qrAdditionalField.toString());
        }
      }
    } else {
      print("Invalid QR Data!");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Invalid QR Data"),
            content: const Text("The scanned QR data is invalid. Please try again."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentMethod(),
                    ),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
}
