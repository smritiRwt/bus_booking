import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../domain/entities/seat.dart';
import '../../domain/entities/trip.dart';
import '../../domain/usecases/get_trip_details_usecase.dart';
import '../../routes/app_routes.dart';

class SeatSelectionController extends GetxController {
  final GetTripDetailsUseCase getTripDetailsUseCase = Get.find<GetTripDetailsUseCase>();

  late final TripEntity trip;
  final RxList<SeatEntity> allSeats = <SeatEntity>[].obs;
  final RxList<SeatEntity> selectedSeats = <SeatEntity>[].obs;
  final RxBool isLoading = true.obs;
  final RxString activeDeck = 'lower'.obs; // 'lower' or 'upper'

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is TripEntity) {
      trip = args;
      loadSeats();
    } else {
      Get.back();
    }
  }

  Future<void> loadSeats() async {
    isLoading.value = true;
    try {
      final seats = await getTripDetailsUseCase.getSeats(trip.id);
      allSeats.assignAll(seats);
    } catch (_) {
      Get.snackbar(
        'Error',
        'Failed to load seat layout',
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSeat(SeatEntity seat) {
    if (seat.isBooked) {
      Get.snackbar(
        'Seat Unavailable',
        'Seat ${seat.seatNumber} is already booked',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    final isAlreadySelected = selectedSeats.any((s) => s.id == seat.id);

    if (isAlreadySelected) {
      selectedSeats.removeWhere((s) => s.id == seat.id);
    } else {
      if (selectedSeats.length >= AppConstants.maxSeatsPerBooking) {
        Get.snackbar(
          'Maximum Limit Reached',
          AppStrings.maxSeatsAlert,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade800,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
        return;
      }
      selectedSeats.add(seat);
    }
  }

  double get totalPrice {
    return selectedSeats.fold(0.0, (sum, seat) => sum + seat.price);
  }

  void proceedToPassengerDetails() {
    if (selectedSeats.isEmpty) {
      Get.snackbar(
        'No Seat Selected',
        'Please select at least 1 seat to continue',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade800,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    Get.toNamed(
      AppRoutes.passengerDetails,
      arguments: {
        'trip': trip,
        'selectedSeats': selectedSeats.toList(),
        'baseFare': totalPrice,
      },
    );
  }
}
