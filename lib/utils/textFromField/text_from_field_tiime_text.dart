import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimeTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? errorMessage;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const TimeTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.errorMessage,
    this.validator,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  _TimeTextFieldState createState() => _TimeTextFieldState();
}

class _TimeTextFieldState extends State<TimeTextField> {
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final formattedTime = "${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}";
      widget.controller.text = formattedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // เรียกใช้งาน TimePicker เมื่อคลิกที่ TextField
        _selectTime(context);
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^[0-2]?[0-9]:[0-5][0-9]$')),
          ],
          decoration: InputDecoration(
            labelText: widget.labelText,
            errorText: widget.errorMessage,
            suffixIcon: const Icon(Icons.access_time),
          ),
          validator: _validateTime,
          onChanged: _onTimeChanged,
        ),
      ),
    );
  }

  String? _validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a time (e.g., 00:00)';
    }

    final regex = RegExp(r'^[0-2][0-9]:[0-5][0-9]$');
    if (!regex.hasMatch(value)) {
      return 'Invalid time format (e.g., 00:00)';
    }
    return null;
  }

  void _onTimeChanged(String value) {
    //todo
  }
}
