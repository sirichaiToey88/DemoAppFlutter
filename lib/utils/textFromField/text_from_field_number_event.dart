import 'package:flutter/material.dart';

class TextFromFieldNumberEvent extends StatefulWidget {
  final String lableText;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final String? errorMessage;
  final int? maxLength;
  final ValueChanged<String>? onChanged;

  const TextFromFieldNumberEvent({
    Key? key,
    required this.lableText,
    required this.controller,
    this.prefixIcon,
    this.obscureText = false,
    this.validator,
    this.keyboardType = TextInputType.number,
    this.errorMessage,
    this.maxLength,
    this.onChanged,
  }) : super(key: key);

  @override
  State<TextFromFieldNumberEvent> createState() => _TextFromFieldNumberState();
}

class _TextFromFieldNumberState extends State<TextFromFieldNumberEvent> {
  String? _errorMessage;

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
    if (_errorMessage != null && widget.controller.text.isNotEmpty) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  String? _validateLength(String? value) {
    num maxLength = widget.maxLength ?? 0;
    if (value != null) {
      if (value.length < maxLength) {
        return "Please provide ${value.length} characters exactly.";
      }
    }
    return null;
  }

  @override
  void didUpdateWidget(TextFromFieldNumberEvent oldWidget) {
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
        counterText: null,
      ),
      style: const TextStyle(fontSize: 18.0),
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      // onChanged: (value) {
      //   final hasSpecialCharacters = _validateLength(value) != null;

      //   setState(() {
      //     _errorMessage = hasSpecialCharacters ? "Please provide ${widget.maxLength} characters exactly." : null;
      //   });
      // },
    );
  }
}
