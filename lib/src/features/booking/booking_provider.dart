import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:rentit/src/common/model/booking_model.dart';
import 'package:rentit/src/common/widgets/custom_snackbar.dart';
import 'package:rentit/src/features/booking/booking_repository.dart';
import 'package:rentit/src/features/car/car_provider.dart';

class BookingProvider extends ChangeNotifier {
  final BookingRepository _bookingRepository = BookingRepository();
  final List<BookingModel> _bookingList = dummyBookingList;
  List<BookingModel> get bookingList => _bookingList;

  //! ----------------- ADD BOOKING -----------------
  Future<void> addBooking({
    required BookingModel booking,
    required BuildContext context,
    required Function() onSuccess,
  }) async {
    context.loaderOverlay.show();
    notifyListeners();
    try {
      final result = await _bookingRepository.addBooking(booking: booking);
      result.fold(
        (error) {
          CustomSnackbar.error(context: context, message: error);
        },
        (success) {
          final carProvider = Provider.of<CarProvider>(context, listen: false);
          carProvider.updateCarStatus(
            carId: booking.carId,
            isBooked: true,
            context: context,
          );
          CustomSnackbar.success(context: context, message: success);
          onSuccess();
        },
      );
    } catch (e) {
      CustomSnackbar.error(context: context, message: e.toString());
    } finally {
      context.loaderOverlay.hide();
      notifyListeners();
    }
  }

  //! --------------- UPDATE BOOKING ---------------
  void updateBooking({
    required BookingModel booking,
    required Function() onSuccess,
  }) {
    int index = _bookingList.indexWhere((b) => b.id == booking.id);
    if (index != -1) {
      _bookingList[index] = booking;
      onSuccess();
      notifyListeners();
    }
  }

  //! --------------- DELETE BOOKING ---------------
  void deleteBooking({required String id, required Function() onSuccess}) {
    _bookingList.removeWhere((b) => b.id == id);
    onSuccess();
    notifyListeners();
  }
}
