import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../entities/booking.dart';
import '../../core/utils/currency_formatter.dart';

class GenerateTicketPdfUseCase {
  Future<Uint8List> generateTicketPdf(BookingEntity booking) async {
    final pdf = pw.Document();

    final fontBold = await PdfGoogleFonts.poppinsSemiBold();
    final fontRegular = await PdfGoogleFonts.poppinsRegular();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          final trip = booking.trip;
          final bus = trip?.bus;
          final route = trip?.route;

          return pw.Container(
            padding: const pw.EdgeInsets.all(24),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.blueGrey800, width: 2),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header Banner
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'SmartBus',
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: 28,
                            color: PdfColors.blue900,
                          ),
                        ),
                        pw.Text(
                          'Your Smart Travel Companion',
                          style: pw.TextStyle(
                            font: fontRegular,
                            fontSize: 10,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ],
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: pw.BoxDecoration(
                        color: booking.isConfirmed ? PdfColors.green100 : PdfColors.red100,
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                        border: pw.Border.all(
                          color: booking.isConfirmed ? PdfColors.green800 : PdfColors.red800,
                        ),
                      ),
                      child: pw.Text(
                        booking.bookingStatus,
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 12,
                          color: booking.isConfirmed ? PdfColors.green900 : PdfColors.red900,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 16),
                pw.Divider(color: PdfColors.grey300),
                pw.SizedBox(height: 12),

                // PNR & Booking Reference Box
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'PNR NUMBER',
                          style: pw.TextStyle(
                            font: fontRegular,
                            fontSize: 9,
                            color: PdfColors.grey600,
                          ),
                        ),
                        pw.Text(
                          booking.pnr,
                          style: pw.TextStyle(
                            font: fontBold,
                            fontSize: 18,
                            color: PdfColors.blueGrey900,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'BOOKING DATE',
                          style: pw.TextStyle(
                            font: fontRegular,
                            fontSize: 9,
                            color: PdfColors.grey600,
                          ),
                        ),
                        pw.Text(
                          booking.bookingDate.split('T').first,
                          style: pw.TextStyle(
                            font: fontRegular,
                            fontSize: 12,
                            color: PdfColors.blueGrey900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 16),

                // Route & Journey Details Box
                pw.Container(
                  padding: const pw.EdgeInsets.all(14),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            route?.sourceCity ?? 'Origin',
                            style: pw.TextStyle(font: fontBold, fontSize: 16),
                          ),
                          pw.Text(
                            trip?.departureTime ?? '',
                            style: pw.TextStyle(font: fontRegular, fontSize: 11, color: PdfColors.grey700),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            'Boarding: ${booking.boardingPoint}',
                            style: pw.TextStyle(font: fontRegular, fontSize: 9, color: PdfColors.grey800),
                          ),
                        ],
                      ),
                      pw.Column(
                        children: [
                          pw.Text('➔', style: pw.TextStyle(font: fontBold, fontSize: 16, color: PdfColors.blue700)),
                          pw.Text(
                            trip?.journeyDate ?? '',
                            style: pw.TextStyle(font: fontBold, fontSize: 10, color: PdfColors.blueGrey700),
                          ),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            route?.destinationCity ?? 'Destination',
                            style: pw.TextStyle(font: fontBold, fontSize: 16),
                          ),
                          pw.Text(
                            trip?.arrivalTime ?? '',
                            style: pw.TextStyle(font: fontRegular, fontSize: 11, color: PdfColors.grey700),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            'Dropping: ${booking.droppingPoint}',
                            style: pw.TextStyle(font: fontRegular, fontSize: 9, color: PdfColors.grey800),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 14),

                // Bus Operator Info
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Bus Operator: ${bus?.name ?? "SmartBus"} (${bus?.busType ?? ""})',
                      style: pw.TextStyle(font: fontBold, fontSize: 11, color: PdfColors.blueGrey800),
                    ),
                    pw.Text(
                      'Seats: ${booking.bookingSeats.map((s) => s.seatNumber).join(', ')}',
                      style: pw.TextStyle(font: fontBold, fontSize: 11, color: PdfColors.blue700),
                    ),
                  ],
                ),
                pw.SizedBox(height: 16),

                // Passengers Table
                pw.Text('Passenger Details', style: pw.TextStyle(font: fontBold, fontSize: 12)),
                pw.SizedBox(height: 6),
                pw.TableHelper.fromTextArray(
                  context: context,
                  headerStyle: pw.TextStyle(font: fontBold, fontSize: 10, color: PdfColors.white),
                  headerDecoration: const pw.BoxDecoration(color: PdfColors.blue900),
                  cellStyle: pw.TextStyle(font: fontRegular, fontSize: 9),
                  cellAlignment: pw.Alignment.centerLeft,
                  headers: ['#', 'Passenger Name', 'Age', 'Gender', 'Seat Number'],
                  data: List<List<String>>.generate(
                    booking.passengers.length,
                    (index) {
                      final p = booking.passengers[index];
                      return [
                        '${index + 1}',
                        p.fullName,
                        '${p.age} yrs',
                        p.gender,
                        p.seatNumber,
                      ];
                    },
                  ),
                ),
                pw.SizedBox(height: 16),

                // Primary Contact & Fare Breakdown
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Primary Contact', style: pw.TextStyle(font: fontBold, fontSize: 11)),
                          pw.SizedBox(height: 4),
                          pw.Text('Mobile: ${booking.contactPhone}', style: pw.TextStyle(font: fontRegular, fontSize: 9)),
                          pw.Text('Email: ${booking.contactEmail}', style: pw.TextStyle(font: fontRegular, fontSize: 9)),
                          pw.SizedBox(height: 12),
                          // QR Code representation
                          pw.Container(
                            width: 80,
                            height: 80,
                            child: pw.BarcodeWidget(
                              data: 'SMARTBUS|${booking.pnr}|${booking.tripId}|${booking.totalAmount}',
                              barcode: pw.Barcode.qrCode(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(10),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.grey300),
                          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Payment Details', style: pw.TextStyle(font: fontBold, fontSize: 10)),
                            pw.Divider(color: PdfColors.grey200),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text('Base Fare:', style: pw.TextStyle(font: fontRegular, fontSize: 8)),
                                pw.Text(CurrencyFormatter.format(booking.baseFare), style: pw.TextStyle(font: fontRegular, fontSize: 8)),
                              ],
                            ),
                            pw.SizedBox(height: 3),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text('Convenience Fee:', style: pw.TextStyle(font: fontRegular, fontSize: 8)),
                                pw.Text(CurrencyFormatter.format(booking.convenienceFee), style: pw.TextStyle(font: fontRegular, fontSize: 8)),
                              ],
                            ),
                            pw.Divider(color: PdfColors.grey300),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text('Total Paid:', style: pw.TextStyle(font: fontBold, fontSize: 10)),
                                pw.Text(
                                  CurrencyFormatter.format(booking.totalAmount),
                                  style: pw.TextStyle(font: fontBold, fontSize: 10, color: PdfColors.blue800),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                pw.Spacer(),
                pw.Divider(color: PdfColors.grey300),
                pw.SizedBox(height: 6),
                pw.Text(
                  'Important: Please present this e-ticket along with a valid government ID during boarding. Reporting time is 15 minutes prior to departure.',
                  style: pw.TextStyle(font: fontRegular, fontSize: 8, color: PdfColors.grey600),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }
}
