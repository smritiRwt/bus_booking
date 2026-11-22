import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/status_badge.dart';
import 'booking_summary_controller.dart';

class BookingSummaryScreen extends GetView<BookingSummaryController> {
  const BookingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookingSummaryController());
    final trip = controller.trip;
    final bus = trip.bus;
    final route = trip.route;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Review Itinerary'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Journey & Bus Details Card
            AppCard(
              padding: const EdgeInsets.all(18),
              borderRadius: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        bus?.operatorName ?? 'SmartBus Express',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      if (bus != null) StatusBadge(status: bus.busType, fontSize: 10),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            route?.sourceCity ?? '',
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            trip.departureTime,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.secondary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Boarding: ${controller.boardingPoint}',
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Icon(Icons.arrow_forward_rounded, color: AppColors.secondary),
                          Text(
                            DateFormatter.formatDbStringToDisplay(trip.journeyDate),
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            route?.destinationCity ?? '',
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            trip.arrivalTime,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.secondary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Dropping: ${controller.droppingPoint}',
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Passengers & Seats Card
            AppCard(
              padding: const EdgeInsets.all(18),
              borderRadius: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Passengers & Assigned Seats',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        '${controller.passengers.length} Passenger(s)',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.secondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  ...controller.passengers.map((p) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.fullName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                              Text('${p.age} yrs • ${p.gender}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Seat ${p.seatNumber}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.secondary),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Interactive Promo Voucher Section
            AppCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.local_offer_rounded, size: 18, color: AppColors.secondary),
                      SizedBox(width: 8),
                      Text('Have a Promo Code?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    if (controller.appliedPromoCode.value.isNotEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF047857).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF047857).withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.check_circle_rounded, color: Color(0xFF047857), size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  '${controller.appliedPromoCode.value} (₹100 Saved)',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF047857),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textSecondary),
                              onPressed: controller.removePromo,
                              tooltip: 'Remove',
                            ),
                          ],
                        ),
                      );
                    }

                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.promoController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                              hintText: 'Enter SMARTBUS100',
                              hintStyle: const TextStyle(fontSize: 13, color: AppColors.textTertiary),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: controller.applyPromoCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Apply', style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Price Breakdown Card
            AppCard(
              padding: const EdgeInsets.all(18),
              borderRadius: 18,
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Fare Breakdown', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    _buildPriceRow('Base Fare (${controller.selectedSeats.length} seats)', controller.baseFare),
                    const SizedBox(height: 8),
                    _buildPriceRow('Convenience Fee', controller.convenienceFee),
                    const SizedBox(height: 8),
                    _buildPriceRow('Taxes & GST (5%)', controller.gstAmount),
                    if (controller.discountAmount.value > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Promo Discount', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF047857))),
                          Text('- ${CurrencyFormatter.format(controller.discountAmount.value)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF047857))),
                        ],
                      ),
                    ],
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Payable',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                        ),
                        Text(
                          CurrencyFormatter.format(controller.totalAmount),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Obx(
                  () => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Amount', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      Text(
                        CurrencyFormatter.format(controller.totalAmount),
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
              CustomButton(
                text: 'Proceed to Pay',
                width: 170,
                height: 48,
                type: ButtonType.gradient,
                onPressed: controller.proceedToPayment,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String title, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        Text(CurrencyFormatter.format(amount), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
