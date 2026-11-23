import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/seat.dart';
import 'animated_driver_cabin.dart';
import 'seat_widget.dart';

class SleeperSeatLayout extends StatelessWidget {
  final List<SeatEntity> seats;
  final Set<int> selectedSeatIds;
  final ValueChanged<SeatEntity> onSeatTap;
  final String activeDeck; // 'lower' or 'upper'

  const SleeperSeatLayout({
    super.key,
    required this.seats,
    required this.selectedSeatIds,
    required this.onSeatTap,
    required this.activeDeck,
  });

  @override
  Widget build(BuildContext context) {
    // Filter seats by active deck
    final deckSeats = seats
        .where((s) => s.deck.toLowerCase() == activeDeck.toLowerCase())
        .toList();

    final rowsMap = <int, List<SeatEntity>>{};
    for (final seat in deckSeats) {
      rowsMap.putIfAbsent(seat.rowIndex, () => []).add(seat);
    }

    final sortedRowIndices = rowsMap.keys.toList()..sort();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Animated Driver Cabin with Deck indicator
          AnimatedDriverCabin(label: 'Front / ${activeDeck.toUpperCase()} DECK (2+1)'),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Sleeper Berths Rows (2+1 Layout: 1 berth on left, 2 on right)
          ...sortedRowIndices.map((rowIdx) {
            final rowSeats = rowsMap[rowIdx]!;
            rowSeats.sort((a, b) => a.columnIndex.compareTo(b.columnIndex));

            final singleBerth = rowSeats.where((s) => s.columnIndex == 1).toList();
            final doubleBerths = rowSeats.where((s) => s.columnIndex > 1).toList();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  // Single Berth on Left
                  ...singleBerth.map((s) {
                    final isSelected = selectedSeatIds.contains(s.id);
                    return Expanded(
                      flex: 4,
                      child: SeatWidget(
                        seat: s,
                        isSelected: isSelected,
                        onTap: () => onSeatTap(s),
                      ),
                    );
                  }),

                  // Illuminated Walking Aisle
                  Container(
                    width: 36,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryLight.withValues(alpha: 0.7),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'R$rowIdx',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryLight.withValues(alpha: 0.7),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Double Berths on Right
                  ...doubleBerths.map((s) {
                    final isSelected = selectedSeatIds.contains(s.id);
                    return Expanded(
                      flex: 4,
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
        ],
      ),
    );
  }
}
