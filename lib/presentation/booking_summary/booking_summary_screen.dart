import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/bouncing_widget.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/mystery_discount_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/ticket_card_clipper.dart';
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
        title: const Text('Booking Summary'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Perforated Boarding Overview Card
            ClipPath(
              clipper: TicketCardClipper(punchRadius: 10, notchPositionRatio: 0.65),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                bus?.operatorName ?? 'SmartBus Express',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              if (bus != null) StatusBadge(status: bus.busType, fontSize: 10),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      route?.sourceCity ?? '',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      trip.departureTime,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.secondary),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  children: [
                                    const Icon(Icons.arrow_forward_rounded, color: AppColors.secondary),
                                    Text(
                                      DateFormatter.formatDbStringToDisplay(trip.journeyDate),
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      route?.destinationCity ?? '',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      trip.arrivalTime,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.secondary),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.trip_origin_rounded, size: 13, color: AppColors.secondary),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Boarding: ${controller.boardingPoint}',
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_rounded, size: 13, color: AppColors.accent),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'Dropping: ${controller.droppingPoint}',
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Dashed perforation divider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: CustomPaint(
                        size: const Size(double.infinity, 1),
                        painter: DashedDividerPainter(),
                      ),
                    ),

                    // Bottom info strip
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Seats: ${controller.selectedSeats.map((s) => s.seatNumber).join(', ')}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary),
                          ),
                          Text(
                            '${controller.passengers.length} Passenger(s)',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Interactive Mystery Discount Unlocking Card
            MysteryDiscountCard(
              onDiscountApplied: controller.applyDiscount,
            ),
            const SizedBox(height: 16),

            // Passengers & Seats Card
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Passengers & Seats',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${controller.passengers.length} Passenger(s)',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondary),
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
                              Text(p.fullName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              Text('${p.age} yrs • ${p.gender}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Seat ${p.seatNumber}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.secondary),
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

            // Contact Info Summary
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Contact Information', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.phone_android_rounded, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(controller.contactPhone, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      const Spacer(),
                      const Icon(Icons.email_outlined, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(controller.contactEmail, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Price Breakdown Card with reactive discount
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Fare Breakdown', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  _buildPriceRow('Base Fare (${controller.selectedSeats.length} seats)', controller.baseFare),
                  const SizedBox(height: 8),
                  _buildPriceRow('Convenience Fee', controller.convenienceFee),
                  const SizedBox(height: 8),
                  _buildPriceRow('Taxes & GST (5%)', controller.gstAmount),
                  Obx(() {
                    if (controller.discount.value > 0) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '🎁 Special Coupon Discount',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF059669)),
                            ),
                            Text(
                              '-${CurrencyFormatter.format(controller.discount.value)}',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF059669)),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Payable',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                      ),
                      Obx(
                        () => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                          child: Text(
                            CurrencyFormatter.format(controller.totalAmount),
                            key: ValueKey(controller.totalAmount),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Amount', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    Obx(
                      () => Text(
                        CurrencyFormatter.format(controller.totalAmount),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              BouncingWidget(
                child: CustomButton(
                  text: 'Proceed to Pay',
                  width: 170,
                  height: 48,
                  type: ButtonType.gradient,
                  onPressed: controller.proceedToPayment,
                ),
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
