class NotificationModel {
  final String id;
  final String carId;
  final String userId;
  final String pickupLocation;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.carId,
    required this.userId,
    this.isRead = false,
    required this.pickupLocation,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      carId: json['carId'] as String,
      userId: json['userId'] as String,
      isRead: json['isRead'] as bool? ?? false,
      pickupLocation: json['pickupLocation'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'carId': carId,
      'userId': userId,
      'isRead': isRead,
      'pickupLocation': pickupLocation,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
