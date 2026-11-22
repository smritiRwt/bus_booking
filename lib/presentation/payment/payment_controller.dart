import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/datasources/preferences_datasource.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/passenger.dart';
import '../../domain/entities/seat.dart';
import '../../domain/entities/trip.dart';
import '../../domain/usecases/create_booking_usecase.dart';
import '../../routes/app_routes.dart';

class PaymentController extends GetxController {
  final CreateBookingUseCase createBookingUseCase = Get.find<CreateBookingUseCase>();
  final PreferencesDataSource prefs = Get.find<PreferencesDataSource>();

  late final TripEntity trip;
  late final List<SeatEntity> selectedSeats;
  late final List<PassengerEntity> passengers;
  late final double baseFare;
  late final double convenienceFee;
  late final double totalAmount;
  late final String contactEmail;
  late final String contactPhone;
  late final String boardingPoint;
  late final String droppingPoint;

  // Payment Options
  final RxString selectedMethod = 'UPI'.obs; // 'UPI', 'CARD', 'CASH'
  final RxBool simulateFailure = false.obs; // Toggle to demonstrate failure handling

  // Processing state
  final RxBool isProcessing = false.obs;
  final RxString processingStatusText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    trip = args['trip'] as TripEntity;
    selectedSeats = args['selectedSeats'] as List<SeatEntity>;
    passengers = args['passengers'] as List<PassengerEntity>;
    baseFare = (args['baseFare'] as num).toDouble();
    convenienceFee = (args['convenienceFee'] as num).toDouble();
    totalAmount = (args['totalAmount'] as num).toDouble();
    contactEmail = args['contactEmail'] as String;
    contactPhone = args['contactPhone'] as String;
    boardingPoint = args['boardingPoint'] as String;
    droppingPoint = args['droppingPoint'] as String;
  }

  Future<void> executePayment() async {
    isProcessing.value = true;
    processingStatusText.value = 'Connecting to payment gateway...';

    await Future.delayed(const Duration(milliseconds: 1000));
    processingStatusText.value = 'Authorizing transaction with bank...';

    await Future.delayed(const Duration(milliseconds: 1200));

    // Check if user chose to simulate failure
    if (simulateFailure.value) {
      isProcessing.value = false;
      _showPaymentFailureDialog();
      return;
    }

    processingStatusText.value = 'Securing seats & generating PNR...';

    try {
      final userId = prefs.getCurrentUserId();
      final seatIds = selectedSeats.map((s) => s.id).toList();

      // Confirms atomically in SQLite transaction
      final confirmedBooking = await createBookingUseCase.execute(
        tripId: trip.id,
        userId: userId,
        contactEmail: contactEmail,
        contactPhone: contactPhone,
        boardingPoint: boardingPoint,
        droppingPoint: droppingPoint,
        seatIds: seatIds,
        passengers: passengers,
        paymentMethod: selectedMethod.value,
        baseFare: baseFare,
        convenienceFee: convenienceFee,
        totalAmount: totalAmount,
      );

      isProcessing.value = false;

      // Navigate to Confirmation Screen
      Get.offNamed(AppRoutes.confirmation, arguments: confirmedBooking);
    } catch (e) {
      isProcessing.value = false;
      Get.snackbar(
        'Booking Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void _showPaymentFailureDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.error_outline_rounded, size: 48, color: Colors.red.shade600),
              ),
              const SizedBox(height: 18),
              const Text(
                'Payment Failed (Demo)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'The payment could not be processed because simulated failure was enabled. No seats were reserved and no money was charged.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.4),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Dismiss'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        simulateFailure.value = false;
                        executePayment();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Try Success'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
