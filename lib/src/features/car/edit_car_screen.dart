import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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

class EditCarScreen extends StatefulWidget {
  final CarModel carModel;
  const EditCarScreen({super.key, required this.carModel});

  @override
  State<EditCarScreen> createState() => _EditCarScreenState();
}

class _EditCarScreenState extends State<EditCarScreen> {
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
    initCarDetails();
  }

  getBrands() async {
    final brandProvider = Provider.of<BrandsProvider>(context, listen: false);
    await brandProvider.getAllBrands(context: context);
    selectedBrandName =
        brandProvider.brandsList
            .firstWhere(
              (e) => e.id == widget.carModel.brandId,
              orElse: () => brandProvider.brandsList.first,
            )
            .name;
    setState(() {});
  }

  initCarDetails() {
    _numberPlateController.text = widget.carModel.id;
    _modelController.text = widget.carModel.model;
    _colorController.text = widget.carModel.color;
    _speedController.text = widget.carModel.speed.toString();
    _descriptionController.text = widget.carModel.description;
    _pricePerDayController.text = widget.carModel.pricePerDay.toString();
    selectedCondition = widget.carModel.condition.toString();
    selectedSeats = widget.carModel.seats.toString();
    selectedFuelType = widget.carModel.fuelType;
    selectedTransmission = widget.carModel.transmission;
    selectedAirConditioning = widget.carModel.airConditioning ? 'Yes' : 'No';
    selectedBrandId = widget.carModel.brandId;
    imagesUrls = widget.carModel.imageUrls;
  }

  List<File> imagesList = [];
  List<String> imagesUrls = [];

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
        title: const Text('Edit Car'),
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
              imagesUrls.isNotEmpty
                  ? Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ...imagesUrls.map(
                        (e) => Container(
                          padding: EdgeInsets.all(8),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: e,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) =>
                                    Center(child: CircularProgressIndicator()),
                            errorWidget:
                                (context, url, error) => Icon(Icons.error),
                          ),
                        ),
                      ),
                    ],
                  )
                  : Container(
                    padding: EdgeInsets.all(8),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Center(child: Text("No Images")),
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
                      imagesUrls.isNotEmpty) {
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
                      imageUrls: widget.carModel.imageUrls,
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
                    carProvider.updateCar(context: context, car: carModel);
                  } else {
                    CustomSnackbar.error(
                      context: context,
                      message: "All * fields are required",
                    );
                  }
                },
                text: "Update Car",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
