import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import '../../domain/entities/booking.dart';
import '../../domain/usecases/generate_ticket_pdf_usecase.dart';
import '../../routes/app_routes.dart';

class ConfirmationController extends GetxController {
  final GenerateTicketPdfUseCase generatePdfUseCase = Get.find<GenerateTicketPdfUseCase>();

  late final BookingEntity booking;
  final RxBool isGeneratingPdf = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is BookingEntity) {
      booking = args;
    } else {
      Get.offAllNamed(AppRoutes.main);
    }
  }

  void copyPnr() {
    Clipboard.setData(ClipboardData(text: booking.pnr));
    Get.snackbar(
      'Copied',
      'PNR ${booking.pnr} copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> viewAndDownloadPdf() async {
    isGeneratingPdf.value = true;
    try {
      final pdfBytes = await generatePdfUseCase.generateTicketPdf(booking);
      await Printing.layoutPdf(
        onLayout: (format) async => pdfBytes,
        name: 'SmartBus_Ticket_${booking.pnr}.pdf',
      );
    } catch (e) {
      Get.snackbar(
        'PDF Error',
        'Unable to generate PDF ticket: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isGeneratingPdf.value = false;
    }
  }

  Future<void> sharePdf() async {
    isGeneratingPdf.value = true;
    try {
      final pdfBytes = await generatePdfUseCase.generateTicketPdf(booking);
      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: 'SmartBus_Ticket_${booking.pnr}.pdf',
      );
    } catch (e) {
      Get.snackbar(
        'PDF Error',
        'Unable to share PDF ticket: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isGeneratingPdf.value = false;
    }
  }

  void goToHome() {
    Get.offAllNamed(AppRoutes.main);
  }
}
