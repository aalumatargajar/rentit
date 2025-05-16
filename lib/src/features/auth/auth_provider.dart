import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rentit/src/common/const/global_variable.dart';
import 'package:rentit/src/common/const/static_data.dart';
import 'package:rentit/src/common/utils/shared_preference_helper.dart';
import 'package:rentit/src/common/widgets/custom_snackbar.dart';
import 'package:rentit/src/features/auth/auth_repository.dart';
import 'package:rentit/src/features/auth/screen/login_screen.dart';
import 'package:rentit/src/features/bottom_nav/bottom_navbar_screen.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  //! ################### SIGN UP WITH EMAIL AND PASSWORD ###################
  Future<void> signUpWithEmailAndPassword({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      context.loaderOverlay.show();
      notifyListeners();
      final result = await _authRepository.signUpWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );
      result.fold(
        (error) {
          CustomSnackbar.error(context: context, message: error);
        },
        (userModel) {
          CustomSnackbar.success(
            context: context,
            message: 'Account Created Successfully',
          );
          Navigator.pop(context);
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackbar.error(context: context, message: e.toString());
    } finally {
      if (context.mounted) {
        context.loaderOverlay.hide();
      }

      notifyListeners();
    }
  }

  //! ################### LOGIN WITH EMAIL AND PASSWORD ###################
  Future<void> loginWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      context.loaderOverlay.show();
      notifyListeners();
      final result = await _authRepository.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      result.fold(
        (error) {
          CustomSnackbar.error(context: context, message: error);
        },
        (adminModel) {
          SharedPrefHelper.saveBool(isLoggedInText, true);
          StaticData.isLoggedIn = true;
          StaticData.adminAuthenticationModel = adminModel;
          StaticData.id = adminModel.id;
          SharedPrefHelper.saveString(idText, adminModel.id);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const BottomNavbarScreen()),
            (route) => false,
          );
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackbar.error(context: context, message: e.toString());
    } finally {
      if (context.mounted) {
        context.loaderOverlay.hide();
      }

      notifyListeners();
    }
  }

  //! ################### FORGOT PASSWORD ###################
  Future<void> forgotPassword({
    required BuildContext context,
    required String email,
  }) async {
    try {
      context.loaderOverlay.show();
      notifyListeners();
      final result = await _authRepository.forgotPassword(email: email);
      result.fold(
        (error) {
          CustomSnackbar.error(context: context, message: error);
        },
        (message) {
          CustomSnackbar.success(
            context: context,
            message: "A password reset link has been sent to your email",
          );
          Navigator.pop(context);
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackbar.error(context: context, message: e.toString());
    } finally {
      if (context.mounted) {
        context.loaderOverlay.hide();
      }

      notifyListeners();
    }
  }

  //! ################### LOGOUT ###################
  Future<void> logout({required BuildContext context}) async {
    try {
      context.loaderOverlay.show();
      notifyListeners();
      await _authRepository.logout();
      SharedPrefHelper.saveBool(isLoggedInText, false);
      SharedPrefHelper.saveString(idText, '');
      StaticData.isLoggedIn = false;
      StaticData.id = '';

      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      CustomSnackbar.error(context: context, message: e.toString());
    } finally {
      if (context.mounted) {
        context.loaderOverlay.hide();
      }
      notifyListeners();
    }
  }

  //! ################### GET USER DATA ###################
  Future<void> getUserData({
    required BuildContext context,
    required String id,
  }) async {
    try {
      context.loaderOverlay.show();
      notifyListeners();
      if (id.isNotEmpty) {
        final result = await _authRepository.getAdminData(id: id);
        result.fold(
          (error) {
            CustomSnackbar.error(context: context, message: error);
          },
          (adminModel) {
            StaticData.adminAuthenticationModel = adminModel;
          },
        );
      } else {
        // StaticData.id = '';
        // SharedPrefHelper.saveString(idText, '');
        // StaticData.isLoggedIn = false;
        // SharedPrefHelper.saveBool(isLoggedInText, false);
        // MyAppRouter.clearAndNavigate(context, AppRoute.login);
      }
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackbar.error(context: context, message: e.toString());
    } finally {
      if (context.mounted) {
        context.loaderOverlay.hide();
      }
      notifyListeners();
    }
  }

  //! ################### UPDATE USER DATA ###################
  Future<void> updateUserData({
    required BuildContext context,
    required String id,
    required String name,
    required String phoneNumber,
  }) async {
    try {
      context.loaderOverlay.show();
      notifyListeners();
      final result = await _authRepository.updateAdminData(
        name: name,
        id: id,
        phoneNumber: phoneNumber,
      );
      result.fold(
        (error) {
          CustomSnackbar.error(context: context, message: error);
        },
        (userModel) {
          getUserData(context: context, id: id);

          Navigator.pop(context);
          CustomSnackbar.success(
            context: context,
            message: 'Profile Updated Successfully',
          );
        },
      );
    } catch (e) {
      if (!context.mounted) return;
      CustomSnackbar.error(context: context, message: e.toString());
    } finally {
      if (context.mounted) {
        context.loaderOverlay.hide();
      }
      notifyListeners();
    }
  }
}
