import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rentit/src/common/model/brands_model.dart';
import 'package:rentit/src/common/widgets/custom_snackbar.dart';
import 'package:rentit/src/features/brands/brands_repository.dart';

class BrandsProvider extends ChangeNotifier {
  final BrandsRepository _brandsRepository = BrandsRepository();

  //! --------------------- GET BRANDS ---------------------

  List<BrandsModel> _brandsList = [];
  List<BrandsModel> get brandsList => _brandsList;

  Future<void> getAllBrands({required BuildContext context}) async {
    final result = await _brandsRepository.getAllBrands();
    result.fold(
      (error) {
        // Handle error
        CustomSnackbar.error(context: context, message: error);
      },
      (brands) {
        _brandsList = brands;
        notifyListeners();
      },
    );
  }

  //! ----------------- ADD BRAND -----------------
  Future<void> addBrand({
    required String name,
    required File image,
    required BuildContext context,
  }) async {
    context.loaderOverlay.show();
    notifyListeners();
    try {
      final result = await _brandsRepository.addBrand(name: name, image: image);
      result.fold(
        (error) {
          // Handle error
          CustomSnackbar.error(context: context, message: error);
        },
        (success) {
          CustomSnackbar.success(context: context, message: success);
          Navigator.pop(context);

          getAllBrands(context: context);
        },
      );
    } catch (e) {
      log(e.toString());
      CustomSnackbar.error(context: context, message: e.toString());
    } finally {
      context.loaderOverlay.hide();
      notifyListeners();
    }
  }

  //! ----------------- EDIT BRAND -----------------
  void editBrand({required BrandsModel brand, required BuildContext context}) {
    final index = _brandsList.indexWhere((b) => b.id == brand.id);
    if (index != -1) {
      _brandsList[index] = brand;
    }
    Navigator.pop(context);
    notifyListeners();
  }

  //! ----------------- DELETE BRAND -----------------
  void deleteBrand({required String brandId, required BuildContext context}) {
    _brandsList.removeWhere((brand) => brand.id == brandId);
    Navigator.pop(context);
    notifyListeners();
  }

  //! ----------------- SEARCH BRAND -----------------
  void searchBrand({required String query}) {
    _brandsList =
        _brandsList
            .where(
              (brand) => brand.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
    notifyListeners();
  }
}
