import 'package:flutter/material.dart';
import 'package:projeto_agendamento/pallete.dart';

class LoginField extends StatelessWidget {
  final String hintText;

  const LoginField({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(constraints: 
    
    const BoxConstraints(maxHeight: 350),
    
    child: TextFormField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(27),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Palette.mainColor1, 
            width: 3,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Palette.mainColor2,
            width: 3
          ),
          borderRadius: BorderRadius.circular(10),
        ),
          hintText: hintText,
      ),  
    ));
  }
}