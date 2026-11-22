import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/booking.dart';
import '../../domain/usecases/get_user_bookings_usecase.dart';
import '../../domain/usecases/search_trips_usecase.dart';
import '../../data/datasources/preferences_datasource.dart';
import '../../routes/app_routes.dart';

class HomeController extends GetxController {
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
    final temp = fromCity.value;
    fromCity.value = toCity.value;
    toCity.value = temp;
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  void selectQuickRoute(String from, String to) {
    fromCity.value = from;
    toCity.value = to;
    searchBuses();
  }

  void searchBuses() {
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
