import 'package:flutter/material.dart';
import 'package:rentit/src/common/const/app_color.dart';

class CustomSnackbar {
  //! --------------------- SUCCESS ---------------------
  static success({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColor.successClr,

        behavior: SnackBarBehavior.floating,
        content: Text(message, style: TextStyle(color: AppColor.lightestBlue)),
        duration: const Duration(milliseconds: 1200),
        showCloseIcon: true,
        closeIconColor: AppColor.lightestBlue,
      ),
    );
  }

  //! --------------------- WARNING ---------------------
  static warning({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColor.warningClr,

        behavior: SnackBarBehavior.floating,
        content: Text(message, style: TextStyle(color: AppColor.lightestBlue)),
        duration: const Duration(milliseconds: 1200),
        showCloseIcon: true,
        closeIconColor: AppColor.lightestBlue,
      ),
    );
  }

  //! --------------------- ERROR ---------------------
  static error({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColor.errorClr,

        behavior: SnackBarBehavior.floating,
        content: Text(message, style: TextStyle(color: AppColor.lightestBlue)),
        duration: const Duration(milliseconds: 1200),
        showCloseIcon: true,
        closeIconColor: AppColor.lightestBlue,
      ),
    );
  }
}
