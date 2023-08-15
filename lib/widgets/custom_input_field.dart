import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

class CustomInputField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final String? Function(String?) validator;
  final bool suffixIcon;
  final bool? isDense;
  final bool obscureText;
  final TextEditingController? controller;
  final bool keyboardType; // New parameter for keyboard type

  const CustomInputField({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.validator,
    this.suffixIcon = false,
    this.isDense,
    this.obscureText = false,
    this.controller,
    required this.keyboardType, // New parameter for keyboard type
  }) : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // width: size.width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.labelText,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: (widget.hintText != "")
                      ? FontWeight.bold
                      : FontWeight.w100),
            ),
          ),
          TextFormField(
            controller: widget.controller,
            obscureText: (widget.obscureText && _obscureText),
            keyboardType: widget.keyboardType
                ? TextInputType.number
                : TextInputType
                    .text, // Set the keyboardType based on the parameter
            decoration: InputDecoration(
              isDense: (widget.isDense != null) ? widget.isDense : false,
              hintText: widget.hintText,
              suffixIcon: widget.suffixIcon
                  ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.remove_red_eye
                            : Icons.visibility_off_outlined,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
              suffixIconConstraints: (widget.isDense != null)
                  ? const BoxConstraints(maxHeight: 33)
                  : null,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}

abstract class ThemeText {
  static const TextStyle text = TextStyle(
    color: Color(0xffe73b18),
    fontSize: 15,
  );

  static TextStyle icon = GoogleFonts.lato(
    textStyle: const TextStyle(
      color: Colors.white,
      fontSize: 25,
      fontWeight: FontWeight.w400,
    ),
  );
  static TextStyle txt_ = GoogleFonts.lato(
    textStyle: const TextStyle(letterSpacing: .5),
    fontSize: 18,
  );

  static const TextStyle progressFooter = TextStyle(
      fontFamily: 'Montserrat',
      color: Colors.black,
      fontSize: 20,
      height: 0.5,
      fontWeight: FontWeight.w600);
}
