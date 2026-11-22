import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/passenger.dart';
import '../../domain/entities/seat.dart';
import '../../domain/entities/trip.dart';
import '../../routes/app_routes.dart';

class BookingSummaryController extends GetxController {
  late final TripEntity trip;
  late final List<SeatEntity> selectedSeats;
  late final List<PassengerEntity> passengers;
  late final double baseFare;
  late final String contactEmail;
  late final String contactPhone;
  late final String boardingPoint;
  late final String droppingPoint;

  final double convenienceFee = AppConstants.convenienceFee;

  final RxString appliedPromoCode = ''.obs;
  final RxDouble discountAmount = 0.0.obs;
  final TextEditingController promoController = TextEditingController();

  double get gstAmount => (baseFare * AppConstants.gstRatePercent) / 100;

  double get totalAmount =>
      max(0.0, baseFare + convenienceFee + gstAmount - discountAmount.value);

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    trip = args['trip'] as TripEntity;
    selectedSeats = args['selectedSeats'] as List<SeatEntity>;
    passengers = args['passengers'] as List<PassengerEntity>;
    baseFare = (args['baseFare'] as num).toDouble();
    contactEmail = args['contactEmail'] as String;
    contactPhone = args['contactPhone'] as String;
    boardingPoint = args['boardingPoint'] as String;
    droppingPoint = args['droppingPoint'] as String;
  }

  @override
  void onClose() {
    promoController.dispose();
    super.onClose();
  }

  void applyPromoCode() {
    final code = promoController.text.trim().toUpperCase();
    if (code == 'SMARTBUS100' || code == 'SMART100') {
      appliedPromoCode.value = code;
      discountAmount.value = 100.0;
      Get.snackbar(
        'Promo Applied! 🎉',
        'Coupon $code saved you ₹100 on this booking!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF047857),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } else {
      Get.snackbar(
        'Invalid Coupon',
        'Use "SMARTBUS100" to get ₹100 instant discount',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void removePromo() {
    appliedPromoCode.value = '';
    discountAmount.value = 0.0;
    promoController.clear();
  }

  void proceedToPayment() {
    Get.toNamed(
      AppRoutes.payment,
      arguments: {
        'trip': trip,
        'selectedSeats': selectedSeats,
        'passengers': passengers,
        'baseFare': baseFare,
        'convenienceFee': convenienceFee,
        'totalAmount': totalAmount,
        'contactEmail': contactEmail,
        'contactPhone': contactPhone,
        'boardingPoint': boardingPoint,
        'droppingPoint': droppingPoint,
      },
    );
  }
}
