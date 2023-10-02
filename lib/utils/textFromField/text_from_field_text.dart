import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFromFieldText extends StatefulWidget {
  final String lableText;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? errorMessage;

  const TextFromFieldText({
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
  _TextFromFieldTextState createState() => _TextFromFieldTextState();
}

class _TextFromFieldTextState extends State<TextFromFieldText> {
  String? _errorMessage;

  String? _validateSpecialCharacters(String? value) {
    if (value != null) {
      final regex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
      if (regex.hasMatch(value)) {
        return 'Special characters are not allowed';
      }
    }
    return null;
  }

  String? _validateAllowedCharacters(String? value) {
    if (value != null) {
      final regex = RegExp(r'^[a-zA-Z0-9\u0E00-\u0E7F]+$');
      if (!regex.hasMatch(value)) {
        return 'Only a-z, A-Z, 0-9, and ก-ฮ are allowed';
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
  void didUpdateWidget(TextFromFieldText oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update error message when errorMessage parameter changes
    if (widget.errorMessage != oldWidget.errorMessage) {
      setState(() {
        _errorMessage = widget.errorMessage;
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
        final hasSpecialCharacters = _validateAllowedCharacters(value) != null;

        setState(() {
          _errorMessage = hasSpecialCharacters ? 'Special characters are not allowed' : null;
          // if (hasSpecialCharacters == true) {
          //   widget.controller.value = const TextEditingValue(
          //     text: "",
          //   );
          // }
        });
      },
    );
  }
}
