import 'package:flutter/material.dart';
import 'package:masked_text/masked_text.dart';

class AppText extends StatelessWidget {

  String label;
  String hint;
  bool password;
  TextEditingController? controller;
  FormFieldValidator<String>? validator;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  FocusNode? focusNode;
  FocusNode? nextFocus;
  String? mask;

  AppText(
      this.label,
      this.hint, {
        this.password = false,
        this.controller,
        this.validator,
        this.keyboardType,
        this.textInputAction,
        this.focusNode,
        this.nextFocus,
        this.mask,
      });

  @override
  Widget build(BuildContext context) {
    return MaskedTextField(
      controller: controller,
      obscureText: password,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      focusNode: focusNode,
      mask: mask,
      onFieldSubmitted: (String text) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
      style: const TextStyle(
        fontSize: 22,
        color: Colors.deepPurple,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16)
        ),
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 22,
          color: Colors.grey,
        ),
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}