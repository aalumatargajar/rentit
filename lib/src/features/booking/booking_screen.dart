import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rentit/src/common/const/global_variable.dart';
import 'package:rentit/src/common/model/booking_model.dart';
import 'package:rentit/src/common/model/car_model.dart';
import 'package:rentit/src/common/widgets/custom_widgets.dart';
import 'package:rentit/src/features/booking/booking_details_screen.dart';
import 'package:rentit/src/features/car/car_provider.dart';
import 'package:shimmer/shimmer.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Query query() {
    final today = DateTime.now();
    print(today.toIso8601String());
    return _firestore
        .collection('booking')
        .where('endDate', isGreaterThanOrEqualTo: today.toIso8601String());
  }

  Future<CarModel?> getCarById({required String carId}) async {
    final provider = Provider.of<CarProvider>(context, listen: false);
    return await provider.getCarById(id: carId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FirestorePagination(
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
            title: "No Booking Found",
          ),
          separatorBuilder: (p0, p1) => SizedBox(height: 8),
          itemBuilder: (context, docs, index) {
            final data = docs[index].data() as Map<String, dynamic>;

            final booking = BookingModel.fromJson(data);

            return FutureBuilder(
              future: getCarById(carId: booking.carId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error fetching bookings:  ${snapshot.error}",
                      style: txtTheme(context).bodyMedium,
                    ),
                  );
                }
                final car = snapshot.data;
                if (car == null) {
                  return Center(
                    child: Text(
                      "Car not found",
                      style: txtTheme(context).bodyMedium,
                    ),
                  );
                }
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
                          builder:
                              (context) =>
                                  BookingDetailsScreen(bookingModel: booking),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CachedNetworkImage(
                            imageUrl: car.imageUrls[0],

                            placeholder:
                                (context, url) => Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    color: Colors.white,
                                    height: 140,
                                    width: 140,
                                  ),
                                ),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error),
                            fit: BoxFit.fitWidth,
                            height: 140,
                            width: double.infinity,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 2,
                            children: [
                              Text(
                                car.model,
                                style: txtTheme(context).titleSmall,
                              ),

                              Row(
                                children: [
                                  Text(
                                    DateFormat(
                                      'dd MMM',
                                    ).format(booking.startDate),
                                    style: txtTheme(context).labelMedium,
                                  ),
                                  Icon(Icons.remove),
                                  Text(
                                    DateFormat(
                                      'dd MMM',
                                    ).format(booking.endDate),
                                    style: txtTheme(context).labelMedium,
                                  ),
                                ],
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "To: ",
                                      style: txtTheme(
                                        context,
                                      ).labelMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    TextSpan(
                                      text: booking.destination,
                                      style: txtTheme(context).labelLarge!,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
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
                                        text: booking.totalPrice.toString(),
                                        style: txtTheme(
                                          context,
                                        ).titleSmall!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
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
