import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/utils/context_extension.dart';

import '../Screens/home_screen.dart';

class CustomFormField extends StatefulWidget {
  const CustomFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.iconsType,
    required this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData iconsType;
  final TextInputType keyboardType;

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscureText() {
    if (widget.obscureText == true) {
      setState(() {
        _obscureText = !_obscureText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        obscureText: _obscureText,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: Icon(
            widget.iconsType as IconData?,
            color: Colors.black,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: _toggleObscureText,
              child: Image.asset(
                'assets/images/pokeball_image.png',
                width: 20,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple, width: 2),
          ),
          hintStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.amber, width: 3),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 3),
          ),
        ),
      ),
    );
  }
}
