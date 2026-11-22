import 'package:get/get.dart';
import '../../domain/entities/trip.dart';
import '../../routes/app_routes.dart';

class BusDetailsController extends GetxController {
  late final TripEntity trip;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is TripEntity) {
      trip = args;
    } else {
      Get.back();
    }
  }

  void proceedToSeatSelection() {
    Get.toNamed(AppRoutes.seatSelection, arguments: trip);
  }
}
