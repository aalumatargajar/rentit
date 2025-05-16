import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentit/src/common/const/app_images.dart';
import 'package:rentit/src/common/const/global_variable.dart';
import 'package:rentit/src/common/widgets/custom_elevated_button.dart';
import 'package:rentit/src/common/widgets/custom_textformfield.dart';
import 'package:rentit/src/features/auth/auth_provider.dart';
import 'package:rentit/src/features/auth/screen/forgot_password_screen.dart';
import 'package:rentit/src/features/auth/screen/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Login",
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
              CustomTextFormField(
                controller: emailController,
                validationType: ValidationType.email,
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
              ),

              const SizedBox(height: 16),
              CustomTextFormField(
                controller: passwordController,
                validationType: ValidationType.password,
                labelText: 'Password',
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
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
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
                      authenticationProvider.loginWithEmailAndPassword(
                        context: context,
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                      // Perform login action
                    }
                  },
                  text: "Login",
                ),
              ),
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  text: "Don't have any account? ",
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: 'Sign Up',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignUpScreen(),
                                ),
                              );
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
