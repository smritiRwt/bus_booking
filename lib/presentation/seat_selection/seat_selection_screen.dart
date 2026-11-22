import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/custom_button.dart';
import 'seat_selection_controller.dart';
import 'widgets/seater_seat_layout.dart';
import 'widgets/sleeper_seat_layout.dart';

class SeatSelectionScreen extends GetView<SeatSelectionController> {
  const SeatSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SeatSelectionController());
    final isSleeper = controller.trip.bus?.isSleeper ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Select Seats', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Text(
              '${controller.trip.bus?.operatorName ?? "Bus"} • Max 6 Seats',
              style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.secondary));
        }

        return Column(
          children: [
            // Status Legend
            _buildSeatLegend(),

            // Deck Selector for Sleeper Buses
            if (isSleeper) _buildDeckSelector(controller),

            // Seats Grid View
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: isSleeper
                    ? Obx(
                        () => SleeperSeatLayout(
                          seats: controller.allSeats,
                          selectedSeats: controller.selectedSeats,
                          onSeatTap: controller.toggleSeat,
                          activeDeck: controller.activeDeck.value,
                        ),
                      )
                    : Obx(
                        () => SeaterSeatLayout(
                          seats: controller.allSeats,
                          selectedSeats: controller.selectedSeats,
                          onSeatTap: controller.toggleSeat,
                        ),
                      ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: _buildBottomSummaryBar(controller),
    );
  }

  Widget _buildSeatLegend() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLegendItem('Available', AppColors.seatAvailable, AppColors.seatAvailableBorder),
          _buildLegendItem('Selected', AppColors.seatSelected, AppColors.seatSelected),
          _buildLegendItem('Booked', AppColors.seatBooked.withOpacity(0.15), AppColors.seatBooked),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color bgColor, Color borderColor) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor, width: 1.5),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildDeckSelector(SeatSelectionController controller) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => controller.activeDeck.value = 'lower',
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: controller.activeDeck.value == 'lower' ? AppColors.secondary : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Lower Deck',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: controller.activeDeck.value == 'lower' ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => controller.activeDeck.value = 'upper',
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: controller.activeDeck.value == 'upper' ? AppColors.secondary : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Upper Deck',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: controller.activeDeck.value == 'upper' ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSummaryBar(SeatSelectionController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Obx(() {
          final count = controller.selectedSeats.length;
          final total = controller.totalPrice;
          final seatNames = controller.selectedSeats.map((s) => s.seatNumber).join(', ');

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      count == 0 ? 'No seat selected' : 'Selected: $seatNames ($count seats)',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      CurrencyFormatter.format(total),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              CustomButton(
                text: 'Continue',
                width: 140,
                height: 48,
                type: count > 0 ? ButtonType.gradient : ButtonType.primary,
                backgroundColor: count > 0 ? null : Colors.grey.shade400,
                onPressed: count > 0 ? controller.proceedToPassengerDetails : null,
              ),
            ],
          );
        }),
      ),
    );
  }
}
