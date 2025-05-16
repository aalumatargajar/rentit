import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentit/src/common/const/app_color.dart';
import 'package:rentit/src/common/const/app_images.dart';
import 'package:rentit/src/common/const/global_variable.dart';
import 'package:rentit/src/common/const/static_data.dart';
import 'package:rentit/src/common/widgets/custom_dialog.dart';
import 'package:rentit/src/common/widgets/rate_our_app.dart';
import 'package:rentit/src/common/widgets/share_our_app.dart';
import 'package:rentit/src/features/auth/auth_provider.dart';
import 'package:rentit/src/features/profile/edit_profile_screen.dart';
import 'package:rentit/src/features/profile/profile_widget.dart';
import 'package:rentit/src/features/profile/terms_policy_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white,
              child: Image.asset(AppImages.appLoggo, fit: BoxFit.contain),
            ),
            const SizedBox(height: 8),
            Text(
              StaticData.adminAuthenticationModel!.name,
              style: txtTheme(context).titleMedium,
            ),
            Text(
              StaticData.adminAuthenticationModel!.email,
              style: txtTheme(
                context,
              ).labelLarge?.copyWith(color: AppColor.successClr),
            ),
            const SizedBox(height: 16),
            ProfileWidget.profileOptionRow(
              context: context,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
              },
              title: "Edit Profile",
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: Colors.black,
              ),
            ),
            // Divider(),
            // ProfileWidget.profileOptionRow(
            //   context: context,
            //   title: "City",
            //   trailing: ,
            // ),
            Divider(),
            ProfileWidget.profileOptionRow(
              context: context,
              title: "Terms & Policy",
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TermsPolicyScreen()),
                );
              },
            ),
            Divider(),
            ProfileWidget.profileOptionRow(
              context: context,
              title: "Share our app",
              trailing: Icon(Icons.share, size: 22, color: Colors.black),
              onTap: () {
                // // Add functionality to share the app

                shareAppLink();
              },
            ),
            Divider(),
            ProfileWidget.profileOptionRow(
              context: context,
              title: "Rate our app",
              trailing: Icon(Icons.star_rate, size: 22, color: Colors.black),
              onTap: () {
                AppRating.rateApp(context);
              },
            ),
            Divider(),
            Consumer<AuthenticationProvider>(
              builder:
                  (context, authProvider, child) =>
                      ProfileWidget.profileOptionRow(
                        context: context,
                        title: "Logout",
                        onTap: () {
                          CustomDialog.showConfirmationDialog(
                            context: context,
                            title: "Logout Confirmation",
                            content: "Do you really want to logout?",
                            onYes: () {
                              authProvider.logout(context: context);
                            },
                          );
                        },
                        trailing: Icon(
                          Icons.logout,
                          size: 22,
                          color: Colors.black,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
