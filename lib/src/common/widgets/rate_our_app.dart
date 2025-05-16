import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rentit/src/common/const/global_variable.dart';
import 'package:rentit/src/common/widgets/custom_snackbar.dart';

class AppRating {
  static rateApp(BuildContext context) {
    RateMyApp rateMyApp = RateMyApp(
      preferencesPrefix: "rateMyApp_",
      minDays: 0,
      minLaunches: 1,
      remindDays: 0,
      remindLaunches: 1,
      googlePlayIdentifier: 'com.example.rentit',
    );

    rateMyApp.init().then((_) {
      if (rateMyApp.shouldOpenDialog) {
        double rating = 0;

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Rate our App', style: txtTheme(context).titleSmall),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder:
                        (context, _) => Icon(
                          Icons.star,
                          color: colorScheme(context).secondary,
                        ),
                    onRatingUpdate: (newRating) {
                      rating = newRating;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
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
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                          child: const Text(
                            "Rate Now",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (rating >= 4) {
                              await rateMyApp.launchStore();
                            } else {
                              CustomSnackbar.success(
                                context: context,
                                message: 'Thank You for rating!',
                              );
                            }
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }
    });
  }
}
