import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rentit/src/common/model/car_model.dart';
import 'package:rentit/src/common/widgets/custom_back_button.dart';
import 'package:rentit/src/common/widgets/custom_elevated_button.dart';
import 'package:rentit/src/common/widgets/custom_snackbar.dart';
import 'package:rentit/src/common/widgets/custom_textformfield.dart';
import 'package:rentit/src/common/widgets/custom_widgets.dart';
import 'package:rentit/src/features/brands/brands_provider.dart';
import 'package:rentit/src/features/car/car_provider.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final TextEditingController _numberPlateController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _speedController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pricePerDayController = TextEditingController();

  List<double> conditionList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  String? selectedCondition;

  List<String> fuelTypeList = ['Petrol', 'Diesel', 'Electric', 'Hybrid'];
  String? selectedFuelType;

  List<String> transmissionList = ['A', 'M'];
  String? selectedTransmission;

  List<String> airConditioningList = ['Yes', 'No'];
  String? selectedAirConditioning;

  List<String> seatsList = ['2', '4', '5', '6', '7'];
  String? selectedSeats;

  String? selectedBrandId;
  String? selectedBrandName;

  @override
  void initState() {
    super.initState();
    getBrands();
  }

  getBrands() async {
    final brandProvider = Provider.of<BrandsProvider>(context, listen: false);
    await brandProvider.getAllBrands(context: context);
  }

  List<File> imagesList = [];

  Future<void> pickImages() async {
    try {
      final pickedFiles = await ImagePicker().pickMultiImage();
      setState(() {
        final pickedImages =
            pickedFiles.map((file) => File(file.path)).toList();
        imagesList.addAll(pickedImages);
      });
    } catch (e) {
      CustomSnackbar.error(
        context: context,
        message: "Failed to pick images: $e",
      );
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Car'),
        centerTitle: true,
        leading: CustomBackButton(onTap: () => Navigator.of(context).pop()),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Consumer<BrandsProvider>(
                builder: (context, brandProvider, child) {
                  final brandList = brandProvider.brandsList;

                  if (brandList.isEmpty) {
                    return Text('No Brands Available');
                  }

                  return CustomWidgets.customNameAndDropDownMenu2(
                    title: 'Brand:*',
                    selectedItem: selectedBrandName,
                    itemsList: brandList.map((e) => e.name).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBrandName = value.toString();
                        selectedBrandId =
                            brandList.firstWhere((e) => e.name == value).id;
                      });
                    },
                    context: context,
                  );
                },
              ),
              CustomTextFormField(
                controller: _numberPlateController,
                validationType: ValidationType.empty,
                labelText: 'Number Plate*',
              ),
              CustomTextFormField(
                controller: _modelController,
                validationType: ValidationType.empty,
                labelText: 'Model*',
              ),
              CustomTextFormField(
                controller: _colorController,
                validationType: ValidationType.empty,
                labelText: 'Color*',
              ),
              CustomTextFormField(
                controller: _speedController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validationType: ValidationType.empty,
                labelText: 'Speed (km/h)*',
              ),
              CustomTextFormField(
                controller: _descriptionController,
                labelText: 'Description',
              ),
              CustomTextFormField(
                controller: _pricePerDayController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validationType: ValidationType.empty,
                labelText: 'Price Per Day*',
              ),
              Row(
                spacing: 16,
                children: [
                  Expanded(
                    flex: 3,
                    child: CustomWidgets.customNameAndDropDownMenu2(
                      title: 'Condition:*',
                      selectedItem: selectedCondition,
                      itemsList:
                          conditionList.map((e) => e.toString()).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCondition = value.toString();
                        });
                      },
                      context: context,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: CustomWidgets.customNameAndDropDownMenu2(
                      title: 'Seats:*',
                      selectedItem: selectedSeats,
                      itemsList: seatsList.map((e) => e.toString()).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSeats = value.toString();
                        });
                      },
                      context: context,
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 16,
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomWidgets.customNameAndDropDownMenu2(
                      title: 'AC:*',
                      selectedItem: selectedAirConditioning,
                      itemsList: airConditioningList,
                      onChanged: (value) {
                        setState(() {
                          selectedAirConditioning = value.toString();
                        });
                      },
                      context: context,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: CustomWidgets.customNameAndDropDownMenu2(
                      title: 'Transmission:*',
                      selectedItem: selectedTransmission,
                      itemsList: transmissionList,
                      onChanged: (value) {
                        setState(() {
                          selectedTransmission = value.toString();
                        });
                      },
                      context: context,
                    ),
                  ),
                ],
              ),
              CustomWidgets.customNameAndDropDownMenu2(
                title: 'Fuel Type:*',
                selectedItem: selectedFuelType,
                itemsList: fuelTypeList.map((e) => e.toString()).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFuelType = value.toString();
                  });
                },
                context: context,
              ),

              Text("Car Images:*"),
              imagesList.isNotEmpty
                  ? Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ...imagesList.map(
                        (e) => Container(
                          padding: EdgeInsets.all(8),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Image.file(e),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      imagesList.remove(e);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          pickImages();
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Center(child: Icon(Icons.add, size: 25)),
                        ),
                      ),
                    ],
                  )
                  : InkWell(
                    onTap: () {
                      pickImages();
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Center(child: Text("Add Images +")),
                    ),
                  ),

              SizedBox(height: 16),
              CustomElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      selectedCondition != null &&
                      selectedFuelType != null &&
                      selectedTransmission != null &&
                      selectedAirConditioning != null &&
                      selectedSeats != null &&
                      selectedBrandId != null &&
                      imagesList.isNotEmpty) {
                    final CarModel carModel = CarModel(
                      id: _numberPlateController.text.trim(),
                      brandId: selectedBrandId!,
                      model: _modelController.text.trim(),
                      color: _colorController.text.trim(),
                      condition: double.parse(selectedCondition!),
                      seats: int.parse(selectedSeats!),
                      fuelType: selectedFuelType!,
                      transmission: selectedTransmission!,
                      airConditioning: selectedAirConditioning == 'Yes',
                      speed: double.parse(_speedController.text.trim()),
                      imageUrls: imagesList.map((e) => e.path).toList(),
                      description: _descriptionController.text.trim(),
                      pricePerDay: double.parse(
                        _pricePerDayController.text.trim(),
                      ),
                      isBooked: false,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );

                    final carProvider = Provider.of<CarProvider>(
                      context,
                      listen: false,
                    );
                    carProvider.addCar(
                      context: context,
                      car: carModel,
                      imagesList: imagesList,
                    );
                  } else {
                    CustomSnackbar.error(
                      context: context,
                      message: "All * fields are required",
                    );
                  }
                },
                text: "Add Car +",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
