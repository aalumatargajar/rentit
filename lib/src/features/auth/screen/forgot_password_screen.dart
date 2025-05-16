import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentit/src/common/const/app_images.dart';
import 'package:rentit/src/common/const/global_variable.dart';
import 'package:rentit/src/common/widgets/custom_elevated_button.dart';
import 'package:rentit/src/common/widgets/custom_textformfield.dart';
import 'package:rentit/src/features/auth/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Forgot Password",
          style: txtTheme(context).titleSmall!.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Hero(tag: "login_logo", child: Image.asset(AppImages.appLogo)),
              const SizedBox(height: 60),
              Text(
                "*An email will be sent to you with a link to reset your password",
                style: txtTheme(context).bodySmall!.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                controller: emailController,
                validationType: ValidationType.email,
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
              ),

              const SizedBox(height: 40),
              Hero(
                tag: "login_button",
                child: CustomElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final authenticationProvider =
                          Provider.of<AuthenticationProvider>(
                            context,
                            listen: false,
                          );
                      authenticationProvider.forgotPassword(
                        email: emailController.text.trim(),
                        context: context,
                      );
                    }
                  },
                  text: "Send Reset Link",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
