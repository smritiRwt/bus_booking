import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/seat.dart';
import 'seat_widget.dart';

class SleeperSeatLayout extends StatelessWidget {
  final List<SeatEntity> seats;
  final List<SeatEntity> selectedSeats;
  final ValueChanged<SeatEntity> onSeatTap;
  final String activeDeck; // 'lower' or 'upper'

  const SleeperSeatLayout({
    super.key,
    required this.seats,
    required this.selectedSeats,
    required this.onSeatTap,
    required this.activeDeck,
  });

  @override
  Widget build(BuildContext context) {
    // Filter seats by active deck
    final deckSeats = seats.where((s) => s.deck.toLowerCase() == activeDeck.toLowerCase()).toList();

    final rowsMap = <int, List<SeatEntity>>{};
    for (final seat in deckSeats) {
      rowsMap.putIfAbsent(seat.rowIndex, () => []).add(seat);
    }

    final sortedRowIndices = rowsMap.keys.toList()..sort();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Driver Cabin Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Front (${activeDeck.toUpperCase()} DECK)',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.circle_outlined, size: 18, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
                    final isSelected = selectedSeats.any((sel) => sel.id == s.id);
                    return Expanded(
                      flex: 4,
                      child: SeatWidget(
                        seat: s,
                        isSelected: isSelected,
                        onTap: () => onSeatTap(s),
                      ),
                    );
                  }),
                  // Aisle
                  Container(
                    width: 36,
                    alignment: Alignment.center,
                    child: Text(
                      'R$rowIdx',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  // Double Berths on Right
                  ...doubleBerths.map((s) {
                    final isSelected = selectedSeats.any((sel) => sel.id == s.id);
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
