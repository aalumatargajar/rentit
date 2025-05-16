import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentit/src/common/const/global_variable.dart';
import 'package:rentit/src/common/widgets/custom_back_button.dart';
import 'package:rentit/src/features/car/add_car_screen.dart';
import 'package:rentit/src/features/car/car_details_screen.dart';
import 'package:rentit/src/features/car/car_provider.dart';
import 'package:shimmer/shimmer.dart';

class AllCarsScreen extends StatefulWidget {
  const AllCarsScreen({super.key});

  @override
  State<AllCarsScreen> createState() => _AllCarsScreenState();
}

class _AllCarsScreenState extends State<AllCarsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Cars'),
        centerTitle: true,
        leading: CustomBackButton(onTap: () => Navigator.of(context).pop()),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddCarScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<CarProvider>(
          builder: (context, carProvider, child) {
            final carList = carProvider.carList;

            if (carList.isEmpty) {
              return Center(
                child: Text(
                  "No cars available",
                  style: txtTheme(context).bodyMedium,
                ),
              );
            }
            return ListView.separated(
              itemCount: carList.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final car = carList[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme(context).outlineVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarDetailsScreen(carModel: car),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text(
                                car.model,
                                style: txtTheme(context).titleSmall,
                              ),
                              Text(
                                car.fuelType,
                                style: txtTheme(context).bodySmall!.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.people, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          car.seats.toString(),
                                          style: txtTheme(context).bodySmall!
                                              .copyWith(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  // Container(
                                  //   padding: const EdgeInsets.symmetric(
                                  //     horizontal: 8,
                                  //     vertical: 4,
                                  //   ),
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.white,
                                  //     borderRadius: BorderRadius.circular(8),
                                  //   ),
                                  //   child: Row(
                                  //     mainAxisSize: MainAxisSize.min,
                                  //     children: [
                                  //       Icon(Icons.speed, size: 16),
                                  //       SizedBox(width: 4),
                                  //       Text(
                                  //         car.speed.toString(),
                                  //         style: txtTheme(context).bodySmall!
                                  //             .copyWith(color: Colors.black),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  // SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.settings, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          car.transmission,
                                          style: txtTheme(context).bodySmall!
                                              .copyWith(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),

                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Rs. ",
                                        style: txtTheme(
                                          context,
                                        ).bodySmall!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      TextSpan(
                                        text: car.pricePerDay.toString(),
                                        style: txtTheme(
                                          context,
                                        ).titleSmall!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " / day",
                                        style: txtTheme(
                                          context,
                                        ).bodySmall!.copyWith(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: car.imageUrls[0],

                                placeholder:
                                    (context, url) => Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        color: Colors.white,
                                        height: 100,
                                        width: 100,
                                      ),
                                    ),
                                errorWidget:
                                    (context, url, error) =>
                                        const Icon(Icons.error),
                                fit: BoxFit.cover,
                                // height: 100,
                                width: double.infinity,
                              ),
                              if (car.isBooked)
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorScheme(context).error,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      "Booked",
                                      style: txtTheme(
                                        context,
                                      ).bodySmall!.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
