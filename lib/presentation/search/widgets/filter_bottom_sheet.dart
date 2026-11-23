import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';

class FilterBottomSheet extends StatefulWidget {
  final bool? initialIsAc;
  final bool? initialIsSleeper;
  final String initialSortBy;
  final String initialDepartureSlot;
  final double initialMinRating;
  final void Function({
    bool? isAc,
    bool? isSleeper,
    String? sort,
    String? timeSlot,
    double? rating,
  }) onApply;
  final VoidCallback onReset;

  const FilterBottomSheet({
    super.key,
    this.initialIsAc,
    this.initialIsSleeper,
    required this.initialSortBy,
    required this.initialDepartureSlot,
    required this.initialMinRating,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  bool? _isAc;
  bool? _isSleeper;
  late String _sortBy;
  late String _timeSlot;
  late double _minRating;

  @override
  void initState() {
    super.initState();
    _isAc = widget.initialIsAc;
    _isSleeper = widget.initialIsSleeper;
    _sortBy = widget.initialSortBy;
    _timeSlot = widget.initialDepartureSlot;
    _minRating = widget.initialMinRating;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters & Sorting',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              TextButton(
                onPressed: () {
                  widget.onReset();
                  Navigator.pop(context);
                },
                child: const Text('Reset All', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Sort By
          const Text('Sort By', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChoiceChip('Earliest Departure', _sortBy == 'departure_asc', () {
                setState(() => _sortBy = 'departure_asc');
              }),
              _buildChoiceChip('Price: Low to High', _sortBy == 'price_asc', () {
                setState(() => _sortBy = 'price_asc');
              }),
              _buildChoiceChip('Price: High to Low', _sortBy == 'price_desc', () {
                setState(() => _sortBy = 'price_desc');
              }),
              _buildChoiceChip('Highest Rating', _sortBy == 'rating_desc', () {
                setState(() => _sortBy = 'rating_desc');
              }),
            ],
          ),
          const SizedBox(height: 18),

          // Bus Type: AC / Non-AC
          const Text('AC / Non-AC', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildChoiceChip('All', _isAc == null, () {
                setState(() => _isAc = null);
              }),
              const SizedBox(width: 8),
              _buildChoiceChip('AC Only', _isAc == true, () {
                setState(() => _isAc = true);
              }),
              const SizedBox(width: 8),
              _buildChoiceChip('Non-AC Only', _isAc == false, () {
                setState(() => _isAc = false);
              }),
            ],
          ),
          const SizedBox(height: 18),

          // Seat Type: Sleeper / Seater
          const Text('Seat Type', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildChoiceChip('All', _isSleeper == null, () {
                setState(() => _isSleeper = null);
              }),
              const SizedBox(width: 8),
              _buildChoiceChip('Sleeper Only', _isSleeper == true, () {
                setState(() => _isSleeper = true);
              }),
              const SizedBox(width: 8),
              _buildChoiceChip('Seater Only', _isSleeper == false, () {
                setState(() => _isSleeper = false);
              }),
            ],
          ),
          const SizedBox(height: 18),

          // Departure Time Slot
          const Text('Departure Time', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChoiceChip('Any Time', _timeSlot.isEmpty, () {
                setState(() => _timeSlot = '');
              }),
              _buildChoiceChip('Morning (6 AM - 12 PM)', _timeSlot == 'morning', () {
                setState(() => _timeSlot = 'morning');
              }),
              _buildChoiceChip('Afternoon (12 PM - 6 PM)', _timeSlot == 'afternoon', () {
                setState(() => _timeSlot = 'afternoon');
              }),
              _buildChoiceChip('Evening (6 PM - 12 AM)', _timeSlot == 'evening', () {
                setState(() => _timeSlot = 'evening');
              }),
              _buildChoiceChip('Night (12 AM - 6 AM)', _timeSlot == 'night', () {
                setState(() => _timeSlot = 'night');
              }),
            ],
          ),
          const SizedBox(height: 24),

          // Apply Button
          CustomButton(
            text: 'Apply Filters',
            type: ButtonType.primary,
            onPressed: () {
              widget.onApply(
                isAc: _isAc,
                isSleeper: _isSleeper,
                sort: _sortBy,
                timeSlot: _timeSlot,
                rating: _minRating,
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceChip(String label, bool isSelected, VoidCallback onSelected) {
    return InkWell(
      onTap: onSelected,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary.withValues(alpha: 0.12) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.secondary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppColors.secondary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
