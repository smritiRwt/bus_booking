import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/confetti_overlay.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/ticket_clipper.dart';
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
              tooltip: 'Home',
            ),
          ],
        ),
        body: ConfettiOverlay(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Success Animated Badge & Headline
                _buildSuccessBanner(booking),
                const SizedBox(height: 18),

                // Physical Perforated Boarding Pass / Ticket Stub
                _buildPerforatedTicketStub(controller, booking, trip, bus, route),
                const SizedBox(height: 20),

                // Passenger Details Card
                _buildPassengerListCard(booking),
                const SizedBox(height: 20),

                // Action Buttons
                _buildPdfActions(controller),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessBanner(dynamic booking) {
    return Column(
      children: [
        const SizedBox(height: 6),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 900),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF059669), Color(0xFF10B981)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.4),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.check_rounded, size: 48, color: Colors.white),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Booking Confirmed! 🎉',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Your bus seats are locked in the local SQLite database.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildPerforatedTicketStub(
    ConfirmationController controller,
    dynamic booking,
    dynamic trip,
    dynamic bus,
    dynamic route,
  ) {
    return ClipPath(
      clipper: TicketClipper(punchRadius: 12.0, punchPositionFraction: 0.65),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Section: Operator & PNR Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          bus?.operatorName ?? 'SmartBus Express',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'CONFIRMED ✓',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
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
                          Text(
                            'PNR NUMBER',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.7)),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                booking.pnr,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(width: 6),
                              InkWell(
                                onTap: controller.copyPnr,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.copy_rounded, size: 14, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'ASSIGNED SEATS',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.7)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            booking.bookingSeats.map((s) => s.seatNumber).join(', '),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFFDE047),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Middle Section: Journey Details
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            route?.sourceCity ?? '',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            trip?.departureTime ?? '',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.secondary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Boarding: ${booking.boardingPoint}',
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Icon(Icons.arrow_forward_rounded, color: AppColors.secondary, size: 22),
                          Text(
                            DateFormatter.formatDbStringToDisplay(trip?.journeyDate ?? ''),
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            route?.destinationCity ?? '',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            trip?.arrivalTime ?? '',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.secondary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Dropping: ${booking.droppingPoint}',
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Perforated Dashed Tear Line
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomPaint(
                size: const Size(double.infinity, 1),
                painter: DashedLinePainter(dashWidth: 6.0, dashSpace: 5.0),
              ),
            ),

            // Bottom Section: QR Code & Total Paid
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: QrImageView(
                      data: 'SMARTBUS|${booking.pnr}|${booking.tripId}|${booking.totalAmount}',
                      version: QrVersions.auto,
                      size: 90.0,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TOTAL AMOUNT PAID',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          CurrencyFormatter.format(booking.totalAmount),
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Show this digital pass or PDF ticket during boarding.',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerListCard(dynamic booking) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      borderRadius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.people_alt_rounded, size: 18, color: AppColors.secondary),
              SizedBox(width: 8),
              Text('Passenger Manifest', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 12),
          ...booking.passengers.map((p) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${p.fullName} (${p.age} yrs, ${p.gender})', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Seat ${p.seatNumber}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.secondary)),
                  ),
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
