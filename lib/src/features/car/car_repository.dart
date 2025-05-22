import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rentit/src/common/model/car_model.dart';

class CarRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //! -------------------------- GET ALL CARS -------------------------- //!
  Future<Either<String, List<CarModel>>> getAllCars() async {
    try {
      final carsCollection = _firestore.collection('cars');
      final snapshot = await carsCollection.get();
      final List<CarModel> carsList =
          snapshot.docs.map((doc) => CarModel.fromJson(doc.data())).toList();
      return Right(carsList);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! -------------------------- GET CAR BY ID -------------------------- //!
  Future<Either<String, CarModel>> getCarById({required String id}) async {
    try {
      final carsCollection = _firestore.collection('cars');
      final docSnapshot = await carsCollection.doc(id).get();
      if (docSnapshot.exists) {
        final car = CarModel.fromJson(docSnapshot.data()!);
        return Right(car);
      } else {
        return Left('Car not found');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! -------------------------- ADD CAR --------------------------
  Future<Either<String, String>> addCar({
    required CarModel car,
    required List<File> imagesList,
  }) async {
    try {
      final carsCollection = _firestore.collection('cars');
      final docSnapshot = await carsCollection.doc(car.id).get();
      if (docSnapshot.exists) {
        return const Left('Car with this ID already exists');
      }

      // Upload images to Firebase Storage and get their URLs
      final List<String> imageUrls = [];
      for (var image in imagesList) {
        final fileName = '${car.id}_${DateTime.now().millisecondsSinceEpoch}';
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('car_images')
            .child(fileName);
        final uploadTask = await storageRef.putFile(image);
        final imageUrl = await uploadTask.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      // Add image URLs to the car model
      final updatedCar = car.copyWith(imageUrls: imageUrls);

      // Save the car data to Firestore
      await carsCollection.doc(car.id).set(updatedCar.toJson());
      return const Right('Car added successfully');
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! -------------------------- UPDATE CAR -------------------------- //!
  Future<Either<String, CarModel>> updateCar({
    required String carId,
    required CarModel updatedCar,
  }) async {
    try {
      final carsCollection = _firestore.collection('cars');
      final docSnapshot = await carsCollection.doc(carId).get();
      if (!docSnapshot.exists) {
        return const Left('Car not found');
      }

      // Update the car data in Firestore
      await carsCollection.doc(carId).update(updatedCar.toJson());
      return Right(updatedCar);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! -------------------------- DELETE CAR -------------------------- //!
  Future<Either<String, String>> deleteCar({required String carId}) async {
    try {
      final carsCollection = _firestore.collection('cars');
      final docSnapshot = await carsCollection.doc(carId).get();
      if (!docSnapshot.exists) {
        return const Left('Car not found');
      }

      // Delete the car document from Firestore
      await carsCollection.doc(carId).delete();
      return const Right('Car deleted successfully');
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! -------------------------- UPDATE CAR STATUS -------------------------- //!
  Future<Either<String, String>> updateCarStatus({
    required String carId,
    required bool isBooked,
  }) async {
    try {
      final carsCollection = _firestore.collection('cars');
      final docSnapshot = await carsCollection.doc(carId).get();
      if (!docSnapshot.exists) {
        return const Left('Car not found');
      }

      // Update the car's booking status
      await carsCollection.doc(carId).update({'isBooked': isBooked});
      return const Right('Car status updated successfully');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
