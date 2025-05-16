import 'package:flutter/material.dart';
import 'package:rentit/src/common/const/global_variable.dart';

class CarWidget {
  static Container facilityContainer({
    required IconData icon,
    required String text,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme(context).outlineVariant,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 16),
          SizedBox(width: 8),
          Text(
            text,
            style: txtTheme(context).labelMedium!.copyWith(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
