# 🚌 SmartBus – Flutter Bus Booking Application

[![Flutter](https://img.shields.io/badge/Flutter-3.47.7-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13.5-0175C2.svg)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-MVVM%20%2B%20Clean%20Architecture-teal.svg)](#architecture)
[![Database](https://img.shields.io/badge/Database-SQLite%20(sqflite)-green.svg)](https://pub.dev/packages/sqflite)
[![State Management](https://img.shields.io/badge/State-GetX-purple.svg)](https://pub.dev/packages/get)
[![UI](https://img.shields.io/badge/UI-Material%203-orange.svg)](#uiux-design)

**SmartBus** is a complete, production-grade Bus Booking Application built with **Flutter and Dart**. Designed as a portfolio project showcasing professional Flutter mobile engineering skills, it features a modern Material 3 travel interface, Clean Architecture with MVVM, local SQLite relational database with strict ACID transactions, interactive seat selection, demo payment simulation, QR code verification, and high-resolution PDF e-ticket generation.

> **100% Offline & Local**: No external backend or Firebase required. All search algorithms, dynamic pricing, seat inventories, payment simulation, and booking cancellations execute directly against a pre-seeded local SQLite database.

---

## 📱 App Screenshots

| Home Dashboard | Mystery Deal Revealed | Bus Search & Filters |
|:---:|:---:|:---:|
| <img src="screenshots/home_screen.png" width="260" alt="Home Screen" /> | <img src="screenshots/revealed_voucher.png" width="260" alt="Mystery Deal" /> | <img src="screenshots/search_screen.png" width="260" alt="Search Screen" /> |

| Sleeper Deck Selection | Interactive Selected State | 2x2 Seater Bus Layout |
|:---:|:---:|:---:|
| <img src="screenshots/seat_selection_screen.png" width="260" alt="Sleeper Layout" /> | <img src="screenshots/seat_selected.png" width="260" alt="Seat Selected" /> | <img src="screenshots/seat_selection_screen_2.png" width="260" alt="Seater Layout" /> |

---

## 🌟 Key Features

### 1. 🚀 Splash & Onboarding
- Smooth entrance animation with custom SmartBus branding.
- Automatic SQLite database warm-up and seeding on first launch.

### 2. 🏠 Modern Travel Dashboard (Home Screen)
- **Interactive Live Highway Bus (`AnimatedBusRoad`)**: Moving road lines, drifting daylight clouds, suspension hover, and **Tap-to-Honk** (*"Beep Beep! 📢"*).
- **Gamified Mystery Discount Card (`MysteryDiscountCard`)**: Tap-to-unlock welcome travel voucher that auto-applies ₹150 discount to the total fare.
- **City Selectors**: Popular Indian city routes (Delhi, Chandigarh, Jaipur, Amritsar, Ludhiana, Manali, Shimla, Dehradun, Jalandhar).
- **Source-Destination Swap**: 180° smooth spring rotate-and-swap animation for instant return route lookup.
- **Date Picker**: Quick chips for **Today** and **Tomorrow** plus an interactive Material calendar.
- **Upcoming Boarding Pass**: Perforated physical pass preview with circular hole notches and dashed tear-off perforation line.
- **Popular Destinations & Routes**: One-click quick-booking shortcuts.

### 3. 🔍 Bus Search & Dynamic Filtering
- Local SQL multi-table join (`trips` ⇄ `buses` ⇄ `routes`).
- Real-time departure, arrival, duration, seat availability, and operator ratings.
- **Comprehensive Filters**:
  - Bus category: AC vs Non-AC.
  - Layout format: Sleeper vs Seater.
  - Sorting: Price (Low/High), Rating (Highest First), Earliest Departure.
  - Departure window: Morning, Afternoon, Evening, Night.
- **Interactive Bus Cards**: Smooth accordion drawer displaying boarding/dropping stops and amenities right inside each card.
- Quick date switch bar to explore adjacent travel days.

### 4. 💺 Interactive Visual Seat Layout
- **3D Animated Driver Cabin (`AnimatedDriverCabin`)**: Interactive spinning steering wheel with horn toot.
- **Sleeper Buses (2+1)**: Dedicated tabbed decks (**Lower Deck** & **Upper Deck**) with single window berths and double aisle berths.
- **Seater Buses (2+2)**: 9 rows with central illuminated walking aisle and seat markers.
- **3 Color States**:
  - ⬜ **Available**: Pure white with soft slate border and price tag.
  - 🟦 **Selected**: Electric Royal Blue with active 2.4px border and white checkmark badge.
  - 🟥 **Booked**: Soft pastel rose with disabled lock icon.
- **Tactile Physics Bounce**: Seats spring down on tap with micro-bounce haptics.
- **Dynamic Pricing**: Updates total fare in real time as seats are selected.
- **Constraint Enforcement**: Prevents double-booking and limits bookings to a max of 6 seats per transaction.

### 5. 👥 Passenger & Contact Information
- Per-seat dynamic passenger forms (Full Name, Age, Gender selection).
- Primary contact validation (strict 10-digit Indian mobile validation and RFC email regex).
- Boarding & Dropping point selector with scheduled times and landmark addresses.

### 6. 💳 Demo Payment Gateway (Simulation)
- Authentically styled payment gateway clearly labeled for demo/evaluation.
- Methods: **UPI (GPay/PhonePe/Paytm)**, **Credit/Debit Card**, and **Cash on Boarding**.
- **Interactive Outcome Toggle**: Switch between **Simulate Success** and **Simulate Failure** to test rollback behavior.
- Only successful payments commit bookings and reserve seats; failed payments abort without holding inventory.

### 7. 🎟️ Booking Confirmation, QR Code & PDF Tickets
- Animated confirmation banner with unique PNR generation (`SB-XXXXXX`).
- **Celebration Confetti Burst (`ConfettiCelebration`)**: Physics-based multi-colored confetti particles on booking success.
- Embedded **QR Code** (`qr_flutter`) containing the cryptographic trip booking reference.
- **Printable PDF Ticket Generation** (`pdf` & `printing`):
  - High-res vector layout with operator branding.
  - Passenger breakdown table, scheduled boarding/dropping addresses, and fare summary.
  - Built-in sharing and native printing preview.

### 8. 📋 My Bookings & Smart Cancellation
- 3 distinct tabs: **Upcoming**, **Completed**, and **Cancelled**.
- Real-time search by PNR.
- **Eligible Cancellation Flow**:
  - Updates booking status to `CANCELLED` in an ACID database transaction.
  - Automatically releases seats back to inventory (`is_booked = 0`).
  - Restores trip seat availability counter.
  - Records cancellation timestamp and user reason.

### 9. 👤 User Profile & Settings
- Editable profile (Name, Mobile, Email) persisted across app launches.
- Travel stats dashboard (Total trips, Upcoming, Completed, Cancelled).
- About SmartBus dialog detailing technical highlights.

---

## 🏗️ Architecture & Project Structure

The project strictly follows **Clean Architecture** combined with **MVVM** and **GetX**:

```
lib/
├── core/
│   ├── constants/        # AppColors, AppConstants, AppStrings
│   ├── theme/            # Material 3 ThemeData, CardThemeData, TabBarThemeData
│   ├── utils/            # CurrencyFormatter, DateFormatter, PnrGenerator, Validators
│   └── widgets/          # CustomButton, BouncingWidget, AnimatedBusRoad, MysteryDiscountCard, TicketCardClipper, ConfettiCelebration
├── data/
│   ├── database/         # AppDatabase, DatabaseTables (DDL), SampleData (Seed)
│   ├── datasources/      # LocalDatabaseDataSource (SQL queries & txns), PreferencesDataSource
│   ├── models/           # Data transfer models (Bus, Trip, Seat, Booking, Passenger, Payment)
│   └── repositories/     # Repository implementations (BusRepositoryImpl, BookingRepositoryImpl, etc.)
├── domain/
│   ├── entities/         # Pure Dart business models (Bus, Trip, Seat, Booking, Passenger)
│   ├── repositories/     # Abstract repository contracts
│   └── usecases/         # SearchTripsUseCase, CreateBookingUseCase, CancelBookingUseCase, etc.
├── presentation/
│   ├── splash/           # Splash animation & DB warm-up
│   ├── main_nav/         # Bottom navigation container
│   ├── home/             # Travel search dashboard & popular destinations
│   ├── search/           # Filterable bus list & sorting bottom sheet
│   ├── bus_details/      # Bus specs, boarding points, cancellation policy
│   ├── seat_selection/   # Interactive 2+1 sleeper & 2+2 seater visual grid
│   ├── passenger_details/# Per-seat passenger inputs & contact validation
│   ├── booking_summary/  # Fare breakdown, GST taxes, trip itinerary
│   ├── payment/          # Demo payment gateway simulation (UPI/Card/Cash)
│   ├── confirmation/     # Success screen, QR code, PDF e-ticket export
│   ├── my_bookings/      # Upcoming, completed, cancelled tabs & cancellation workflow
│   └── profile/          # User info, booking stats, app info
├── routes/               # AppRoutes & AppPages with GetPage bindings
├── bindings/             # InitialBinding for GetX dependency injection
└── main.dart             # App entrypoint
```

---

## 🗄️ SQLite Database Schema

The database consists of 9 normalized tables with foreign keys and indexes:

```sql
users (id, name, email, phone, created_at)
buses (id, name, operator_name, bus_type, total_seats, rating, amenities, cancellation_policy)
routes (id, source_city, destination_city, distance_km, estimated_duration)
trips (id, bus_id, route_id, journey_date, departure_time, arrival_time, base_price, boarding_points, dropping_points, available_seats_count)
seats (id, trip_id, seat_number, seat_type, deck, row_index, column_index, price, is_booked)
passengers (id, booking_id, full_name, age, gender, seat_number)
bookings (id, pnr, trip_id, user_id, contact_email, contact_phone, total_passengers, base_fare, convenience_fee, total_amount, booking_status, booking_date, boarding_point, dropping_point, cancellation_reason, cancelled_at)
booking_seats (id, booking_id, seat_id, seat_number, seat_price)
payments (id, booking_id, transaction_id, payment_method, amount, payment_status, payment_date)
```

### 🔒 ACID Transaction Guarantees
- **Booking Creation**: Validates seat availability inside `db.transaction(...)`. If any seat has already been reserved, the transaction throws an exception and rolls back cleanly.
- **Seat Release on Cancellation**: When a booking is cancelled, the transaction marks the booking `CANCELLED`, clears `is_booked = 0` on all linked seats, and restores the trip's available count.

---

## 🧪 Testing

The application includes unit tests, database transaction tests with SQLite in-memory FFI, and UI widget tests:

```bash
flutter test
```

### Test Coverage Highlights:
- ✅ **Validation Rules**: Tests name, age boundaries, 10-digit phone patterns, and email formats.
- ✅ **Formatters**: Currency formatting (`₹`), date parsing, PNR format (`SB-XXXXXX`).
- ✅ **Component Widgets**: Button interactions, status badge variants, tap states.
- ✅ **SQLite Seeding**: Verifies 12 buses, 10 routes, and daily scheduled trips.
- ✅ **Transaction Flow**: Verifies seat booking, availability decrement, and duplicate booking rejection.
- ✅ **Cancellation & Rollback**: Verifies seat release and inventory restoration upon cancellation.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (v3.13.0 or higher)
- Dart SDK (v3.0.0 or higher)

### Installation

1. **Clone repository**:
   ```bash
   git clone https://github.com/your-username/smartbus-flutter.git
   cd smartbus-flutter
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run on connected device / emulator**:
   ```bash
   flutter run
   ```

---

## 🎨 UI/UX Design System

- **Theme Mode**: Crisp, modern Light Palette.
- **Primary**: Modern Royal Navy & Blue (`#1E3A8A`, `#2563EB`)
- **Secondary**: Vibrant Sky Blue & Azure (`#0284C7`, `#38BDF8`)
- **Accent**: Sunset Coral & Orange (`#FF6B35`)
- **Surface & Background**: Pure White (`#FFFFFF`) and Light Slate (`#F8FAFC`)
- **Typography**: Clean hierarchy with bold headers and high-contrast labels.
- **Material 3**: Fully compliant with Material 3 cards, navigation bars, and dialogs.
