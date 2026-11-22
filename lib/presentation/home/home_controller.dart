import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/booking.dart';
import '../../domain/usecases/get_user_bookings_usecase.dart';
import '../../domain/usecases/search_trips_usecase.dart';
import '../../data/datasources/preferences_datasource.dart';
import '../../routes/app_routes.dart';

class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  final SearchTripsUseCase searchTripsUseCase = Get.find<SearchTripsUseCase>();
  final GetUserBookingsUseCase getUserBookingsUseCase = Get.find<GetUserBookingsUseCase>();
  final PreferencesDataSource prefs = Get.find<PreferencesDataSource>();

  // State
  final RxString userName = 'Traveler'.obs;
  final RxString fromCity = 'Delhi'.obs;
  final RxString toCity = 'Chandigarh'.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxList<String> cities = <String>[].obs;
  final Rxn<BookingEntity> upcomingBooking = Rxn<BookingEntity>();
  final RxBool isLoadingUpcoming = false.obs;

  // Animation & Interaction states
  final RxDouble swapRotationAngle = 0.0.obs;
  final RxString appliedCoupon = ''.obs;

  String get timeGreeting {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good Morning ☀️';
    if (hour >= 12 && hour < 17) return 'Good Afternoon 🌤️';
    if (hour >= 17 && hour < 21) return 'Good Evening 🌅';
    return 'Night Voyager 🌙';
  }

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  void _loadInitialData() {
    userName.value = prefs.getUserName();
    cities.assignAll(AppConstants.popularCities);
    loadUpcomingBooking();
  }

  Future<void> loadUpcomingBooking() async {
    isLoadingUpcoming.value = true;
    try {
      final userId = prefs.getCurrentUserId();
      final upcoming = await getUserBookingsUseCase.getUpcoming(userId);
      upcomingBooking.value = upcoming;
    } catch (_) {
      upcomingBooking.value = null;
    } finally {
      isLoadingUpcoming.value = false;
    }
  }

  void swapCities() {
    HapticFeedback.lightImpact();
    swapRotationAngle.value += 3.14159; // Rotate 180 degrees
    final temp = fromCity.value;
    fromCity.value = toCity.value;
    toCity.value = temp;
  }

  void setDate(DateTime date) {
    HapticFeedback.selectionClick();
    selectedDate.value = date;
  }

  void selectQuickRoute(String from, String to) {
    HapticFeedback.selectionClick();
    fromCity.value = from;
    toCity.value = to;
    searchBuses();
  }

  void applyMysteryCoupon() {
    appliedCoupon.value = 'SMARTBUS100';
    Get.snackbar(
      'Coupon Applied! 🎉',
      'Code "SMARTBUS100" unlocked for ₹100 OFF on your next booking!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF047857),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }

  void searchBuses() {
    HapticFeedback.mediumImpact();
    if (fromCity.value == toCity.value) {
      Get.snackbar(
        'Invalid Route',
        'Source and destination cities cannot be the same',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    Get.toNamed(
      AppRoutes.search,
      arguments: {
        'sourceCity': fromCity.value,
        'destinationCity': toCity.value,
        'journeyDate': DateFormatter.toDbString(selectedDate.value),
        'journeyDateTime': selectedDate.value,
      },
    );
  }
}
