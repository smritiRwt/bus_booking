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

  double get gstAmount => (baseFare * AppConstants.gstRatePercent) / 100;

  double get totalAmount => baseFare + convenienceFee + gstAmount;

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
