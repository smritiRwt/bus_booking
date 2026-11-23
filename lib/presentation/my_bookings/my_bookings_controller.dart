import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/datasources/preferences_datasource.dart';
import '../../domain/entities/booking.dart';
import '../../domain/usecases/cancel_booking_usecase.dart';
import '../../domain/usecases/get_user_bookings_usecase.dart';
import '../../routes/app_routes.dart';

class MyBookingsController extends GetxController {
  final GetUserBookingsUseCase getBookingsUseCase = Get.find<GetUserBookingsUseCase>();
  final CancelBookingUseCase cancelBookingUseCase = Get.find<CancelBookingUseCase>();
  final PreferencesDataSource prefs = Get.find<PreferencesDataSource>();

  final RxList<BookingEntity> allBookings = <BookingEntity>[].obs;
  final RxBool isLoading = true.obs;

  // Search by PNR
  final TextEditingController searchPnrController = TextEditingController();
  final RxString searchPnrQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadBookings();
  }

  @override
  void onClose() {
    searchPnrController.dispose();
    super.onClose();
  }

  Future<void> loadBookings() async {
    isLoading.value = true;
    try {
      final userId = prefs.getCurrentUserId();
      final bookings = await getBookingsUseCase.getAll(userId);
      allBookings.assignAll(bookings);
    } catch (_) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }

  List<BookingEntity> get upcomingBookings {
    return _applySearchFilter(allBookings.where((b) => b.isConfirmed).toList());
  }

  List<BookingEntity> get completedBookings {
    return _applySearchFilter(allBookings.where((b) => b.isCompleted).toList());
  }

  List<BookingEntity> get cancelledBookings {
    return _applySearchFilter(allBookings.where((b) => b.isCancelled).toList());
  }

  List<BookingEntity> _applySearchFilter(List<BookingEntity> list) {
    if (searchPnrQuery.value.trim().isEmpty) return list;
    final query = searchPnrQuery.value.trim().toUpperCase();
    return list.where((b) => b.pnr.toUpperCase().contains(query)).toList();
  }

  Future<void> cancelBooking(BookingEntity booking, String reason) async {
    try {
      final success = await cancelBookingUseCase.execute(
        bookingId: booking.id!,
        reason: reason,
      );

      if (success) {
        await loadBookings();
        Get.snackbar(
          'Booking Cancelled',
          'Booking PNR ${booking.pnr} has been cancelled and seats released.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Cancellation Error',
        'Could not cancel booking: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void openBookingDetails(BookingEntity booking) {
    Get.toNamed(AppRoutes.bookingDetails, arguments: booking);
  }
}
