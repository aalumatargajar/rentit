import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rentit/src/common/model/booking_model.dart';

class BookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //! ------------------ ADD BOOKING --------------------
  Future<Either<String, String>> addBooking({
    required BookingModel booking,
  }) async {
    try {
      _firestore.collection('booking').doc(booking.id).set(booking.toJson());

      return Right("Booking added successfully");
    } catch (e) {
      log("Error Add Booking: ${e.toString()}");
      return Left("Error Add Booking: ${e.toString()}");
    }
  }
}
