import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String carId;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  final String startLocation;
  final String destination;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingModel({
    required this.id,
    required this.carId,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.startLocation,
    required this.destination,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      carId: json['carId'] as String,
      userId: json['userId'] as String,
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: (json['endDate'] as Timestamp).toDate(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      startLocation: json['startLocation'] as String,
      destination: json['destination'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'carId': carId,
      'userId': userId,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(
        endDate.add(Duration(hours: 23, minutes: 59, seconds: 59)),
      ),
      'totalPrice': totalPrice,
      'startLocation': startLocation,
      'destination': destination,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  BookingModel copyWith({
    String? id,
    String? carId,
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
    double? totalPrice,
    String? startLocation,
    String? destination,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalPrice: totalPrice ?? this.totalPrice,
      startLocation: startLocation ?? this.startLocation,
      destination: destination ?? this.destination,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// List<BookingModel> dummyBookingList = [
//   BookingModel(
//     id: '1',
//     carId: '1',
//     userId: 'user1',
//     startDate: DateTime.now(),
//     endDate: DateTime.now().add(Duration(days: 3)),
//     totalPrice: 3000.0,
//     startLocation: 'Location A',
//     destination: 'Location B',
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//   ),
//   BookingModel(
//     id: '2',
//     carId: '2',
//     userId: 'user2',
//     startDate: DateTime.now(),
//     endDate: DateTime.now().add(Duration(days: 5)),
//     totalPrice: 5000.0,
//     startLocation: 'Location C',
//     destination: 'Location D',
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//   ),
// ];
