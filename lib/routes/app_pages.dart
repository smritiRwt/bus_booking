import 'package:get/get.dart';
import '../presentation/booking_summary/booking_summary_screen.dart';
import '../presentation/bus_details/bus_details_screen.dart';
import '../presentation/confirmation/confirmation_screen.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/main_nav/main_nav_screen.dart';
import '../presentation/my_bookings/booking_details_screen.dart';
import '../presentation/my_bookings/my_bookings_screen.dart';
import '../presentation/passenger_details/passenger_details_screen.dart';
import '../presentation/payment/payment_screen.dart';
import '../presentation/profile/profile_screen.dart';
import '../presentation/search/search_screen.dart';
import '../presentation/seat_selection/seat_selection_screen.dart';
import '../presentation/splash/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static const String initial = AppRoutes.splash;

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: Transition.fade,
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainNavScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.busDetails,
      page: () => const BusDetailsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.seatSelection,
      page: () => const SeatSelectionScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.passengerDetails,
      page: () => const PassengerDetailsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.bookingSummary,
      page: () => const BookingSummaryScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.payment,
      page: () => const PaymentScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.confirmation,
      page: () => const ConfirmationScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.myBookings,
      page: () => const MyBookingsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.bookingDetails,
      page: () => const BookingDetailsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
