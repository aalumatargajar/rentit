import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rentit/src/common/const/global_variable.dart';
import 'package:rentit/src/common/model/car_model.dart';
import 'package:rentit/src/common/model/notifcation_model.dart';
import 'package:rentit/src/common/model/user_authentication_model.dart';
import 'package:rentit/src/common/widgets/custom_snackbar.dart';
import 'package:rentit/src/common/widgets/custom_widgets.dart';
import 'package:rentit/src/features/auth/auth_provider.dart';
import 'package:rentit/src/features/car/car_provider.dart';
import 'package:rentit/src/features/notifications/notification_provider.dart';
import 'package:shimmer/shimmer.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Query query() {
    return _firestore
        .collection('notifications')
        .orderBy('createdAt', descending: true);
  }

  Future<CarModel?> getCarById({required String carId}) async {
    final provider = Provider.of<CarProvider>(context, listen: false);
    return await provider.getCarById(id: carId);
  }

  Future<UserAuthenticationModel?> getUserById({required String userId}) async {
    final provider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );
    return await provider.getUserById(id: userId);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateAllNotificationsRead();
    });
  }

  updateAllNotificationsRead() async {
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    await provider.updateAllNotificationsRead();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FirestorePagination(
          physics: BouncingScrollPhysics(),
          query: query(),
          limit: 5,
          isLive: true,
          bottomLoader: CustomWidgets.shimmerLoader(
            context: context,
            height: 80,
          ),
          initialLoader: CustomWidgets.shimmerLoader(
            context: context,
            height: 80,
          ),
          onEmpty: CustomWidgets.emptyWidget(
            context: context,
            title: "No Notification Found",
          ),
          separatorBuilder: (p0, p1) => SizedBox(height: 8),
          itemBuilder: (context, docs, index) {
            final data = docs[index].data() as Map<String, dynamic>;

            final notification = NotificationModel.fromJson(data);

            return FutureBuilder(
              future: getCarById(carId: notification.carId),
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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder:
                      //         (context) => BookingDetailsScreen(
                      //           bookingModel: notification,
                      //         ),
                      //   ),
                      // );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
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
                            height: 80,
                            width: double.infinity,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 2,
                            children: [
                              Text(
                                car.model,
                                style: txtTheme(context).titleSmall,
                              ),
                              FutureBuilder(
                                future: getUserById(
                                  userId: notification.userId,
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text(
                                        "Error fetching user:  ${snapshot.error}",
                                        style: txtTheme(context).bodyMedium,
                                      ),
                                    );
                                  }
                                  final user = snapshot.data;
                                  if (user == null) {
                                    return Center(
                                      child: Text(
                                        "User not found",
                                        style: txtTheme(context).bodyMedium,
                                      ),
                                    );
                                  }
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "User Name: ",
                                              style: txtTheme(
                                                context,
                                              ).labelSmall!.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            TextSpan(
                                              text: user.name,
                                              style:
                                                  txtTheme(context).labelLarge!,
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Clipboard.setData(
                                            ClipboardData(
                                              text: user.phoneNumber,
                                            ),
                                          );
                                          CustomSnackbar.success(
                                            context: context,
                                            message:
                                                '${user.phoneNumber} copied',
                                          );
                                        },
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Phone No: ",
                                                style: txtTheme(
                                                  context,
                                                ).labelSmall!.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              TextSpan(
                                                text: user.phoneNumber,
                                                style: txtTheme(
                                                  context,
                                                ).labelLarge!.copyWith(
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),

                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Pickup Location: ",
                                      style: txtTheme(
                                        context,
                                      ).labelSmall!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    TextSpan(
                                      text: notification.pickupLocation,
                                      style: txtTheme(context).labelLarge!,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
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
