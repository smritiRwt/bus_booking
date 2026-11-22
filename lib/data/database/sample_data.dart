import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/pnr_generator.dart';
import 'database_tables.dart';

class SampleData {
  static Future<void> seedDatabase(Database db) async {
    // 1. Seed Default User
    final userId = await db.insert(DatabaseTables.tableUsers, {
      'name': 'Smriti Rawat',
      'email': 'smriti.rawat@example.com',
      'phone': '9876543210',
      'created_at': DateTime.now().toIso8601String(),
    });

    // 2. Seed Buses (12 Buses)
    final busesData = [
      {
        'id': 1,
        'name': 'Zingbus Maxx AC Sleeper',
        'operator_name': 'Zingbus Electric & Multi-Axle',
        'bus_type': 'AC Sleeper',
        'total_seats': 30,
        'rating': 4.8,
        'amenities': jsonEncode([
          'Wi-Fi',
          'Charging Point',
          'Water Bottle',
          'Blanket',
          'Reading Light',
          'Live Tracking',
        ]),
        'cancellation_policy':
            '100% refund up to 24 hrs before departure. 50% between 12-24 hrs. No refund within 12 hrs.',
      },
      {
        'id': 2,
        'name': 'IntrCity SmartBus HighDeck',
        'operator_name': 'IntrCity SmartBus Mobility',
        'bus_type': 'AC Seater',
        'total_seats': 36,
        'rating': 4.7,
        'amenities': jsonEncode([
          'Wi-Fi',
          'Charging Point',
          'Water Bottle',
          'Emergency Exit',
          'Air Conditioning',
        ]),
        'cancellation_policy':
            '100% refund up to 24 hrs before departure. 50% between 12-24 hrs. No refund within 12 hrs.',
      },
      {
        'id': 3,
        'name': 'Northern Volvo 9600 Multi-Axle',
        'operator_name': 'Northern Travels Luxury',
        'bus_type': 'AC Sleeper',
        'total_seats': 30,
        'rating': 4.9,
        'amenities': jsonEncode([
          'High-Speed Wi-Fi',
          'Charging Point',
          'Pillow & Blanket',
          'Snacks & Water',
          'GPS Live Tracking',
          'CCTV',
        ]),
        'cancellation_policy':
            '100% refund up to 24 hrs before departure. 60% between 12-24 hrs. No refund within 12 hrs.',
      },
      {
        'id': 4,
        'name': 'City Land Express Sleeper',
        'operator_name': 'City Land Travels',
        'bus_type': 'Non-AC Sleeper',
        'total_seats': 30,
        'rating': 4.2,
        'amenities': jsonEncode([
          'Charging Point',
          'Emergency Exit',
          'Reading Light',
        ]),
        'cancellation_policy':
            '100% refund up to 24 hrs before departure. 40% between 12-24 hrs.',
      },
      {
        'id': 5,
        'name': 'Royal Safari Premium Gold',
        'operator_name': 'Royal Safari India',
        'bus_type': 'AC Sleeper',
        'total_seats': 30,
        'rating': 4.6,
        'amenities': jsonEncode([
          'Wi-Fi',
          'Charging Point',
          'Water Bottle',
          'Blanket',
          'Air Freshener',
        ]),
        'cancellation_policy':
            '100% refund up to 24 hrs before departure. 50% between 12-24 hrs.',
      },
      {
        'id': 6,
        'name': 'Himachal Goldline Volvo',
        'operator_name': 'Himachal Roadways Goldline',
        'bus_type': 'AC Seater',
        'total_seats': 36,
        'rating': 4.5,
        'amenities': jsonEncode([
          'Air Conditioning',
          'Pushback Seats',
          'Water Bottle',
          'Music System',
        ]),
        'cancellation_policy':
            '100% refund up to 24 hrs before departure. 50% between 12-24 hrs.',
      },
      {
        'id': 7,
        'name': 'RSRTC Express Deluxe',
        'operator_name': 'Rajasthan State Express',
        'bus_type': 'Non-AC Seater',
        'total_seats': 36,
        'rating': 4.0,
        'amenities': jsonEncode([
          'First Aid Kit',
          'Emergency Exit',
          'Comfortable Pushback',
        ]),
        'cancellation_policy':
            '80% refund up to 12 hrs before departure.',
      },
      {
        'id': 8,
        'name': 'Laxmi Holidays Star Class',
        'operator_name': 'Laxmi Holidays Pvt Ltd',
        'bus_type': 'AC Sleeper',
        'total_seats': 30,
        'rating': 4.8,
        'amenities': jsonEncode([
          'Wi-Fi',
          'Charging Point',
          'Water Bottle',
          'Blanket',
          'Snacks',
          'Personal LCD Screen',
        ]),
        'cancellation_policy':
            '100% refund up to 24 hrs before departure. 50% between 12-24 hrs.',
      },
      {
        'id': 9,
        'name': 'New Himalayan Royal Class',
        'operator_name': 'New Himalayan Travels',
        'bus_type': 'AC Seater',
        'total_seats': 36,
        'rating': 4.3,
        'amenities': jsonEncode([
          'Air Conditioning',
          'Charging Point',
          'Water Bottle',
        ]),
        'cancellation_policy':
            '100% refund up to 24 hrs before departure. 50% between 12-24 hrs.',
      },
      {
        'id': 10,
        'name': 'Moon Light Night Rider',
        'operator_name': 'Moon Light Travels',
        'bus_type': 'AC Sleeper',
        'total_seats': 30,
        'rating': 4.6,
        'amenities': jsonEncode([
          'Wi-Fi',
          'Charging Point',
          'Water Bottle',
          'Blanket',
          'Night Dim Lights',
        ]),
        'cancellation_policy':
            '100% refund up to 24 hrs before departure. 50% between 12-24 hrs.',
      },
      {
        'id': 11,
        'name': 'Punjab Roadways AC Deluxe',
        'operator_name': 'Punjab State Transport',
        'bus_type': 'Non-AC Seater',
        'total_seats': 36,
        'rating': 4.1,
        'amenities': jsonEncode([
          'Curtains',
          'First Aid Box',
          'Emergency Window',
        ]),
        'cancellation_policy':
            '80% refund up to 12 hrs before departure.',
      },
      {
        'id': 12,
        'name': 'Blue World Tourism Comfort',
        'operator_name': 'Blue World Tourism',
        'bus_type': 'AC Sleeper',
        'total_seats': 30,
        'rating': 4.7,
        'amenities': jsonEncode([
          'Wi-Fi',
          'Charging Point',
          'Water Bottle',
          'Blanket',
          'Snacks',
        ]),
        'cancellation_policy':
            '100% refund up to 24 hrs before departure. 50% between 12-24 hrs.',
      },
    ];

    for (final bus in busesData) {
      await db.insert(DatabaseTables.tableBuses, bus);
    }

    // 3. Seed Routes (10 Routes)
    final routesData = [
      {
        'id': 1,
        'source_city': 'Delhi',
        'destination_city': 'Chandigarh',
        'distance_km': 245.0,
        'estimated_duration': '4h 30m',
      },
      {
        'id': 2,
        'source_city': 'Chandigarh',
        'destination_city': 'Delhi',
        'distance_km': 245.0,
        'estimated_duration': '4h 30m',
      },
      {
        'id': 3,
        'source_city': 'Delhi',
        'destination_city': 'Jaipur',
        'distance_km': 280.0,
        'estimated_duration': '5h 15m',
      },
      {
        'id': 4,
        'source_city': 'Jaipur',
        'destination_city': 'Delhi',
        'distance_km': 280.0,
        'estimated_duration': '5h 15m',
      },
      {
        'id': 5,
        'source_city': 'Delhi',
        'destination_city': 'Manali',
        'distance_km': 535.0,
        'estimated_duration': '11h 30m',
      },
      {
        'id': 6,
        'source_city': 'Chandigarh',
        'destination_city': 'Amritsar',
        'distance_km': 230.0,
        'estimated_duration': '4h 15m',
      },
      {
        'id': 7,
        'source_city': 'Delhi',
        'destination_city': 'Dehradun',
        'distance_km': 255.0,
        'estimated_duration': '5h 00m',
      },
      {
        'id': 8,
        'source_city': 'Chandigarh',
        'destination_city': 'Shimla',
        'distance_km': 115.0,
        'estimated_duration': '3h 30m',
      },
      {
        'id': 9,
        'source_city': 'Ludhiana',
        'destination_city': 'Delhi',
        'distance_km': 310.0,
        'estimated_duration': '5h 45m',
      },
      {
        'id': 10,
        'source_city': 'Jalandhar',
        'destination_city': 'Delhi',
        'distance_km': 375.0,
        'estimated_duration': '6h 30m',
      },
    ];

    for (final route in routesData) {
      await db.insert(DatabaseTables.tableRoutes, route);
    }

    // 4. Seed Boarding & Dropping Points per city
    final cityBoardingPoints = {
      'Delhi': [
        {'pointName': 'Kashmere Gate ISBT', 'time': '00:00', 'landmark': 'Gate No. 2, Metro Station'},
        {'pointName': 'Majnu Ka Tilla', 'time': '00:30', 'landmark': 'Near Gurudwara, Ring Road'},
        {'pointName': 'Dhaula Kuan', 'time': '00:50', 'landmark': 'Metro Station Footover Bridge'},
        {'pointName': 'Anand Vihar ISBT', 'time': '01:15', 'landmark': 'Pillar No. 42'},
      ],
      'Chandigarh': [
        {'pointName': 'Sector 43 ISBT', 'time': '00:00', 'landmark': 'Platform 8, Sector 43'},
        {'pointName': 'Sector 17 Bus Stand', 'time': '00:25', 'landmark': 'Near Fire Station'},
        {'pointName': 'Tribune Chowk', 'time': '00:45', 'landmark': 'Tribune Flyover Roundabout'},
        {'pointName': 'Zirakpur Flyover', 'time': '01:00', 'landmark': 'Below Zirakpur Flyover'},
      ],
      'Jaipur': [
        {'pointName': 'Sindhi Camp Bus Stand', 'time': '00:00', 'landmark': 'Platform 3, Station Road'},
        {'pointName': 'Narayan Singh Circle', 'time': '00:20', 'landmark': 'Near City Palace Gate'},
        {'pointName': '200 Feet Bypass', 'time': '00:45', 'landmark': 'Ajmer Road Crossing'},
      ],
      'Manali': [
        {'pointName': 'Private Bus Stand Manali', 'time': '00:00', 'landmark': 'Near The Mall Road'},
        {'pointName': 'Patlikuhal Bridge', 'time': '00:30', 'landmark': 'National Highway 3'},
      ],
      'Amritsar': [
        {'pointName': 'Amritsar ISBT', 'time': '00:00', 'landmark': 'City Bus Stand Terminal'},
        {'pointName': 'Hall Gate', 'time': '00:20', 'landmark': 'Near Golden Temple Way'},
      ],
      'Dehradun': [
        {'pointName': 'ISBT Dehradun', 'time': '00:00', 'landmark': 'Haridwar Bypass Road'},
        {'pointName': 'Clock Tower', 'time': '00:25', 'landmark': 'Rajpur Road Junction'},
      ],
      'Shimla': [
        {'pointName': 'ISBT Tutikandi', 'time': '00:00', 'landmark': 'New Bus Stand Shimla'},
        {'pointName': 'Victory Tunnel', 'time': '00:20', 'landmark': 'Circular Road'},
      ],
      'Ludhiana': [
        {'pointName': 'Ludhiana Bus Stand', 'time': '00:00', 'landmark': 'GT Road Counter 5'},
        {'pointName': 'Sherpur Chowk', 'time': '00:25', 'landmark': 'Near Flyover'},
      ],
      'Jalandhar': [
        {'pointName': 'Jalandhar Bus Stand', 'time': '00:00', 'landmark': 'Main Terminal Gate 1'},
        {'pointName': 'PAP Chowk', 'time': '00:25', 'landmark': 'National Highway 44'},
      ],
    };

    // Helper to generate boarding/dropping points with calculated relative times
    List<Map<String, dynamic>> getPoints(String city, String baseTimeStr, bool isBoarding) {
      final points = cityBoardingPoints[city] ?? [
        {'pointName': '$city Central Bus Stand', 'time': baseTimeStr, 'landmark': 'Main City Terminal'},
      ];
      return points.map((p) {
        return {
          'pointName': p['pointName'],
          'time': baseTimeStr,
          'landmark': p['landmark'],
        };
      }).toList();
    }

    // 5. Seed Trips for Today, Tomorrow, and Next 14 Days
    final now = DateTime.now();
    int tripIdCounter = 1;

    // Define trip schedules per route
    final tripTemplates = [
      // Delhi -> Chandigarh (Route 1)
      {'busId': 1, 'routeId': 1, 'dep': '06:30 AM', 'arr': '11:00 AM', 'price': 799.0},
      {'busId': 2, 'routeId': 1, 'dep': '09:00 AM', 'arr': '01:30 PM', 'price': 549.0},
      {'busId': 3, 'routeId': 1, 'dep': '02:00 PM', 'arr': '06:30 PM', 'price': 899.0},
      {'busId': 8, 'routeId': 1, 'dep': '07:30 PM', 'arr': '12:00 AM', 'price': 849.0},
      {'busId': 10, 'routeId': 1, 'dep': '11:00 PM', 'arr': '03:30 AM', 'price': 749.0},

      // Chandigarh -> Delhi (Route 2)
      {'busId': 1, 'routeId': 2, 'dep': '07:00 AM', 'arr': '11:30 AM', 'price': 799.0},
      {'busId': 2, 'routeId': 2, 'dep': '01:30 PM', 'arr': '06:00 PM', 'price': 549.0},
      {'busId': 3, 'routeId': 2, 'dep': '08:00 PM', 'arr': '12:30 AM', 'price': 899.0},

      // Delhi -> Jaipur (Route 3)
      {'busId': 5, 'routeId': 3, 'dep': '06:00 AM', 'arr': '11:15 AM', 'price': 699.0},
      {'busId': 2, 'routeId': 3, 'dep': '10:30 AM', 'arr': '03:45 PM', 'price': 520.0},
      {'busId': 7, 'routeId': 3, 'dep': '02:00 PM', 'arr': '07:15 PM', 'price': 380.0},
      {'busId': 12, 'routeId': 3, 'dep': '10:45 PM', 'arr': '04:00 AM', 'price': 799.0},

      // Jaipur -> Delhi (Route 4)
      {'busId': 5, 'routeId': 4, 'dep': '07:00 AM', 'arr': '12:15 PM', 'price': 699.0},
      {'busId': 12, 'routeId': 4, 'dep': '11:00 PM', 'arr': '04:15 AM', 'price': 799.0},

      // Delhi -> Manali (Route 5)
      {'busId': 3, 'routeId': 5, 'dep': '05:30 PM', 'arr': '05:00 AM', 'price': 1499.0},
      {'busId': 8, 'routeId': 5, 'dep': '07:00 PM', 'arr': '06:30 AM', 'price': 1399.0},
      {'busId': 4, 'routeId': 5, 'dep': '08:30 PM', 'arr': '08:00 AM', 'price': 999.0},

      // Chandigarh -> Amritsar (Route 6)
      {'busId': 6, 'routeId': 6, 'dep': '06:15 AM', 'arr': '10:30 AM', 'price': 450.0},
      {'busId': 11, 'routeId': 6, 'dep': '01:00 PM', 'arr': '05:15 PM', 'price': 320.0},
      {'busId': 2, 'routeId': 6, 'dep': '05:45 PM', 'arr': '10:00 PM', 'price': 490.0},

      // Delhi -> Dehradun (Route 7)
      {'busId': 9, 'routeId': 7, 'dep': '07:00 AM', 'arr': '12:00 PM', 'price': 550.0},
      {'busId': 1, 'routeId': 7, 'dep': '11:15 PM', 'arr': '04:15 AM', 'price': 850.0},

      // Chandigarh -> Shimla (Route 8)
      {'busId': 6, 'routeId': 8, 'dep': '07:30 AM', 'arr': '11:00 AM', 'price': 390.0},
      {'busId': 9, 'routeId': 8, 'dep': '02:00 PM', 'arr': '05:30 PM', 'price': 420.0},

      // Ludhiana -> Delhi (Route 9)
      {'busId': 1, 'routeId': 9, 'dep': '05:00 AM', 'arr': '10:45 AM', 'price': 820.0},
      {'busId': 11, 'routeId': 9, 'dep': '02:30 PM', 'arr': '08:15 PM', 'price': 490.0},

      // Jalandhar -> Delhi (Route 10)
      {'busId': 3, 'routeId': 10, 'dep': '09:00 PM', 'arr': '03:30 AM', 'price': 950.0},
    ];

    // Seed for today (-1 to 14 days)
    // Days: -5 (for past completed trip), 0 (today), 1 (tomorrow), up to 10
    final daysToGenerate = [-5, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    int? sampleUpcomingTripId;
    int? samplePastTripId;

    for (final dayOffset in daysToGenerate) {
      final tripDate = now.add(Duration(days: dayOffset));
      final dateString = DateFormatter.toDbString(tripDate);

      for (final tmpl in tripTemplates) {
        final currentTripId = tripIdCounter++;
        final busId = tmpl['busId'] as int;
        final routeId = tmpl['routeId'] as int;
        final depTime = tmpl['dep'] as String;
        final arrTime = tmpl['arr'] as String;
        final basePrice = tmpl['price'] as double;

        final route = routesData.firstWhere((r) => r['id'] == routeId);
        final sourceCity = route['source_city'] as String;
        final destCity = route['destination_city'] as String;

        final bPoints = getPoints(sourceCity, depTime, true);
        final dPoints = getPoints(destCity, arrTime, false);

        final bus = busesData.firstWhere((b) => b['id'] == busId);
        final totalSeats = bus['total_seats'] as int;
        final busType = bus['bus_type'] as String;
        final isSleeper = busType.contains('Sleeper');

        // Insert trip with temporary total seats count
        await db.insert(DatabaseTables.tableTrips, {
          'id': currentTripId,
          'bus_id': busId,
          'route_id': routeId,
          'journey_date': dateString,
          'departure_time': depTime,
          'arrival_time': arrTime,
          'base_price': basePrice,
          'boarding_points': jsonEncode(bPoints),
          'dropping_points': jsonEncode(dPoints),
          'available_seats_count': totalSeats,
        });

        // Generate Seats for this trip
        int bookedCount = 0;
        final seatsList = <Map<String, dynamic>>[];

        if (isSleeper) {
          // 30 Berths: 15 Lower Deck (L1..L15), 15 Upper Deck (U1..U15)
          // 5 rows of 3 berths each (Single on Left, Double on Right)
          for (final deck in ['Lower', 'Upper']) {
            final prefix = deck == 'Lower' ? 'L' : 'U';
            int seatNum = 1;
            for (int r = 1; r <= 5; r++) {
              for (int c = 1; c <= 3; c++) {
                final seatNumber = '$prefix$seatNum';
                // Deterministic sample booking pattern for variety
                final isInitiallyBooked = (seatNum % 4 == 0 && dayOffset <= 2);
                if (isInitiallyBooked) bookedCount++;

                // Upper deck slightly cheaper or base price
                final price = deck == 'Upper' ? basePrice : (basePrice + 100);

                seatsList.add({
                  'trip_id': currentTripId,
                  'seat_number': seatNumber,
                  'seat_type': 'sleeper',
                  'deck': deck.toLowerCase(),
                  'row_index': r,
                  'column_index': c,
                  'price': price,
                  'is_booked': isInitiallyBooked ? 1 : 0,
                });
                seatNum++;
              }
            }
          }
        } else {
          // 36 Seats: 9 rows of 4 seats (2x2: A, B aisle C, D)
          final cols = ['A', 'B', 'C', 'D'];
          for (int r = 1; r <= 9; r++) {
            for (int c = 0; c < 4; c++) {
              final seatNumber = '$r${cols[c]}';
              final isInitiallyBooked = ((r * 4 + c) % 5 == 0 && dayOffset <= 2);
              if (isInitiallyBooked) bookedCount++;

              // Front rows or window seats can have slight variation
              final isWindow = (c == 0 || c == 3);
              final price = isWindow ? (basePrice + 50) : basePrice;

              seatsList.add({
                'trip_id': currentTripId,
                'seat_number': seatNumber,
                'seat_type': 'seater',
                'deck': 'lower',
                'row_index': r,
                'column_index': c + 1,
                'price': price,
                'is_booked': isInitiallyBooked ? 1 : 0,
              });
            }
          }
        }

        // Insert seats in batch
        final batch = db.batch();
        for (final seat in seatsList) {
          batch.insert(DatabaseTables.tableSeats, seat);
        }
        await batch.commit(noResult: true);

        // Update available seats count
        final availableCount = totalSeats - bookedCount;
        await db.update(
          DatabaseTables.tableTrips,
          {'available_seats_count': availableCount},
          where: 'id = ?',
          whereArgs: [currentTripId],
        );

        // Track trip IDs for sample bookings
        if (dayOffset == 2 && sampleUpcomingTripId == null && routeId == 1) {
          sampleUpcomingTripId = currentTripId;
        }
        if (dayOffset == -5 && samplePastTripId == null && routeId == 1) {
          samplePastTripId = currentTripId;
        }
      }
    }

    // 6. Seed Sample Bookings so "Upcoming" and "Completed" bookings exist right away!
    // A. Sample Upcoming Booking (2 days ahead: Delhi -> Chandigarh)
    if (sampleUpcomingTripId != null) {
      final pnrUpcoming = 'SB-682491';
      final bookingDate = now.subtract(const Duration(days: 1)).toIso8601String();

      // Find 2 available seats in that trip
      final availableSeats = await db.query(
        DatabaseTables.tableSeats,
        where: 'trip_id = ? AND is_booked = 0',
        limit: 2,
        whereArgs: [sampleUpcomingTripId],
      );

      if (availableSeats.length >= 2) {
        final seat1 = availableSeats[0];
        final seat2 = availableSeats[1];
        final baseFare = (seat1['price'] as num).toDouble() + (seat2['price'] as num).toDouble();
        final convFee = 40.0;
        final total = baseFare + convFee;

        final bookingId = await db.insert(DatabaseTables.tableBookings, {
          'pnr': pnrUpcoming,
          'trip_id': sampleUpcomingTripId,
          'user_id': userId,
          'contact_email': 'smriti.rawat@example.com',
          'contact_phone': '9876543210',
          'total_passengers': 2,
          'base_fare': baseFare,
          'convenience_fee': convFee,
          'total_amount': total,
          'booking_status': 'CONFIRMED',
          'booking_date': bookingDate,
          'boarding_point': 'Kashmere Gate ISBT',
          'dropping_point': 'Sector 43 ISBT',
        });

        // Insert booking seats
        await db.insert(DatabaseTables.tableBookingSeats, {
          'booking_id': bookingId,
          'seat_id': seat1['id'],
          'seat_number': seat1['seat_number'],
          'seat_price': seat1['price'],
        });
        await db.insert(DatabaseTables.tableBookingSeats, {
          'booking_id': bookingId,
          'seat_id': seat2['id'],
          'seat_number': seat2['seat_number'],
          'seat_price': seat2['price'],
        });

        // Mark seats as booked
        await db.update(
          DatabaseTables.tableSeats,
          {'is_booked': 1},
          where: 'id IN (?, ?)',
          whereArgs: [seat1['id'], seat2['id']],
        );

        // Update trip available seats count
        await db.rawUpdate(
          'UPDATE ${DatabaseTables.tableTrips} SET available_seats_count = available_seats_count - 2 WHERE id = ?',
          [sampleUpcomingTripId],
        );

        // Insert Passengers
        await db.insert(DatabaseTables.tablePassengers, {
          'booking_id': bookingId,
          'full_name': 'Smriti Rawat',
          'age': 25,
          'gender': 'Female',
          'seat_number': seat1['seat_number'],
        });
        await db.insert(DatabaseTables.tablePassengers, {
          'booking_id': bookingId,
          'full_name': 'Aarav Sharma',
          'age': 27,
          'gender': 'Male',
          'seat_number': seat2['seat_number'],
        });

        // Insert Payment
        await db.insert(DatabaseTables.tablePayments, {
          'booking_id': bookingId,
          'transaction_id': PnrGenerator.generateTransactionId(),
          'payment_method': 'UPI',
          'amount': total,
          'payment_status': 'SUCCESS',
          'payment_date': bookingDate,
        });
      }
    }

    // B. Sample Completed Past Booking (5 days ago: Delhi -> Chandigarh)
    if (samplePastTripId != null) {
      final pnrCompleted = 'SB-419823';
      final bookingDate = now.subtract(const Duration(days: 7)).toIso8601String();

      final availableSeats = await db.query(
        DatabaseTables.tableSeats,
        where: 'trip_id = ?',
        limit: 1,
        whereArgs: [samplePastTripId],
      );

      if (availableSeats.isNotEmpty) {
        final seat = availableSeats.first;
        final baseFare = (seat['price'] as num).toDouble();
        final convFee = 40.0;
        final total = baseFare + convFee;

        final bookingId = await db.insert(DatabaseTables.tableBookings, {
          'pnr': pnrCompleted,
          'trip_id': samplePastTripId,
          'user_id': userId,
          'contact_email': 'smriti.rawat@example.com',
          'contact_phone': '9876543210',
          'total_passengers': 1,
          'base_fare': baseFare,
          'convenience_fee': convFee,
          'total_amount': total,
          'booking_status': 'COMPLETED',
          'booking_date': bookingDate,
          'boarding_point': 'Kashmere Gate ISBT',
          'dropping_point': 'Sector 43 ISBT',
        });

        await db.insert(DatabaseTables.tableBookingSeats, {
          'booking_id': bookingId,
          'seat_id': seat['id'],
          'seat_number': seat['seat_number'],
          'seat_price': seat['price'],
        });

        await db.insert(DatabaseTables.tablePassengers, {
          'booking_id': bookingId,
          'full_name': 'Smriti Rawat',
          'age': 25,
          'gender': 'Female',
          'seat_number': seat['seat_number'],
        });

        await db.insert(DatabaseTables.tablePayments, {
          'booking_id': bookingId,
          'transaction_id': PnrGenerator.generateTransactionId(),
          'payment_method': 'CARD',
          'amount': total,
          'payment_status': 'SUCCESS',
          'payment_date': bookingDate,
        });
      }
    }
  }
}
