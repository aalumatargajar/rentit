import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rentit/src/common/const/global_variable.dart';
import 'package:rentit/src/common/model/booking_model.dart';
import 'package:rentit/src/common/model/car_model.dart';
import 'package:rentit/src/common/widgets/custom_back_button.dart';
import 'package:rentit/src/features/booking/booking_provider.dart';
import 'package:rentit/src/features/car/car_provider.dart';
import 'package:rentit/src/features/car/car_widget.dart';
import 'package:shimmer/shimmer.dart';

class BookingDetailsScreen extends StatefulWidget {
  final BookingModel bookingModel;
  const BookingDetailsScreen({super.key, required this.bookingModel});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  int totalDays = 0;
  @override
  void initState() {
    super.initState();
    final startDate = widget.bookingModel.startDate;
    final endDate = widget.bookingModel.endDate;
    totalDays = endDate.difference(startDate).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(onTap: () => Navigator.of(context).pop()),
        title: Text("Booking Details"),
        centerTitle: true,
        // actions: [
        //   if (DateTime.now()
        //           .difference(widget.bookingModel.createdAt)
        //           .inMinutes <=
        //       10)
        //     IconButton(
        //       style: IconButton.styleFrom(
        //         backgroundColor: colorScheme(context).primary,
        //         foregroundColor: colorScheme(context).onPrimary,
        //       ),
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder:
        //                 (context) => EditBookingScreen(
        //                   bookingModel: widget.bookingModel,
        //                 ),
        //           ),
        //         );
        //       },
        //       icon: const Icon(Icons.edit),
        //     ),
        //   if (DateTime.now()
        //           .difference(widget.bookingModel.createdAt)
        //           .inMinutes <=
        //       10)
        //     IconButton(
        //       style: IconButton.styleFrom(
        //         backgroundColor: colorScheme(context).error,
        //         foregroundColor: colorScheme(context).onPrimary,
        //       ),
        //       onPressed: () {
        //         final bookingProvider = Provider.of<BookingProvider>(
        //           context,
        //           listen: false,
        //         );
        //         bookingProvider.deleteBooking(
        //           id: widget.bookingModel.id,
        //           onSuccess: () {
        //             Navigator.pop(context);
        //             // Navigator.pop(context);
        //             // final bottomNavProvider = Provider.of<BottomNavbarProvider>(
        //             //   context,
        //             //   listen: false,
        //             // );
        //             // bottomNavProvider.changeIndex(index: 1);
        //           },
        //         );
        //       },
        //       icon: const Icon(Icons.delete),
        //     ),
        // ],
      ),
      body: Consumer2<CarProvider, BookingProvider>(
        builder: (context, carProvider, bookingProvider, child) {
          return Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: carProvider.getCarById(id: widget.bookingModel.carId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: txtTheme(context).bodyMedium,
                        ),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: Text('No data found'));
                    }
                    CarModel carModel = snapshot.data!;
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CarouselSlider.builder(
                            itemCount: carModel.imageUrls.length,
                            itemBuilder: (
                              BuildContext context,
                              int index,
                              int realIndex,
                            ) {
                              final imageUrl = carModel.imageUrls[index];
                              return Container(
                                // width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
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
                                          child: Container(
                                            color: Colors.grey[300],
                                          ),
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
                          // Image.network( carModel.imageUrl),
                          const SizedBox(height: 20),
                          Text(
                            carModel.model,
                            style: txtTheme(context).titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            carModel.fuelType,
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
                                    index < (carModel.condition / 2).round()
                                        ? Colors.amber
                                        : Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                          Divider(color: Colors.grey.shade300),
                          const SizedBox(height: 8),
                          Text(
                            'Description',
                            style: txtTheme(context).titleSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            carModel.description,
                            style: txtTheme(context).bodySmall!.copyWith(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Divider(color: Colors.grey.shade300),
                          const SizedBox(height: 8),
                          Text(
                            'Facilities',
                            style: txtTheme(context).titleSmall,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 16,
                            runSpacing: 12,

                            children: [
                              CarWidget.facilityContainer(
                                icon: Icons.people,
                                text: carModel.seats.toString(),
                                context: context,
                              ),
                              CarWidget.facilityContainer(
                                icon: Icons.speed,
                                text: '${carModel.speed} km/h',
                                context: context,
                              ),
                              CarWidget.facilityContainer(
                                icon: Icons.settings,
                                text: carModel.transmission,
                                context: context,
                              ),
                              CarWidget.facilityContainer(
                                icon: Icons.ac_unit,
                                text:
                                    carModel.airConditioning == true
                                        ? "Yes"
                                        : "No",
                                context: context,
                              ),
                              CarWidget.facilityContainer(
                                icon: Icons.color_lens,
                                text: carModel.color,
                                context: context,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Divider(color: Colors.grey.shade300),
                          const SizedBox(height: 8),
                          Text(
                            'Booking Details',
                            style: txtTheme(context).titleSmall,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CarWidget.facilityContainer(
                                icon: Icons.calendar_today,
                                text: DateFormat(
                                  'dd/MM/yyyy',
                                ).format(widget.bookingModel.startDate),
                                context: context,
                              ),
                              const SizedBox(width: 16),
                              Text('to', style: txtTheme(context).bodyMedium),
                              const SizedBox(width: 16),
                              CarWidget.facilityContainer(
                                icon: Icons.calendar_today,
                                text: DateFormat(
                                  'dd/MM/yyyy',
                                ).format(widget.bookingModel.endDate),
                                context: context,
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Start Location:',
                                style: txtTheme(context).titleSmall,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.bookingModel.startLocation,
                                  textAlign: TextAlign.start,
                                  style: txtTheme(context).bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Destination:',
                                style: txtTheme(context).titleSmall,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.bookingModel.destination,
                                  textAlign: TextAlign.start,
                                  style: txtTheme(context).bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
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
                          text: widget.bookingModel.totalPrice.toString(),
                          style: txtTheme(context).titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: "/ $totalDays days",
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
          );
        },
      ),
    );
  }
}
