import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projeto_agendamento/pallete.dart';

class SocialButton extends StatelessWidget {
  final String iconName;
  final String label;
  final double horizontalPadding;

  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.iconName,
    required this.label,
    this.horizontalPadding = 70,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: SvgPicture.asset(
        'assets/svgs/$iconName.svg',
        width: 25,
        colorFilter: const ColorFilter.mode(Palette.mainColor1, BlendMode.srcIn),
      ),
      label: Text(
        label, 
        style: const TextStyle(
          color: Palette.mainColor1,
          fontSize: 17,
        )
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          vertical: 30, 
          horizontal: horizontalPadding,
        ),
        shape: RoundedRectangleBorder( 
          side: const BorderSide(color: Palette.mainColor1, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
