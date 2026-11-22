import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bouncing_widget.dart';
import '../../../domain/entities/seat.dart';
import 'animated_driver_cabin.dart';
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
          // Animated Driver Cabin
          const AnimatedDriverCabin(label: 'Front / Driver Cabin (2x2)'),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Seater Rows with Aisle Guide
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
                      child: BouncingWidget(
                        scaleFactor: 0.94,
                        onTap: () => onSeatTap(s),
                        child: SeatWidget(
                          seat: s,
                          isSelected: isSelected,
                          onTap: () => onSeatTap(s),
                        ),
                      ),
                    );
                  }),

                  // Illuminated Walking Aisle
                  Container(
                    width: 32,
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
                          '$rowIdx',
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

                  // Right 2 Seats
                  ...rightSeats.map((s) {
                    final isSelected = selectedSeatIds.contains(s.id);
                    return Expanded(
                      child: BouncingWidget(
                        scaleFactor: 0.94,
                        onTap: () => onSeatTap(s),
                        child: SeatWidget(
                          seat: s,
                          isSelected: isSelected,
                          onTap: () => onSeatTap(s),
                        ),
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
