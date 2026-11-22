import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/animated_bus_cockpit.dart';
import '../../../domain/entities/seat.dart';
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
    final deckSeats = seats.where((s) => s.deck.toLowerCase() == activeDeck.toLowerCase()).toList();

    final rowsMap = <int, List<SeatEntity>>{};
    for (final seat in deckSeats) {
      rowsMap.putIfAbsent(seat.rowIndex, () => []).add(seat);
    }

    final sortedRowIndices = rowsMap.keys.toList()..sort();

    return Column(
      children: [
        // Animated Bus Cockpit
        AnimatedBusCockpit(
          busType: 'Sleeper 2+1',
          deckLabel: '$activeDeck Deck',
        ),

        // Interior Cabin
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'SINGLE BERTH',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary, letterSpacing: 0.5),
                  ),
                  Text(
                    'AISLE',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary, letterSpacing: 0.5),
                  ),
                  Text(
                    'DOUBLE BERTH',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textTertiary, letterSpacing: 0.5),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Sleeper Rows (2+1)
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
                      // Aisle
                      Container(
                        width: 36,
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'R$rowIdx',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade500,
                            ),
                          ),
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

              const SizedBox(height: 16),
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
                      Icon(Icons.bed_rounded, size: 14, color: AppColors.textTertiary),
                      SizedBox(width: 6),
                      Text(
                        'BACK OF COACH',
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
