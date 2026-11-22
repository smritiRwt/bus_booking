import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/ticket_clipper.dart';
import '../../domain/entities/booking.dart';
import '../../domain/usecases/generate_ticket_pdf_usecase.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BookingEntity booking = Get.arguments as BookingEntity;
    final trip = booking.trip;
    final bus = trip?.bus;
    final route = trip?.route;
    final pdfUseCase = Get.find<GenerateTicketPdfUseCase>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Digital Boarding Pass'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () async {
              final pdfBytes = await pdfUseCase.generateTicketPdf(booking);
              await Printing.sharePdf(bytes: pdfBytes, filename: 'Ticket_${booking.pnr}.pdf');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Physical Perforated Ticket Layout
            ClipPath(
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
                    // Top Header
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
                              StatusBadge(status: booking.bookingStatus),
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
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(text: booking.pnr));
                                          Get.snackbar('Copied', 'PNR copied to clipboard', snackPosition: SnackPosition.BOTTOM);
                                        },
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

                    // Route details
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(route?.sourceCity ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                              Text(trip?.departureTime ?? '', style: const TextStyle(fontSize: 13, color: AppColors.secondary, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text('Boarding: ${booking.boardingPoint}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
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
                              Text(route?.destinationCity ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                              Text(trip?.arrivalTime ?? '', style: const TextStyle(fontSize: 13, color: AppColors.secondary, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text('Dropping: ${booking.droppingPoint}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Dashed line
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomPaint(
                        size: const Size(double.infinity, 1),
                        painter: DashedLinePainter(dashWidth: 6.0, dashSpace: 5.0),
                      ),
                    ),

                    // QR section
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
                              size: 85.0,
                              backgroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('TOTAL PAID', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary)),
                                const SizedBox(height: 2),
                                Text(
                                  CurrencyFormatter.format(booking.totalAmount),
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Booked on: ${DateFormatter.formatDbStringToDisplay(booking.bookingDate.split("T").first)}',
                                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
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
            ),
            const SizedBox(height: 16),

            // Passengers & Seats Card
            AppCard(
              padding: const EdgeInsets.all(18),
              borderRadius: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Passengers & Assigned Seats', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
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
                              borderRadius: BorderRadius.circular(6),
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

            if (booking.isCancelled && booking.cancellationReason != null) ...[
              const SizedBox(height: 16),
              AppCard(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade200),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Cancellation Info', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.error)),
                    const SizedBox(height: 6),
                    Text('Reason: ${booking.cancellationReason}', style: const TextStyle(fontSize: 13)),
                    if (booking.cancelledAt != null)
                      Text('Cancelled on: ${DateFormatter.toDisplayString(DateTime.parse(booking.cancelledAt!))}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),
            CustomButton(
              text: 'Download / Print PDF Ticket',
              icon: Icons.picture_as_pdf_rounded,
              type: ButtonType.gradient,
              onPressed: () async {
                final pdfBytes = await pdfUseCase.generateTicketPdf(booking);
                await Printing.layoutPdf(onLayout: (format) async => pdfBytes);
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
