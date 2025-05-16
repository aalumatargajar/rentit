import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rentit/src/common/model/brands_model.dart';

class BrandsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //! -------------------------- GET ALL BRANDS -------------------------- //!
  Future<Either<String, List<BrandsModel>>> getAllBrands() async {
    try {
      final brandsCollection = _firestore.collection('brands');
      final snapshot = await brandsCollection.get();
      final List<BrandsModel> brandsList =
          snapshot.docs.map((doc) => BrandsModel.fromJson(doc.data())).toList();
      return Right(brandsList);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! -------------------------- GET BRANDS BY ID -------------------------- //!
  Future<Either<String, BrandsModel>> getBrandsById({
    required String id,
  }) async {
    try {
      final brandsCollection = _firestore.collection('brands');
      final docSnapshot = await brandsCollection.doc(id).get();
      if (docSnapshot.exists) {
        final brand = BrandsModel.fromJson(docSnapshot.data()!);
        return Right(brand);
      } else {
        return Left('Brand not found');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! -------------------------- ADD BRAND -------------------------- //!
  Future<Either<String, String>> addBrand({
    required String name,
    required File image,
  }) async {
    try {
      final brandsCollection = _firestore.collection('brands');
      final storageRef = FirebaseStorage.instance.ref().child(
        'brands/${name}_${DateTime.now().microsecondsSinceEpoch}',
      );
      await storageRef.putFile(image);
      final imageUrl = await storageRef.getDownloadURL();
      final brand = BrandsModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name,
        logoUrl: imageUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await brandsCollection.add(brand.toJson());

      return Right("$name added successfully");
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! -------------------------- UPDATE BRAND -------------------------- //!
  Future<Either<String, BrandsModel>> updateBrand({
    required String id,
    required BrandsModel brand,
  }) async {
    try {
      final brandsCollection = _firestore.collection('brands');
      await brandsCollection.doc(id).update(brand.toJson());
      return Right(brand);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! -------------------------- DELETE BRAND -------------------------- //!
  Future<Either<String, void>> deleteBrand({required String id}) async {
    try {
      final brandsCollection = _firestore.collection('brands');
      await brandsCollection.doc(id).delete();
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
