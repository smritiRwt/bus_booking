import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/empty_state_view.dart';
import '../../routes/app_routes.dart';
import '../bus_details/bus_details_controller.dart';
import 'search_controller.dart';
import 'widgets/bus_card.dart';
import 'widgets/filter_bottom_sheet.dart';

class SearchScreen extends GetView<SearchBusController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchBusController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              '${controller.sourceCity} ➔ ${controller.destinationCity}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            Obx(
              () => Text(
                DateFormatter.toDisplayString(controller.selectedDate.value),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => _openFilterSheet(context, controller),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildQuickDateBar(context, controller),
          _buildQuickFilterChips(controller, context),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.secondary),
                );
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return EmptyStateView(
                  icon: Icons.error_outline_rounded,
                  title: 'Unable to Load Buses',
                  description: controller.errorMessage.value,
                  buttonText: 'Retry',
                  onButtonPressed: controller.fetchTrips,
                );
              }

              if (controller.trips.isEmpty) {
                return EmptyStateView(
                  icon: Icons.directions_bus_outlined,
                  title: 'No Buses Found',
                  description: controller.hasActiveFilters
                      ? 'No buses match your current filters. Try resetting the filters.'
                      : 'No buses available for this route on ${DateFormatter.toShortDisplay(controller.selectedDate.value)}.',
                  buttonText: controller.hasActiveFilters ? 'Clear Filters' : 'Change Date',
                  onButtonPressed: () {
                    if (controller.hasActiveFilters) {
                      controller.resetFilters();
                    } else {
                      controller.changeDate(controller.selectedDate.value.add(const Duration(days: 1)));
                    }
                  },
                );
              }

              return RefreshIndicator(
                onRefresh: controller.fetchTrips,
                color: AppColors.secondary,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.trips.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final trip = controller.trips[index];
                    return BusCard(
                      trip: trip,
                      onViewDetails: () {
                        Get.toNamed(AppRoutes.busDetails, arguments: trip);
                      },
                      onSelectSeats: () {
                        Get.toNamed(AppRoutes.seatSelection, arguments: trip);
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickDateBar(BuildContext context, SearchBusController controller) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded, color: AppColors.primary),
            onPressed: () {
              final prev = controller.selectedDate.value.subtract(const Duration(days: 1));
              if (prev.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
                controller.changeDate(prev);
              }
            },
          ),
          Obx(
            () => InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: controller.selectedDate.value,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                );
                if (picked != null) {
                  controller.changeDate(picked);
                }
              },
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_rounded, size: 16, color: AppColors.secondary),
                  const SizedBox(width: 6),
                  Text(
                    DateFormatter.toDisplayString(controller.selectedDate.value),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
            onPressed: () {
              final next = controller.selectedDate.value.add(const Duration(days: 1));
              controller.changeDate(next);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilterChips(SearchBusController controller, BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            InkWell(
              onTap: () => _openFilterSheet(context, controller),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.filter_list_rounded, size: 16, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text('Filters', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Obx(
              () => _buildFilterChip(
                label: 'AC Only',
                isActive: controller.filterAc.value == true,
                onTap: controller.toggleAcFilter,
              ),
            ),
            const SizedBox(width: 8),
            Obx(
              () => _buildFilterChip(
                label: 'Sleeper',
                isActive: controller.filterSleeper.value == true,
                onTap: controller.toggleSleeperFilter,
              ),
            ),
            const SizedBox(width: 8),
            Obx(
              () => _buildFilterChip(
                label: 'Cheapest First',
                isActive: controller.sortBy.value == 'price_asc',
                onTap: () {
                  if (controller.sortBy.value == 'price_asc') {
                    controller.setSortBy('departure_asc');
                  } else {
                    controller.setSortBy('price_asc');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.secondary : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.secondary : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  void _openFilterSheet(BuildContext context, SearchBusController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return FilterBottomSheet(
          initialIsAc: controller.filterAc.value,
          initialIsSleeper: controller.filterSleeper.value,
          initialSortBy: controller.sortBy.value,
          initialDepartureSlot: controller.departureSlot.value,
          initialMinRating: controller.minRating.value,
          onApply: controller.applyFullFilter,
          onReset: controller.resetFilters,
        );
      },
    );
  }
}
