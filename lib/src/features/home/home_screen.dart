import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentit/src/common/const/global_variable.dart';
import 'package:rentit/src/common/model/car_model.dart';
import 'package:rentit/src/common/widgets/custom_dialog.dart';
import 'package:rentit/src/common/widgets/custom_search_bar.dart';
import 'package:rentit/src/common/widgets/custom_widgets.dart';
import 'package:rentit/src/features/brands/brands_provider.dart';
import 'package:rentit/src/features/brands/brands_screen.dart';
import 'package:rentit/src/features/car/add_car_screen.dart';
import 'package:rentit/src/features/car/all_cars_screen.dart';
import 'package:rentit/src/features/car/car_details_screen.dart';
import 'package:rentit/src/features/car/car_provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getBrands();
  }

  getBrands() async {
    final brandProvider = Provider.of<BrandsProvider>(context, listen: false);
    await brandProvider.getAllBrands(context: context);
  }

  Query query() {
    final query = _firestore.collection('cars');
    if (searchedValue.isEmpty) {
      if (selectedBrandId == '0') {
        return query.orderBy('updatedAt', descending: true);
      } else {
        return query.where('brandId', isEqualTo: selectedBrandId);
      }
    } else {
      return query
          .where('model', isGreaterThanOrEqualTo: searchedValue)
          .where('model', isLessThanOrEqualTo: '$searchedValue\uf8ff');
    }
  }

  String searchedValue = '';
  String selectedBrandId = '0';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomSearchBar(
                  controller: _searchController,
                  hintTxt: "Search you dream car",
                  focusNode: _searchFocusNode,
                  onChanged: (p0) {
                    searchedValue = p0;
                    setState(() {});
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddCarScreen(),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme(context).primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
          if (searchedValue.isEmpty) SizedBox(height: 4),
          if (searchedValue.isEmpty)
            CustomWidgets.seeAllRow(
              context: context,
              title: "Top Brands",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BrandsScreen()),
                );
              },
            ),
          if (searchedValue.isEmpty)
            Consumer<BrandsProvider>(
              builder: (context, brandsProvider, child) {
                final brandList = brandsProvider.brandsList;
                if (brandList.isEmpty) {
                  return Text(
                    "No brands available",
                    style: txtTheme(context).bodyMedium,
                  );
                }

                return SizedBox(
                  height: 40,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    separatorBuilder:
                        (context, index) => const SizedBox(width: 12),
                    scrollDirection: Axis.horizontal,
                    itemCount: brandList.length + 1,
                    itemBuilder: (context, index) {
                      final isSelected =
                          index == 0
                              ? selectedBrandId == '0'
                              : selectedBrandId == brandList[index - 1].id;

                      if (index == 0) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedBrandId = '0';
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? colorScheme(context).primary
                                      : colorScheme(context).outlineVariant,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Center(
                              child: Text(
                                "All",
                                style: txtTheme(context).bodySmall!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      final brand = brandList[index - 1];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedBrandId = brand.id;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? colorScheme(context).primary
                                    : colorScheme(context).outlineVariant,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Center(
                            child: Text(
                              brand.name,
                              style: txtTheme(context).bodySmall!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

          SizedBox(height: 10),
          if (searchedValue.isEmpty)
            CustomWidgets.seeAllRow(
              context: context,
              title: "Popular Results",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllCarsScreen(),
                  ),
                );
              },
            ),
          // SizedBox(height: ),
          Expanded(
            child: FirestorePagination(
              key:
                  searchedValue.isEmpty
                      ? ValueKey(selectedBrandId)
                      : ValueKey(searchedValue),
              physics: BouncingScrollPhysics(),
              query: query(),
              limit: 5,
              isLive: true,
              bottomLoader: CustomWidgets.shimmerLoader(
                context: context,
                height: 120,
              ),
              initialLoader: CustomWidgets.shimmerLoader(
                context: context,
                height: 120,
              ),
              onEmpty: CustomWidgets.emptyWidget(
                context: context,
                title: "No Car Found",
              ),
              separatorBuilder: (p0, p1) => SizedBox(height: 8),
              itemBuilder: (context, docs, index) {
                final data = docs[index].data() as Map<String, dynamic>;

                final car = CarModel.fromJson(data);

                return Container(
                  padding: const EdgeInsets.all(8),
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
                            spacing: 1,
                            children: [
                              Text(
                                car.model,
                                style: txtTheme(context).titleSmall,
                              ),
                              Text(
                                car.fuelType,
                                style: txtTheme(context).labelSmall!.copyWith(
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
                                        Icon(Icons.people, size: 14),
                                        SizedBox(width: 4),
                                        Text(
                                          car.seats.toString(),
                                          style: txtTheme(context).labelSmall!
                                              .copyWith(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8),

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
                                        Icon(Icons.settings, size: 14),
                                        SizedBox(width: 4),
                                        Text(
                                          car.transmission,
                                          style: txtTheme(context).labelSmall!
                                              .copyWith(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
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
                                        ).labelSmall!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      TextSpan(
                                        text: car.pricePerDay.toString(),
                                        style: txtTheme(
                                          context,
                                        ).labelLarge!.copyWith(
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
                                  child: InkWell(
                                    onTap: () {
                                      CustomDialog.showConfirmationDialog(
                                        context: context,
                                        title: "Unbook Confirmation",
                                        content:
                                            "Do you really want to unbook this car?",
                                        onYes: () {
                                          final provider =
                                              Provider.of<CarProvider>(
                                                context,
                                                listen: false,
                                              );
                                          provider.updateCarStatus(
                                            carId: car.id,
                                            isBooked: false,
                                            context: context,
                                          );
                                        },
                                      );
                                    },
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
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Consumer<CarProvider>(
          //   builder: (context, carProvider, child) {
          //     final carList = carProvider.carList;

          //     if (carList.isEmpty) {
          //       return Center(
          //         child: Text(
          //           "No cars available",
          //           style: txtTheme(context).bodyMedium,
          //         ),
          //       );
          //     }
          //     return ListView.separated(
          //       itemCount: carList.length,
          //       physics: const NeverScrollableScrollPhysics(),
          //       shrinkWrap: true,
          //       separatorBuilder:
          //           (context, index) => const SizedBox(height: 16),
          //       itemBuilder: (context, index) {
          //         final car = carList[index];
          //         return Container(
          //           padding: const EdgeInsets.all(12),
          //           decoration: BoxDecoration(
          //             color: colorScheme(context).outlineVariant,
          //             borderRadius: BorderRadius.circular(12),
          //           ),
          //           child: InkWell(
          //             onTap: () {
          //               Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                   builder:
          //                       (context) => CarDetailsScreen(carModel: car),
          //                 ),
          //               );
          //             },
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               children: [
          //                 Expanded(
          //                   child: Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     mainAxisAlignment: MainAxisAlignment.start,
          //                     spacing: 4,
          //                     children: [
          //                       Text(
          //                         car.model,
          //                         style: txtTheme(context).titleSmall,
          //                       ),
          //                       Text(
          //                         car.fuelType,
          //                         style: txtTheme(context).bodySmall!.copyWith(
          //                           color: Colors.grey,
          //                           fontWeight: FontWeight.w600,
          //                         ),
          //                       ),
          //                       Row(
          //                         children: [
          //                           Container(
          //                             padding: const EdgeInsets.symmetric(
          //                               horizontal: 8,
          //                               vertical: 4,
          //                             ),
          //                             decoration: BoxDecoration(
          //                               color: Colors.white,
          //                               borderRadius: BorderRadius.circular(8),
          //                             ),
          //                             child: Row(
          //                               mainAxisSize: MainAxisSize.min,
          //                               children: [
          //                                 Icon(Icons.people, size: 16),
          //                                 SizedBox(width: 4),
          //                                 Text(
          //                                   car.seats.toString(),
          //                                   style: txtTheme(context).bodySmall!
          //                                       .copyWith(color: Colors.black),
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                           SizedBox(width: 8),

          //                           Container(
          //                             padding: const EdgeInsets.symmetric(
          //                               horizontal: 8,
          //                               vertical: 4,
          //                             ),
          //                             decoration: BoxDecoration(
          //                               color: Colors.white,
          //                               borderRadius: BorderRadius.circular(8),
          //                             ),
          //                             child: Row(
          //                               mainAxisSize: MainAxisSize.min,
          //                               children: [
          //                                 Icon(Icons.settings, size: 16),
          //                                 SizedBox(width: 4),
          //                                 Text(
          //                                   car.transmission,
          //                                   style: txtTheme(context).bodySmall!
          //                                       .copyWith(color: Colors.black),
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                       SizedBox(height: 8),
          //                       Container(
          //                         padding: const EdgeInsets.symmetric(
          //                           horizontal: 16,
          //                           vertical: 8,
          //                         ),

          //                         decoration: BoxDecoration(
          //                           color: Colors.black,
          //                           borderRadius: BorderRadius.circular(50),
          //                         ),
          //                         child: RichText(
          //                           text: TextSpan(
          //                             children: [
          //                               TextSpan(
          //                                 text: "Rs. ",
          //                                 style: txtTheme(
          //                                   context,
          //                                 ).bodySmall!.copyWith(
          //                                   fontWeight: FontWeight.bold,
          //                                   color: Colors.white,
          //                                 ),
          //                               ),
          //                               TextSpan(
          //                                 text: car.pricePerDay.toString(),
          //                                 style: txtTheme(
          //                                   context,
          //                                 ).titleSmall!.copyWith(
          //                                   fontWeight: FontWeight.bold,
          //                                   color: Colors.white,
          //                                 ),
          //                               ),
          //                               TextSpan(
          //                                 text: " / day",
          //                                 style: txtTheme(
          //                                   context,
          //                                 ).bodySmall!.copyWith(
          //                                   color: Colors.white,
          //                                   fontSize: 10,
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 SizedBox(width: 4),
          //                 Expanded(
          //                   child: Stack(
          //                     children: [
          //                       CachedNetworkImage(
          //                         imageUrl: car.imageUrls[0],

          //                         placeholder:
          //                             (context, url) => Shimmer.fromColors(
          //                               baseColor: Colors.grey[300]!,
          //                               highlightColor: Colors.grey[100]!,
          //                               child: Container(
          //                                 color: Colors.white,
          //                                 height: 100,
          //                                 width: 100,
          //                               ),
          //                             ),
          //                         errorWidget:
          //                             (context, url, error) =>
          //                                 const Icon(Icons.error),
          //                         fit: BoxFit.cover,
          //                         // height: 100,
          //                         width: double.infinity,
          //                       ),
          //                       if (car.isBooked)
          //                         Positioned(
          //                           top: 0,
          //                           right: 0,
          //                           child: Container(
          //                             padding: const EdgeInsets.symmetric(
          //                               horizontal: 10,
          //                               vertical: 5,
          //                             ),
          //                             decoration: BoxDecoration(
          //                               color: colorScheme(context).error,
          //                               borderRadius: BorderRadius.circular(4),
          //                             ),
          //                             child: Text(
          //                               "Booked",
          //                               style: txtTheme(
          //                                 context,
          //                               ).bodySmall!.copyWith(
          //                                 color: Colors.white,
          //                                 fontWeight: FontWeight.w600,
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //                     ],
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         );
          //       },
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
