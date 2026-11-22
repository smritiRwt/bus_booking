import 'package:get/get.dart';
import '../data/database/app_database.dart';
import '../data/datasources/local_database_datasource.dart';
import '../data/datasources/preferences_datasource.dart';
import '../data/repositories/booking_repository_impl.dart';
import '../data/repositories/bus_repository_impl.dart';
import '../data/repositories/user_repository_impl.dart';
import '../domain/repositories/booking_repository.dart';
import '../domain/repositories/bus_repository.dart';
import '../domain/repositories/user_repository.dart';
import '../domain/usecases/cancel_booking_usecase.dart';
import '../domain/usecases/create_booking_usecase.dart';
import '../domain/usecases/generate_ticket_pdf_usecase.dart';
import '../domain/usecases/get_trip_details_usecase.dart';
import '../domain/usecases/get_user_bookings_usecase.dart';
import '../domain/usecases/search_trips_usecase.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Database & Core Data Sources
    final appDatabase = AppDatabase();
    Get.put<AppDatabase>(appDatabase, permanent: true);

    final localDataSource = LocalDatabaseDataSource(appDatabase);
    Get.put<LocalDatabaseDataSource>(localDataSource, permanent: true);

    // PreferencesDataSource will be initialized asynchronously in main.dart or put here
    if (!Get.isRegistered<PreferencesDataSource>()) {
      // Temporary fallback until async init
      // Note: main() initializes PreferencesDataSource before runApp
    }

    // 2. Repositories
    Get.lazyPut<BusRepository>(
      () => BusRepositoryImpl(Get.find<LocalDatabaseDataSource>()),
      fenix: true,
    );

    Get.lazyPut<BookingRepository>(
      () => BookingRepositoryImpl(Get.find<LocalDatabaseDataSource>()),
      fenix: true,
    );

    Get.lazyPut<UserRepository>(
      () => UserRepositoryImpl(
        Get.find<LocalDatabaseDataSource>(),
        Get.find<PreferencesDataSource>(),
      ),
      fenix: true,
    );

    // 3. Use Cases
    Get.lazyPut<SearchTripsUseCase>(
      () => SearchTripsUseCase(Get.find<BusRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetTripDetailsUseCase>(
      () => GetTripDetailsUseCase(Get.find<BusRepository>()),
      fenix: true,
    );

    Get.lazyPut<CreateBookingUseCase>(
      () => CreateBookingUseCase(Get.find<BookingRepository>()),
      fenix: true,
    );

    Get.lazyPut<CancelBookingUseCase>(
      () => CancelBookingUseCase(Get.find<BookingRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetUserBookingsUseCase>(
      () => GetUserBookingsUseCase(Get.find<BookingRepository>()),
      fenix: true,
    );

    Get.lazyPut<GenerateTicketPdfUseCase>(
      () => GenerateTicketPdfUseCase(),
      fenix: true,
    );
  }
}
