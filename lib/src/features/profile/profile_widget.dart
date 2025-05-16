import 'package:flutter/material.dart';
import 'package:rentit/src/common/const/global_variable.dart';

class ProfileWidget {
  //! ############## Profile Option Row ##################
  static Widget profileOptionRow({
    required BuildContext context,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(title, style: txtTheme(context).bodyLarge), trailing],
        ),
      ),
    );
  }
}
