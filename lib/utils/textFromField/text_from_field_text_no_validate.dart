import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFromFieldNormal extends StatefulWidget {
  final String lableText;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? errorMessage;

  const TextFromFieldNormal({
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
  _TextFromFieldNormalState createState() => _TextFromFieldNormalState();
}

class _TextFromFieldNormalState extends State<TextFromFieldNormal> {
  String? _errorMessage;

  String? _validateNull(String? value) {
    if (value == "") {
      return 'Is not empty';
    }
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
  void didUpdateWidget(TextFromFieldNormal oldWidget) {
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
        final isNull = _validateNull(value) != null;

        setState(() {
          _errorMessage = isNull ? widget.errorMessage : null;
        });
      },
    );
  }
}
