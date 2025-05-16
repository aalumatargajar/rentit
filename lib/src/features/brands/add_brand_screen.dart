import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rentit/src/common/const/global_variable.dart';
import 'package:rentit/src/common/model/brands_model.dart';
import 'package:rentit/src/common/widgets/custom_back_button.dart';
import 'package:rentit/src/common/widgets/custom_elevated_button.dart';
import 'package:rentit/src/common/widgets/custom_textformfield.dart';
import 'package:rentit/src/features/brands/brands_provider.dart';

class AddBrandScreen extends StatefulWidget {
  const AddBrandScreen({super.key});

  @override
  State<AddBrandScreen> createState() => _AddBrandScreenState();
}

class _AddBrandScreenState extends State<AddBrandScreen> {
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _brandLogoController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? pickedImage;
  pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Brand'),
        centerTitle: true,
        leading: CustomBackButton(
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomTextFormField(
                validationType: ValidationType.name,
                controller: _brandNameController,
                labelText: "Brand Name",
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 250,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorScheme(context).outline,
                ),
                child: InkWell(
                  onTap: () {
                    pickImage();
                  },
                  child:
                      pickedImage != null
                          ? Image.file(pickedImage!)
                          : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.upload,
                                color: colorScheme(context).primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Upload Logo",
                                style: txtTheme(context).bodyMedium,
                              ),
                            ],
                          ),
                ),
              ),
              const SizedBox(height: 40),
              CustomElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final brandProvider = Provider.of<BrandsProvider>(
                      context,
                      listen: false,
                    );
                    brandProvider.addBrand(
                      name: _brandNameController.text.trim(),
                      image: pickedImage!,
                      context: context,
                    );
                  }
                },
                text: 'Add Brand',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
