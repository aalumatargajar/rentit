import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAuthenticationModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdminAuthenticationModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminAuthenticationModel.fromJson(Map<String, dynamic> json) {
    return AdminAuthenticationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
