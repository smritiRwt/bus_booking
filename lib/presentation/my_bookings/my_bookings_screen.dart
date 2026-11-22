import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/empty_state_view.dart';
import '../../core/widgets/status_badge.dart';
import '../../domain/entities/booking.dart';
import 'my_bookings_controller.dart';

class MyBookingsScreen extends GetView<MyBookingsController> {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyBookingsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: controller.tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.6),
          indicatorColor: AppColors.accent,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: Column(
        children: [
          // PNR Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: controller.searchPnrController,
              onChanged: (val) => controller.searchPnrQuery.value = val,
              decoration: InputDecoration(
                hintText: 'Search by PNR (e.g. SB-682491)',
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.secondary),
                suffixIcon: Obx(
                  () => controller.searchPnrQuery.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            controller.searchPnrController.clear();
                            controller.searchPnrQuery.value = '';
                          },
                        )
                      : const SizedBox.shrink(),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                _buildBookingsList(controller, controller.upcomingBookings, 'upcoming'),
                _buildBookingsList(controller, controller.completedBookings, 'completed'),
                _buildBookingsList(controller, controller.cancelledBookings, 'cancelled'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(
    MyBookingsController controller,
    List<BookingEntity> bookings,
    String type,
  ) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: AppColors.secondary));
      }

      if (bookings.isEmpty) {
        return EmptyStateView(
          icon: Icons.confirmation_number_outlined,
          title: 'No $type bookings',
          description: type == 'upcoming'
              ? 'You don\'t have any upcoming trips scheduled. Ready for your next journey?'
              : 'No $type booking records found.',
          buttonText: type == 'upcoming' ? 'Book a Bus' : null,
          onButtonPressed: type == 'upcoming'
              ? () {
                  // Switch to Home Tab
                  // In MainNavController index 0
                  Get.back();
                }
              : null,
        );
      }

      return RefreshIndicator(
        onRefresh: controller.loadBookings,
        color: AppColors.secondary,
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final booking = bookings[index];
            return TweenAnimationBuilder<double>(
              key: ValueKey('booking_card_${booking.id}'),
              duration: Duration(milliseconds: 250 + (index * 60).clamp(0, 400)),
              curve: Curves.easeOutCubic,
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, val, child) {
                return Opacity(
                  opacity: val,
                  child: Transform.translate(
                    offset: Offset(0, (1 - val) * 20),
                    child: child,
                  ),
                );
              },
              child: _buildBookingCard(context, controller, booking),
            );
          },
        ),
      );
    });
  }

  Widget _buildBookingCard(
    BuildContext context,
    MyBookingsController controller,
    BookingEntity booking,
  ) {
    final trip = booking.trip;
    final bus = trip?.bus;
    final route = trip?.route;

    return AppCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      onTap: () => controller.openBookingDetails(booking),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'PNR: ${booking.pnr}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
              ),
              StatusBadge(status: booking.bookingStatus),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            bus?.operatorName ?? 'SmartBus Express',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                route?.sourceCity ?? '',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.textSecondary),
              ),
              Text(
                route?.destinationCity ?? '',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded, size: 13, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                DateFormatter.formatDbStringToDisplay(trip?.journeyDate ?? ''),
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.access_time_rounded, size: 13, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                trip?.departureTime ?? '',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Seats: ${booking.bookingSeats.map((s) => s.seatNumber).join(', ')} (${booking.totalPassengers} Pass)',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
              ),
              Text(
                CurrencyFormatter.format(booking.totalAmount),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.secondary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => controller.openBookingDetails(booking),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('View Ticket', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ),
              if (booking.canBeCancelled) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _confirmCancelDialog(context, controller, booking),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red.shade700,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Cancel Booking', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _confirmCancelDialog(
    BuildContext context,
    MyBookingsController controller,
    BookingEntity booking,
  ) {
    String selectedReason = 'Change of plans';
    final reasons = [
      'Change of plans',
      'Found alternative transportation',
      'Accidental booking',
      'Personal emergency',
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Cancel Booking', style: TextStyle(fontWeight: FontWeight.w700)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you sure you want to cancel booking PNR ${booking.pnr}?',
                    style: const TextStyle(fontSize: 13, height: 1.3),
                  ),
                  const SizedBox(height: 12),
                  const Text('Reason for cancellation:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedReason,
                        items: reasons.map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 13)))).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedReason = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Note: Your booked seats will be immediately released back to available inventory.',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Keep Booking'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    controller.cancelBooking(booking, selectedReason);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Yes, Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
