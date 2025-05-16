import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rentit/src/common/model/admin_authentication_model.dart';

class AuthRepository {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  //! ################### SIGN UP WITH EMAIL AND PASSWORD ###################
  Future<Either<String, AdminAuthenticationModel>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final adminCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (adminCredential.user != null) {
        final admin = adminCredential.user!;
        final adminModel = AdminAuthenticationModel(
          id: admin.uid,
          imageUrl: '',
          phoneNumber: phoneNumber,

          name: name,
          email: email,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore
            .collection('data')
            .doc(admin.uid)
            .set(adminModel.toJson());
        return Right(adminModel);
      } else {
        return const Left('Admin not created');
      }
    } on FirebaseAuthException catch (e) {
      log("Sign Up Error: ${e.message}");
      return Left(e.message ?? 'An error occurred');
    }
  }

  //! ################### LOGIN WITH EMAIL AND PASSWORD ###################
  Future<Either<String, AdminAuthenticationModel>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final user = userCredential.user!;
        final userDoc = await _firestore.collection('data').doc(user.uid).get();
        final userModel = AdminAuthenticationModel.fromJson(userDoc.data()!);
        return Right(userModel);
      } else {
        return const Left('Admin not found');
      }
    } on FirebaseAuthException catch (e) {
      log("Login Error: ${e.message}");
      return Left(e.message ?? 'An error occurred');
    }
  }

  //! ################### FORGOT PASSWORD ###################
  Future<Either<String, bool>> forgotPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(true);
    } on FirebaseAuthException catch (e) {
      log("Forgot Password Error: ${e.message}");
      return Left(e.message ?? 'An error occurred');
    }
  }

  //! ################### LOGOUT ###################
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  //! ################### GET ADMIN DATA ###################
  Future<Either<String, AdminAuthenticationModel>> getAdminData({
    required String id,
  }) async {
    try {
      final userDoc = await _firestore.collection('data').doc(id).get();
      return Right(AdminAuthenticationModel.fromJson(userDoc.data()!));
    } catch (e) {
      log("Get Admin Data Error: $e");
      return Left(e.toString());
    }
  }

  //! ################### UPDATE ADMIN DATA ###################
  Future<Either<String, AdminAuthenticationModel>> updateAdminData({
    required String id,
    required String name,
    required String phoneNumber,
  }) async {
    try {
      await _firestore.collection('data').doc(id).update(({
        'name': name,
        'phoneNumber': phoneNumber,
        'updatedAt': DateTime.now(),
      }));
      final userDoc = await _firestore.collection('data').doc(id).get();
      return Right(AdminAuthenticationModel.fromJson(userDoc.data()!));
    } catch (e) {
      log("Update Admin Data Error: $e");
      return Left(e.toString());
    }
  }
}
