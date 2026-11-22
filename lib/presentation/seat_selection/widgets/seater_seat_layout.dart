import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
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
    // 9 Rows of 4 seats (2x2 layout with aisle)
    // Seats are indexed by rowIndex (1..9) and columnIndex (1..4)
    final rowsMap = <int, List<SeatEntity>>{};
    for (final seat in seats) {
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
          // Driver Cabin Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Front / Driver Cabin',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
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

          // Seater Rows
          ...sortedRowIndices.map((rowIdx) {
            final rowSeats = rowsMap[rowIdx]!;
            rowSeats.sort((a, b) => a.columnIndex.compareTo(b.columnIndex));

            // Split into Left 2 (col 1, 2) and Right 2 (col 3, 4)
            final leftSeats = rowSeats.where((s) => s.columnIndex <= 2).toList();
            final rightSeats = rowSeats.where((s) => s.columnIndex > 2).toList();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
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
                  // Aisle
                  Container(
                    width: 32,
                    alignment: Alignment.center,
                    child: Text(
                      '$rowIdx',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade400,
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
        ],
      ),
    );
  }
}
