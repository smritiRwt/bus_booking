import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/animated_bus_cockpit.dart';
import '../../../domain/entities/seat.dart';
import 'seat_widget.dart';

class SeaterSeatLayout extends StatelessWidget {
  final List<SeatEntity> seats;
  final Set<int> selectedSeatIds;
  final ValueChanged<SeatEntity> onSeatTap;

  const SeaterSeatLayout({
    super.key,
    required this.seats,
    required this.selectedSeatIds,
    required this.onSeatTap,
  });

  @override
  Widget build(BuildContext context) {
    final rowsMap = <int, List<SeatEntity>>{};
    for (final seat in seats) {
      rowsMap.putIfAbsent(seat.rowIndex, () => []).add(seat);
    }

    final sortedRowIndices = rowsMap.keys.toList()..sort();

    return Column(
      children: [
        // Realistic Bus Cockpit & Front Windshield with Animated Steering Wheel
        const AnimatedBusCockpit(
          busType: 'Seater 2+2',
          deckLabel: 'Main Deck',
        ),

        // Interior Seating Cabin
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Aisle Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'LEFT WINDOW',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary, letterSpacing: 0.5),
                  ),
                  Text(
                    'WALKING AISLE',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary, letterSpacing: 0.5),
                  ),
                  Text(
                    'RIGHT WINDOW',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary, letterSpacing: 0.5),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Seater Rows
              ...sortedRowIndices.map((rowIdx) {
                final rowSeats = rowsMap[rowIdx]!;
                rowSeats.sort((a, b) => a.columnIndex.compareTo(b.columnIndex));

                final leftSeats = rowSeats.where((s) => s.columnIndex <= 2).toList();
                final rightSeats = rowSeats.where((s) => s.columnIndex > 2).toList();

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Row(
                    children: [
                      // Left 2 Seats
                      ...leftSeats.map((s) {
                        final isSelected = selectedSeatIds.contains(s.id);
                        return Expanded(
                          child: SeatWidget(
                            seat: s,
                            isSelected: isSelected,
                            onTap: () => onSeatTap(s),
                          ),
                        );
                      }),
                      // Central Aisle with Row Number
                      Container(
                        width: 34,
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '$rowIdx',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ),
                      // Right 2 Seats
                      ...rightSeats.map((s) {
                        final isSelected = selectedSeatIds.contains(s.id);
                        return Expanded(
                          child: SeatWidget(
                            seat: s,
                            isSelected: isSelected,
                            onTap: () => onSeatTap(s),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 16),
              // Rear of Bus
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.airline_seat_recline_extra_rounded, size: 14, color: AppColors.textTertiary),
                      SizedBox(width: 6),
                      Text(
                        'REAR ENGINE & EMERGENCY EXIT',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
