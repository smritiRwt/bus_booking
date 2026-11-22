import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/datasources/preferences_datasource.dart';
import '../../domain/entities/passenger.dart';
import '../../domain/entities/seat.dart';
import '../../domain/entities/trip.dart';
import '../../routes/app_routes.dart';

class PassengerFormData {
  final SeatEntity seat;
  final TextEditingController nameController;
  final TextEditingController ageController;
  String gender;

  PassengerFormData({
    required this.seat,
    required this.nameController,
    required this.ageController,
    this.gender = 'Male',
  });
}

class PassengerDetailsController extends GetxController {
  final PreferencesDataSource prefs = Get.find<PreferencesDataSource>();

  late final TripEntity trip;
  late final List<SeatEntity> selectedSeats;
  late final double baseFare;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Primary Contact
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Dynamic Passenger Forms
  final List<PassengerFormData> passengerForms = [];

  // Selected Boarding and Dropping points
  final RxString selectedBoardingPoint = ''.obs;
  final RxString selectedDroppingPoint = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    trip = args['trip'] as TripEntity;
    selectedSeats = args['selectedSeats'] as List<SeatEntity>;
    baseFare = (args['baseFare'] as num).toDouble();

    // Default contact details from preferences
    phoneController.text = prefs.getUserPhone();
    emailController.text = prefs.getUserEmail();

    // Initialize points
    if (trip.boardingPoints.isNotEmpty) {
      selectedBoardingPoint.value = trip.boardingPoints.first.pointName;
    }
    if (trip.droppingPoints.isNotEmpty) {
      selectedDroppingPoint.value = trip.droppingPoints.first.pointName;
    }

    // Initialize passenger forms for each selected seat
    for (int i = 0; i < selectedSeats.length; i++) {
      final seat = selectedSeats[i];
      // First passenger defaults to primary user's name
      final defaultName = i == 0 ? prefs.getUserName() : '';
      passengerForms.add(
        PassengerFormData(
          seat: seat,
          nameController: TextEditingController(text: defaultName),
          ageController: TextEditingController(text: i == 0 ? '25' : ''),
          gender: i == 0 ? 'Female' : 'Male',
        ),
      );
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    emailController.dispose();
    for (final form in passengerForms) {
      form.nameController.dispose();
      form.ageController.dispose();
    }
    super.onClose();
  }

  void proceedToSummary() {
    if (!formKey.currentState!.validate()) {
      Get.snackbar(
        'Incomplete Details',
        'Please correct the highlighted errors before continuing',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    final passengersList = passengerForms.map((f) {
      return PassengerEntity(
        fullName: f.nameController.text.trim(),
        age: int.parse(f.ageController.text.trim()),
        gender: f.gender,
        seatNumber: f.seat.seatNumber,
      );
    }).toList();

    Get.toNamed(
      AppRoutes.bookingSummary,
      arguments: {
        'trip': trip,
        'selectedSeats': selectedSeats,
        'passengers': passengersList,
        'baseFare': baseFare,
        'contactEmail': emailController.text.trim(),
        'contactPhone': phoneController.text.trim(),
        'boardingPoint': selectedBoardingPoint.value,
        'droppingPoint': selectedDroppingPoint.value,
      },
    );
  }
}
