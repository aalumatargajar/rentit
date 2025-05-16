import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final void Function() onTap;
  final Color? color;
  const CustomBackButton({super.key, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(color: color ?? Colors.black, width: 1.7),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back_ios_outlined,
            color: color ?? Colors.black,
            size: 12,
            weight: 30,
          ),
        ),
      ),
    );
  }
}
