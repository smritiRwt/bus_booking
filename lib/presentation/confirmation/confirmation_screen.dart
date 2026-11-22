import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/status_badge.dart';
import 'confirmation_controller.dart';

class ConfirmationScreen extends GetView<ConfirmationController> {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConfirmationController());
    final booking = controller.booking;
    final trip = booking.trip;
    final bus = trip?.bus;
    final route = trip?.route;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          controller.goToHome();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Booking Confirmed'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.home_rounded),
              onPressed: controller.goToHome,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Success Animation Banner
              _buildSuccessBanner(booking),
              const SizedBox(height: 16),

              // PNR Card with Copy button & QR Code
              _buildPnrAndQrCard(controller, booking),
              const SizedBox(height: 16),

              // Trip & Journey Summary
              _buildJourneyCard(booking, trip, bus, route),
              const SizedBox(height: 16),

              // Passenger Details
              _buildPassengerListCard(booking),
              const SizedBox(height: 16),

              // PDF Action Buttons
              _buildPdfActions(controller),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessBanner(dynamic booking) {
    return Column(
      children: [
        const SizedBox(height: 8),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, size: 46, color: Colors.white),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Booking Confirmed! 🎉',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Your ticket is ready and confirmed in our local database.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildPnrAndQrCard(ConfirmationController controller, dynamic booking) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      borderRadius: 18,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PNR NUMBER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        booking.pnr,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.secondary),
                        onPressed: controller.copyPnr,
                        tooltip: 'Copy PNR',
                      ),
                    ],
                  ),
                ],
              ),
              StatusBadge(status: booking.bookingStatus),
            ],
          ),
          const Divider(height: 1),
          const SizedBox(height: 14),
          // QR Code with Booking Data
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                QrImageView(
                  data: 'SMARTBUS|${booking.pnr}|${booking.tripId}|${booking.totalAmount}',
                  version: QrVersions.auto,
                  size: 140.0,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Scan this QR code during bus boarding',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyCard(dynamic booking, dynamic trip, dynamic bus, dynamic route) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bus?.operatorName ?? 'SmartBus Express',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              Text(
                'Seats: ${booking.bookingSeats.map((s) => s.seatNumber).join(', ')}',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.secondary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(route?.sourceCity ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  Text(trip?.departureTime ?? '', style: const TextStyle(fontSize: 13, color: AppColors.secondary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Boarding: ${booking.boardingPoint}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
              Column(
                children: [
                  const Icon(Icons.arrow_forward_rounded, color: AppColors.secondary),
                  Text(
                    DateFormatter.formatDbStringToDisplay(trip?.journeyDate ?? ''),
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(route?.destinationCity ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  Text(trip?.arrivalTime ?? '', style: const TextStyle(fontSize: 13, color: AppColors.secondary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Dropping: ${booking.droppingPoint}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Amount Paid:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
              Text(
                CurrencyFormatter.format(booking.totalAmount),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerListCard(dynamic booking) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Passenger Details', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...booking.passengers.map((p) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${p.fullName} (${p.age} yrs, ${p.gender})', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  Text('Seat ${p.seatNumber}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.secondary)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPdfActions(ConfirmationController controller) {
    return Obx(
      () => Column(
        children: [
          CustomButton(
            text: 'View / Print PDF Ticket',
            icon: Icons.picture_as_pdf_rounded,
            type: ButtonType.gradient,
            isLoading: controller.isGeneratingPdf.value,
            onPressed: controller.viewAndDownloadPdf,
          ),
          const SizedBox(height: 10),
          CustomButton(
            text: 'Share Ticket PDF',
            icon: Icons.share_rounded,
            type: ButtonType.outlined,
            isLoading: controller.isGeneratingPdf.value,
            onPressed: controller.sharePdf,
          ),
          const SizedBox(height: 10),
          CustomButton(
            text: 'Back to Home',
            type: ButtonType.text,
            textColor: AppColors.textSecondary,
            onPressed: controller.goToHome,
          ),
        ],
      ),
    );
  }
}
