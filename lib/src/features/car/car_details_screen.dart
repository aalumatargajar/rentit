import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentit/src/common/const/global_variable.dart';
import 'package:rentit/src/common/model/car_model.dart';
import 'package:rentit/src/common/widgets/custom_back_button.dart';
import 'package:rentit/src/common/widgets/custom_dialog.dart';
import 'package:rentit/src/features/car/car_provider.dart';
import 'package:rentit/src/features/car/car_widget.dart';
import 'package:rentit/src/features/car/edit_car_screen.dart';
import 'package:shimmer/shimmer.dart';

class CarDetailsScreen extends StatefulWidget {
  final CarModel carModel;
  const CarDetailsScreen({super.key, required this.carModel});

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(onTap: () => Navigator.of(context).pop()),
        title: Text("Overview"),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => EditCarScreen(carModel: widget.carModel),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 16),
            ),
          ),
          SizedBox(width: 4),

          InkWell(
            onTap: () {
              CustomDialog.deleteConfirmationDialog(
                context: context,
                content: "Do you really want to delete this car?",
                onDelete: () {
                  final provider = Provider.of<CarProvider>(
                    context,
                    listen: false,
                  );
                  provider.deleteCar(
                    carId: widget.carModel.id,
                    context: context,
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider.builder(
                    itemCount: widget.carModel.imageUrls.length,
                    itemBuilder: (
                      BuildContext context,
                      int index,
                      int realIndex,
                    ) {
                      final imageUrl = widget.carModel.imageUrls[index];
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: colorScheme(context).outlineVariant,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,

                            placeholder:
                                (context, url) => Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(color: Colors.grey[300]),
                                ),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 200.0,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                    ),
                  ),
                  // Image.network(widget.carModel.imageUrl),
                  const SizedBox(height: 20),
                  Text(
                    widget.carModel.model,
                    style: txtTheme(context).titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.carModel.fuelType,
                    style: txtTheme(
                      context,
                    ).labelLarge?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        color:
                            index < (widget.carModel.condition / 2).round()
                                ? Colors.amber
                                : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(height: 8),
                  Text('Description', style: txtTheme(context).titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    widget.carModel.description,
                    style: txtTheme(context).bodySmall!.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(height: 8),
                  Text('Facilities', style: txtTheme(context).titleSmall),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,

                    children: [
                      CarWidget.facilityContainer(
                        icon: Icons.people,
                        text: widget.carModel.seats.toString(),
                        context: context,
                      ),
                      CarWidget.facilityContainer(
                        icon: Icons.speed,
                        text: '${widget.carModel.speed} km/h',
                        context: context,
                      ),
                      CarWidget.facilityContainer(
                        icon: Icons.settings,
                        text: widget.carModel.transmission,
                        context: context,
                      ),
                      CarWidget.facilityContainer(
                        icon: Icons.ac_unit,
                        text:
                            widget.carModel.airConditioning == true
                                ? "Yes"
                                : "No",
                        context: context,
                      ),
                      CarWidget.facilityContainer(
                        icon: Icons.color_lens,
                        text: widget.carModel.color,
                        context: context,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          widget.carModel.isBooked
              ? Container(
                width: double.infinity,
                height: 55,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    "Already Booked",
                    style: txtTheme(context).bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
              : Container(
                width: double.infinity,
                height: 55,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Rs. ",
                          style: txtTheme(context).bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: widget.carModel.pricePerDay.toStringAsFixed(0),
                          style: txtTheme(context).titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: " / day",
                          style: txtTheme(context).bodyMedium!.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
