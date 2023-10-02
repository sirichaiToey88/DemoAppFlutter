import 'package:flutter/material.dart';
import 'package:demo_app/utils/read_code_qr/transfer_qr.dart';

class PromptPayDetailsScreen extends StatelessWidget {
  final TransferQrPromptPay qrData;

  const PromptPayDetailsScreen({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PromptPay Details'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextField('Version', qrData.version),
            buildTextField('Type', qrData.type),
            buildTextField('Tag', qrData.tag.toString()),
            buildTextField('Transfer Type', qrData.transferType.toString()),
            buildTextField('Merchant', qrData.merchant),
            buildTextField('Type Destination Account', qrData.typeDestinationAccount),
            buildTextField('Destination Account', qrData.destinationAccount),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              'ตกลง',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              'ยกเลิก',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, String value) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
      ),
      controller: TextEditingController(text: value),
      readOnly: true,
    );
  }
}
