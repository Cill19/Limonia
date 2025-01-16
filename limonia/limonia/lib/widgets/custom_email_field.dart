import 'package:flutter/material.dart';

class CustomEmailField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  const CustomEmailField({
    Key? key,
    this.hintText = 'Email',
    this.controller,
    this.keyboardType = TextInputType.emailAddress,
  }) : super(key: key);

  @override
  _CustomEmailFieldState createState() => _CustomEmailFieldState();
}

class _CustomEmailFieldState extends State<CustomEmailField> {
  // Jika controller tidak diberikan, buat controller baru
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    // Jika controller null, buat controller baru
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    // Pastikan controller dibersihkan saat widget dibuang
    if (widget.controller == null) {
      _controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller, // Gunakan controller
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Color(0xFFBFBFBF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Color(0xFFBFBFBF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Color(0xFFBFBFBF), width: 2.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }
}
