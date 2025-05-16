import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentit/src/common/model/brands_model.dart';
import 'package:rentit/src/common/widgets/custom_elevated_button.dart';
import 'package:rentit/src/common/widgets/custom_textformfield.dart';
import 'package:rentit/src/features/brands/brands_provider.dart';

class EditBrandScreen extends StatefulWidget {
  final BrandsModel? brandModel;
  const EditBrandScreen({super.key, required this.brandModel});

  @override
  State<EditBrandScreen> createState() => _EditBrandScreenState();
}

class _EditBrandScreenState extends State<EditBrandScreen> {
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _brandLogoController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _brandNameController.text = widget.brandModel?.name ?? '';
    _brandLogoController.text = widget.brandModel?.logoUrl ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Brand'),
        actions: [
          IconButton(
            onPressed: () {
              final brandProvider = Provider.of<BrandsProvider>(
                context,
                listen: false,
              );
              brandProvider.deleteBrand(
                brandId: widget.brandModel!.id,
                context: context,
              );
            },
            icon: const Icon(Icons.delete),
          ),
        ],
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
              CustomTextFormField(
                validationType: ValidationType.none,
                controller: _brandLogoController,
                labelText: "Brand Logo URL",
              ),
              const SizedBox(height: 40),
              CustomElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final brandModel = BrandsModel(
                      id: widget.brandModel!.id,
                      name: _brandNameController.text.trim(),
                      logoUrl: _brandLogoController.text.trim(),
                      createdAt: widget.brandModel!.createdAt,
                      updatedAt: DateTime.now(),
                    );

                    final brandProvider = Provider.of<BrandsProvider>(
                      context,
                      listen: false,
                    );
                    brandProvider.editBrand(
                      brand: brandModel,
                      context: context,
                    );
                  }
                },
                text: 'Update Brand',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
