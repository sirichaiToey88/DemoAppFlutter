import 'package:flutter/material.dart';

class TextFromFieldEmail extends StatefulWidget {
  final String lableText;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? errorMessage;

  const TextFromFieldEmail({
    Key? key,
    required this.lableText,
    required this.controller,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.errorMessage,
  }) : super(key: key);

  @override
  _TextFromFieldEmailState createState() => _TextFromFieldEmailState();
}

class _TextFromFieldEmailState extends State<TextFromFieldEmail> {
  String? _errorMessage;

  String? _validateEmailFormat(String? value) {
    if (value != null) {
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        return 'Please enter a valid email address';
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_clearErrorMessage);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_clearErrorMessage);
    super.dispose();
  }

  void _clearErrorMessage() {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        labelText: widget.lableText,
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        errorText: _errorMessage,
        errorMaxLines: 2,
      ),
      style: const TextStyle(fontSize: 18.0),
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      onChanged: (value) {
        final hasSpecialCharacters = _validateEmailFormat(value) != null;
        setState(() {
          _errorMessage = hasSpecialCharacters ? 'Please enter a valid email address' : null;
        });
      },
    );
  }
}
