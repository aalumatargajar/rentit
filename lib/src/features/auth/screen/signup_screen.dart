import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentit/src/common/const/app_images.dart';
import 'package:rentit/src/common/const/global_variable.dart';
import 'package:rentit/src/common/widgets/custom_elevated_button.dart';
import 'package:rentit/src/common/widgets/custom_textformfield.dart';
import 'package:rentit/src/features/auth/auth_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isObscure = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
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
            spacing: 16,
            children: [
              Hero(tag: "login_logo", child: Image.asset(AppImages.appLogo)),
              const SizedBox(height: 60),
              CustomTextFormField(
                controller: nameController,
                labelText: 'Name',
                validationType: ValidationType.name,
                prefixIcon: const Icon(Icons.person),
              ),
              CustomTextFormField(
                controller: emailController,
                labelText: 'Email',
                validationType: ValidationType.email,
                prefixIcon: const Icon(Icons.email),
              ),
              CustomTextFormField(
                controller: phoneNumberController,
                labelText: 'Phone Number',
                validationType: ValidationType.phoneNumber,
                prefixIcon: const Icon(Icons.phone),
              ),
              CustomTextFormField(
                controller: passwordController,
                labelText: 'Password',
                validationType: ValidationType.password,
                obscureText: isObscure,

                suffixIcon: IconButton(
                  onPressed: () {
                    isObscure = !isObscure;
                    setState(() {});
                  },
                  icon: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                prefixIcon: const Icon(Icons.password),
              ),

              const SizedBox(height: 40),
              Hero(
                tag: "login_button",
                child: CustomElevatedButton(
                  text: "Sign Up",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final authenticationProvider =
                          Provider.of<AuthenticationProvider>(
                            context,
                            listen: false,
                          );
                      authenticationProvider.signUpWithEmailAndPassword(
                        context: context,
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        phoneNumber: phoneNumberController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                    }
                  },
                ),
              ),

              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  text: "Already have any account? ",
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Login',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
