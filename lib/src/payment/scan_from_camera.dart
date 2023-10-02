import 'package:demo_app/src/payment/payment_method.dart';
import 'package:demo_app/src/payment/payment_screen/bill_payment_detail.dart';
import 'package:demo_app/src/payment/payment_screen/promptpay_payment_detail_screen.dart';
import 'package:demo_app/src/scan_qr/read_qr_from_gallery.dart';
import 'package:demo_app/utils/read_code_qr/transfer_qr.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  bool isLoading = true;
  Barcode? barcode;
  QRViewController? controller;
  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    controller!.resumeCamera();
  }

  bool isQRCodeRead = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            if (isLoading) const CircularProgressIndicator(),
            buildQrView(context),
            Positioned(
                left: MediaQuery.of(context).padding.left + 15,
                top: MediaQuery.of(context).padding.top + 14,
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 35,
                      ),
                      onPressed: () {
                        Future.delayed(
                          const Duration(milliseconds: 250),
                          () => Navigator.pop(context),
                        );
                      },
                    ),
                  ],
                )),
            Positioned(
              bottom: 10,
              child: Column(
                children: [
                  buildResult(),
                  const SizedBox(
                    height: 55,
                  ),
                  const BuildTakePhoto(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResult() => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white24,
        ),
        child: const Text(
          "Scan a QR code",
          maxLines: 3,
        ),
      );

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Theme.of(context).shadowColor,
          borderLength: 20,
          borderRadius: 10,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    List<String> barcodeDetails = [];
    controller.scannedDataStream.listen((barcode) {
      if (!isQRCodeRead) {
        setState(() {
          isLoading = true;
          this.barcode = barcode;
        });
        String? response = barcode.code;
        barcodeDetails.add(response!);
        _buildReadQR(response);
        isQRCodeRead = true;
      }
      // if (!isQRCodeRead) {
      //   setState(() {
      //     isLoading = true;
      //     this.barcode = barcode;
      //   });
      //   String? response = barcode.code;
      //   barcodeDetails.add(response!);
      //   // Map<String, EmvcoTlvBean> result = parseQRCodeValue(response, false);
      //   // String jsonString = json.encode(result);
      //   // print("JSON String: ${jsonString}");
      //   _buildReadQR(response);
      //   // if (barcodeDetails[0].characters.length <= 100) {
      //   //   Navigator.push(
      //   //     context,
      //   //     MaterialPageRoute(
      //   //         builder: (context) => QRScanPage(
      //   //               barcodeDetails: barcodeDetails,
      //   //               takePhoto: 0,
      //   //             )),
      //   //   );
      //   // } else {
      //   //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //   //     showDialog(
      //   //       context: context,
      //   //       builder: (BuildContext context) {
      //   //         return AlertDialog(
      //   //           title: const Text("QR Not Found"),
      //   //           content: const Text("QR invalid. Please try again."),
      //   //           actions: [
      //   //             TextButton(
      //   //               onPressed: () {
      //   //                 Navigator.of(context).pop();
      //   //                 Navigator.pushNamed(context, AppRoute.paymentMethod);
      //   //               },
      //   //               child: const Text("OK"),
      //   //             ),
      //   //           ],
      //   //         );
      //   //       },
      //   //     );
      //   //   });
      //   // }

      //   isQRCodeRead = true;
      //   Future.delayed(Duration(seconds: 2), () {
      //     // สั่งให้ Loading ปิดตัวเองหลังจากอ่าน QR Code เสร็จสิ้น
      //     setState(() {
      //       isLoading = false;
      //     });
      //   });
      // }
    });
  }

  _buildReadQR(String qrCodeValue) {
    TransferQrData qrData = readQrCodeData(qrCodeValue);
    const CircularProgressIndicator();
    Future.delayed(const Duration(seconds: 1), () {
      if (qrData.isValid) {
        if (qrData is TransferQrPromptPay) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PromptPayDetailsScreen(qrData: qrData),
            ),
          );
          // print("PromptPay QR Data:");
          // print("Version: ${qrData.version}");
          // print("Type: ${qrData.type}");
          // print("Tag: ${qrData.tag}");
          // print("Transfer Type: ${qrData.transferType}");
          // print("Merchant: ${qrData.merchant}");
          //print("Type Destination Account: ${qrData.typeDestinationAccount}");
          //print("Destination Account: ${qrData.destinationAccount}");
          // print("OTA: ${qrData.ota}");
          // print("Bank Code: ${qrData.bankCode}");
          if (qrData.qrAdditionalField != null) {
            // print("\nAdditional Field:");
            // print(qrData.qrAdditionalField.toString());
          }
        } else if (qrData is TransferQrBillPayment) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BillPaymentDetailsScreen(qrData: qrData),
            ),
          );
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
    });
  }
}

class BuildTakePhoto extends StatelessWidget {
  const BuildTakePhoto({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.camera_alt),
      label: const Text('From Gallery'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
      onPressed: () async {
        // Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QrCodeGalleryReaderPage(),
            fullscreenDialog: true,
          ),
        );
      },
    );
  }

  void openQrCodeGalleryReaderPage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrCodeGalleryReaderPage(),
      ),
    );
  }
}
