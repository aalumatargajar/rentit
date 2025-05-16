import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentit/src/common/const/app_color.dart';
import 'package:rentit/src/common/const/app_images.dart';
import 'package:rentit/src/common/const/global_variable.dart';
import 'package:rentit/src/common/const/static_data.dart';
import 'package:rentit/src/common/widgets/custom_elevated_button.dart';
import 'package:rentit/src/common/widgets/custom_textformfield.dart';
import 'package:rentit/src/features/auth/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  //! -------------------- Controllers -------------------------
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();

  //! ------------------- Form Key ------------------------
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _nameController.text = StaticData.adminAuthenticationModel!.name;
    _phoneNoController.text = StaticData.adminAuthenticationModel!.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile"), centerTitle: true),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 100,
                backgroundColor: Colors.white,
                // backgroundImage: AssetImage(AppImages.onboarding),
                child: Image.asset(AppImages.appLoggo, fit: BoxFit.contain),
              ),
              const SizedBox(height: 8),
              Text(
                StaticData.adminAuthenticationModel!.email,
                style: txtTheme(
                  context,
                ).labelLarge?.copyWith(color: AppColor.successClr),
              ),
              const SizedBox(height: 30),
              CustomTextFormField(
                prefixIcon: Icon(Icons.person, size: 18),
                controller: _nameController,
                labelText: "Name*",
                validationType: ValidationType.none,
              ),
              SizedBox(height: 10),
              CustomTextFormField(
                prefixIcon: Icon(Icons.person, size: 18),
                controller: _phoneNoController,
                labelText: "Phone Number*",
                validationType: ValidationType.phoneNumber,
              ),
              const SizedBox(height: 40),
              CustomElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final provider = Provider.of<AuthenticationProvider>(
                      context,
                      listen: false,
                    );

                    provider.updateUserData(
                      context: context,
                      id: StaticData.id,
                      phoneNumber: _phoneNoController.text.trim(),
                      name: _nameController.text.trim(),
                    );
                  }
                },
                text: "Update",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
