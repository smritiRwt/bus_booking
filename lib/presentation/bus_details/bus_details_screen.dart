import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/status_badge.dart';
import 'bus_details_controller.dart';

class BusDetailsScreen extends GetView<BusDetailsController> {
  const BusDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BusDetailsController());
    final trip = controller.trip;
    final bus = trip.bus;
    final route = trip.route;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bus Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Operator & Bus Info Card
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          bus?.operatorName ?? 'SmartBus Operator',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (bus != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                bus.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bus?.name ?? '',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (bus != null) StatusBadge(status: bus.busType),
                      const SizedBox(width: 8),
                      Text(
                        '${trip.availableSeatsCount} seats available',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Route & Timings Card
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Journey Details',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        DateFormatter.formatDbStringToDisplay(trip.journeyDate),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.departureTime,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            route?.sourceCity ?? '',
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            route?.estimatedDuration ?? '~5h',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Container(width: 80, height: 2, color: AppColors.secondary.withValues(alpha: 0.5)),
                          const SizedBox(height: 4),
                          Text(
                            '${route?.distanceKm.toInt() ?? 250} km',
                            style: const TextStyle(fontSize: 10, color: AppColors.textTertiary),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            trip.arrivalTime,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            route?.destinationCity ?? '',
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Amenities Card
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Amenities Included',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  if (bus != null && bus.amenities.isNotEmpty)
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: bus.amenities.map((amenity) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_getAmenityIcon(amenity), size: 16, color: AppColors.secondary),
                              const SizedBox(width: 8),
                              Text(
                                amenity,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                  else
                    const Text('Standard bus amenities included', style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Boarding & Dropping Points Card
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Boarding & Dropping Locations',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  const Text('Boarding Points:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.secondary)),
                  const SizedBox(height: 8),
                  ...trip.boardingPoints.map((bp) => _buildLocationTile(bp.pointName, bp.time, bp.landmark, true)),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  const Text('Dropping Points:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.accent)),
                  const SizedBox(height: 8),
                  ...trip.droppingPoints.map((dp) => _buildLocationTile(dp.pointName, dp.time, dp.landmark, false)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Cancellation Policy Card
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.policy_rounded, size: 18, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text('Cancellation Policy', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    bus?.cancellationPolicy ??
                        'Full refund if cancelled 24 hours prior to departure. 50% refund between 12-24 hours. No refund within 12 hours.',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Starting from',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  Text(
                    CurrencyFormatter.format(trip.basePrice),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              CustomButton(
                text: 'Select Seats',
                icon: Icons.airline_seat_recline_normal_rounded,
                width: 170,
                height: 48,
                type: ButtonType.gradient,
                onPressed: controller.proceedToSeatSelection,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationTile(String point, String time, String landmark, bool isBoarding) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isBoarding ? Icons.trip_origin_rounded : Icons.location_on_rounded,
            size: 16,
            color: isBoarding ? AppColors.secondary : AppColors.accent,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(point, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                if (landmark.isNotEmpty)
                  Text(landmark, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  IconData _getAmenityIcon(String amenity) {
    final lower = amenity.toLowerCase();
    if (lower.contains('wifi')) return Icons.wifi_rounded;
    if (lower.contains('charging') || lower.contains('power')) return Icons.power_rounded;
    if (lower.contains('water')) return Icons.water_drop_rounded;
    if (lower.contains('blanket') || lower.contains('pillow')) return Icons.hotel_rounded;
    if (lower.contains('snack')) return Icons.fastfood_rounded;
    if (lower.contains('tracking') || lower.contains('gps')) return Icons.gps_fixed_rounded;
    if (lower.contains('cctv')) return Icons.videocam_rounded;
    if (lower.contains('reading')) return Icons.lightbulb_rounded;
    return Icons.check_circle_outline_rounded;
  }
}
