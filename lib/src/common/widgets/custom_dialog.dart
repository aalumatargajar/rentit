import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rentit/src/common/const/global_variable.dart';
import 'package:rentit/src/common/widgets/custom_elevated_button.dart';

class CustomDialog {
  // Show Confimration Dialog
  static void showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required Function onYes,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              child: const Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 15),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: colorScheme(context).primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),

                child: const Text("Yes", style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  await onYes();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                  // SystemNavigator.pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  //! ############## DELETE CONFIRMATION ################
  static deleteConfirmationDialog({
    required BuildContext context,
    required String content,
    required Function() onDelete,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Confirmation"),
            content: Text(content),
            actions: [
              CustomElevatedButton(
                height: 40,
                width: 70,
                backgroundColor: Colors.grey,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: "No",
              ),
              CustomElevatedButton(
                height: 40,
                width: 70,
                backgroundColor: Colors.red,
                onPressed: onDelete,
                text: "Delete",
              ),
            ],
          ),
    );
  }

  //! ############## MY INFO DIALOG ################
  static myInfoDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  const Text("Version 1.3"),
                  Text(
                    'Project Developed By',
                    style: txtTheme(context).headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme(context).primary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Divider(thickness: 1.2),
                  const SizedBox(height: 8),

                  // Developer Info
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: colorScheme(context).primary,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Aziz Ur Rehman",
                            style: txtTheme(
                              context,
                            ).labelLarge?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.numbers,
                          color: colorScheme(context).primary,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "F21NDOCS1M01056",
                            style: txtTheme(
                              context,
                            ).labelLarge?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.email,
                          color: colorScheme(context).primary,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "10azizurrehman@gmail.com",
                            style: txtTheme(
                              context,
                            ).labelLarge?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Close Button
                ],
              ),
            ),
          ),
    );
  }
}
