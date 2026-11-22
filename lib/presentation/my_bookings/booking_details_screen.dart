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
import '../../domain/entities/booking.dart';
import '../../domain/usecases/generate_ticket_pdf_usecase.dart';
import 'my_bookings_controller.dart';

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
        title: const Text('Ticket Details'),
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
            // PNR Header Card with QR
            AppCard(
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
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: booking.pnr));
                                  Get.snackbar('Copied', 'PNR copied to clipboard', snackPosition: SnackPosition.BOTTOM);
                                },
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
                  QrImageView(
                    data: 'SMARTBUS|${booking.pnr}|${booking.tripId}|${booking.totalAmount}',
                    version: QrVersions.auto,
                    size: 130.0,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Booking Date: ${DateFormatter.toDisplayString(DateTime.parse(booking.bookingDate))}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Journey Info Card
            AppCard(
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
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Passengers & Seats Card
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Passengers & Assigned Seats', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  ...booking.passengers.map((p) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${p.fullName} (${p.age} yrs, ${p.gender})', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.12),
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

            // Payment & Fare Breakdown
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Payment Summary', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Base Fare:', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      Text(CurrencyFormatter.format(booking.baseFare), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Convenience Fee:', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      Text(CurrencyFormatter.format(booking.convenienceFee), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount Paid:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      Text(
                        CurrencyFormatter.format(booking.totalAmount),
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.secondary),
                      ),
                    ],
                  ),
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
                    const Text('Cancellation Info', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.error)),
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
