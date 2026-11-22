import 'package:get/get.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/trip.dart';
import '../../domain/repositories/bus_repository.dart';
import '../../domain/usecases/search_trips_usecase.dart';

class SearchBusController extends GetxController {
  final SearchTripsUseCase searchTripsUseCase = Get.find<SearchTripsUseCase>();

  // Route Parameters
  late String sourceCity;
  late String destinationCity;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  // State
  final RxList<TripEntity> trips = <TripEntity>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  // Filter States
  final RxnBool filterAc = RxnBool();
  final RxnBool filterSleeper = RxnBool();
  final RxString sortBy = 'departure_asc'.obs; // 'price_asc', 'price_desc', 'rating_desc', 'departure_asc'
  final RxString departureSlot = ''.obs; // 'morning', 'afternoon', 'evening', 'night'
  final RxDouble minRating = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    sourceCity = args['sourceCity'] as String? ?? 'Delhi';
    destinationCity = args['destinationCity'] as String? ?? 'Chandigarh';

    if (args['journeyDateTime'] is DateTime) {
      selectedDate.value = args['journeyDateTime'] as DateTime;
    } else if (args['journeyDate'] is String) {
      selectedDate.value = DateFormatter.fromDbString(args['journeyDate'] as String);
    }

    fetchTrips();
  }

  Future<void> fetchTrips() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final filter = BusSearchFilter(
        isAc: filterAc.value,
        isSleeper: filterSleeper.value,
        sortBy: sortBy.value,
        departureTimeSlot: departureSlot.value.isEmpty ? null : departureSlot.value,
        minRating: minRating.value > 0 ? minRating.value : null,
      );

      final dateStr = DateFormatter.toDbString(selectedDate.value);
      final results = await searchTripsUseCase.execute(
        sourceCity: sourceCity,
        destinationCity: destinationCity,
        journeyDate: dateStr,
        filter: filter,
      );

      trips.assignAll(results);
    } catch (e) {
      errorMessage.value = 'Failed to load buses: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void changeDate(DateTime newDate) {
    selectedDate.value = newDate;
    fetchTrips();
  }

  void toggleAcFilter() {
    if (filterAc.value == true) {
      filterAc.value = null;
    } else {
      filterAc.value = true;
    }
    fetchTrips();
  }

  void toggleSleeperFilter() {
    if (filterSleeper.value == true) {
      filterSleeper.value = null;
    } else {
      filterSleeper.value = true;
    }
    fetchTrips();
  }

  void setSortBy(String sort) {
    sortBy.value = sort;
    fetchTrips();
  }

  void applyFullFilter({
    bool? isAc,
    bool? isSleeper,
    String? sort,
    String? timeSlot,
    double? rating,
  }) {
    filterAc.value = isAc;
    filterSleeper.value = isSleeper;
    if (sort != null) sortBy.value = sort;
    departureSlot.value = timeSlot ?? '';
    minRating.value = rating ?? 0.0;

    fetchTrips();
  }

  void resetFilters() {
    filterAc.value = null;
    filterSleeper.value = null;
    sortBy.value = 'departure_asc';
    departureSlot.value = '';
    minRating.value = 0.0;

    fetchTrips();
  }

  bool get hasActiveFilters {
    return filterAc.value != null ||
        filterSleeper.value != null ||
        sortBy.value != 'departure_asc' ||
        departureSlot.value.isNotEmpty ||
        minRating.value > 0.0;
  }
}
