import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rentit/src/common/model/car_model.dart';
import 'package:rentit/src/common/widgets/custom_snackbar.dart';
import 'package:rentit/src/features/car/car_details_screen.dart';
import 'package:rentit/src/features/car/car_repository.dart';

class CarProvider extends ChangeNotifier {
  final CarRepository _carRepository = CarRepository();

  //! --------------------- GET CARS ---------------------
  List<CarModel> _carList = [];
  List<CarModel> get carList => _carList;

  Future<void> getAllCars({required BuildContext context}) async {
    final result = await _carRepository.getAllCars();
    result.fold(
      (error) {
        CustomSnackbar.error(context: context, message: error);
      },
      (cars) {
        _carList = cars;
        notifyListeners();
      },
    );
  }

  //! ----------------- ADD CAR -----------------
  Future<void> addCar({
    required CarModel car,
    required List<File> imagesList,
    required BuildContext context,
  }) async {
    context.loaderOverlay.show();
    notifyListeners();
    try {
      final result = await _carRepository.addCar(
        car: car,
        imagesList: imagesList,
      );
      result.fold(
        (error) {
          CustomSnackbar.error(context: context, message: error);
        },
        (success) {
          CustomSnackbar.success(context: context, message: success);
          Navigator.pop(context);
        },
      );
    } catch (e) {
      CustomSnackbar.error(context: context, message: e.toString());
    } finally {
      context.loaderOverlay.hide();
      notifyListeners();
    }
  }

  // int _selectedBrandId = 0;
  // int get selectedBrandId => _selectedBrandId;
  // void updateSelectedBrandId({required int brandId}) {
  //   _selectedBrandId = brandId;
  //   if (brandId == 0) {
  //     _carList = dummyCarsList;
  //   } else {
  //     _carList =
  //         dummyCarsList
  //             .where((car) => car.brandId == brandId.toString())
  //             .toList();
  //   }

  //   notifyListeners();
  // }

  //! ----------------- UPDATE CAR -----------------
  Future<void> updateCar({
    required CarModel car,
    required BuildContext context,
  }) async {
    context.loaderOverlay.show();
    notifyListeners();
    try {
      final result = await _carRepository.updateCar(
        carId: car.id,
        updatedCar: car,
      );
      result.fold(
        (error) {
          CustomSnackbar.error(context: context, message: error);
        },
        (carModel) {
          Navigator.pop(context);
          Navigator.pop(context);

          CustomSnackbar.success(
            context: context,
            message: "Car updated successfully",
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarDetailsScreen(carModel: carModel),
            ),
          );
        },
      );
    } catch (e) {
      CustomSnackbar.error(context: context, message: e.toString());
    } finally {
      context.loaderOverlay.hide();
      notifyListeners();
    }
  }

  //! ----------------- DELETE CAR -----------------
  Future<void> deleteCar({
    required String carId,
    required BuildContext context,
  }) async {
    context.loaderOverlay.show();
    notifyListeners();
    try {
      final result = await _carRepository.deleteCar(carId: carId);
      result.fold(
        (error) {
          CustomSnackbar.error(context: context, message: error);
        },
        (success) {
          CustomSnackbar.success(context: context, message: success);
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );
    } catch (e) {
      CustomSnackbar.error(context: context, message: e.toString());
    } finally {
      context.loaderOverlay.hide();
      notifyListeners();
    }
  }

  //! ---------------- GET CAR BY ID ----------------
  Future<CarModel?> getCarById({required String id}) async {
    final result = await _carRepository.getCarById(id: id);
    return result.fold(
      (error) {
        return null;
      },
      (car) {
        return car;
      },
    );
  }

  //! ---------------- UPDATE CAR STATUS ----------------
  Future<void> updateCarStatus({
    required String carId,
    required bool isBooked,
    required BuildContext context,
  }) async {
    context.loaderOverlay.show();
    notifyListeners();
    try {
      final result = await _carRepository.updateCarStatus(
        carId: carId,
        isBooked: isBooked,
      );
      result.fold(
        (error) {
          log(error);
        },
        (success) {
          log(success);
        },
      );
    } catch (e) {
      log(e.toString());
    } finally {
      context.loaderOverlay.hide();
      notifyListeners();
    }
  }
}
