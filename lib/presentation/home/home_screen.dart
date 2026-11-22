import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/promo_card_widget.dart';
import '../../core/widgets/pulse_radar_widget.dart';
import '../../core/widgets/status_badge.dart';
import '../../routes/app_routes.dart';
import 'home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async => controller.loadUpcomingBooking(),
        color: AppColors.secondary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, controller),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildSearchCard(context, controller),
                    const SizedBox(height: 16),
                    // Interactive Mystery Promo Card
                    PromoCardWidget(
                      onCouponApplied: controller.applyMysteryCoupon,
                    ),
                    const SizedBox(height: 16),
                    // Live Radar Tracker Banner
                    _buildLiveRadarCard(context),
                    const SizedBox(height: 20),
                    _buildUpcomingBookingSection(context, controller),
                    const SizedBox(height: 20),
                    _buildPopularDestinationsSection(context, controller),
                    const SizedBox(height: 20),
                    _buildPopularRoutesSection(context, controller),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HomeController controller) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Color(0x330077B6),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          controller.timeGreeting,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Obx(
                    () => Text(
                      'Hello, ${controller.userName.value} 👋',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Smart way to book your next journey',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                  onPressed: () {
                    Get.snackbar(
                      'SmartBus Notifications',
                      'No new notifications. All 12 bus routes running on schedule!',
                      backgroundColor: AppColors.primary,
                      colorText: Colors.white,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard(BuildContext context, HomeController controller) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 24,
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // City Selection with Interactive Animated Swap
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Column(
                children: [
                  // From City
                  _buildCityDropdown(
                    context: context,
                    label: 'PICKUP FROM',
                    icon: Icons.trip_origin_rounded,
                    iconColor: AppColors.secondary,
                    selectedCity: controller.fromCity,
                    cities: controller.cities,
                    onSelected: (val) => controller.fromCity.value = val,
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 12),
                  // To City
                  _buildCityDropdown(
                    context: context,
                    label: 'DROP AT',
                    icon: Icons.location_on_rounded,
                    iconColor: AppColors.accent,
                    selectedCity: controller.toCity,
                    cities: controller.cities,
                    onSelected: (val) => controller.toCity.value = val,
                  ),
                ],
              ),
              // Interactive Animated Swap Button
              Positioned(
                right: 12,
                child: Obx(
                  () => TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: controller.swapRotationAngle.value),
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutBack,
                    builder: (context, angle, child) {
                      return Transform.rotate(
                        angle: angle,
                        child: child,
                      );
                    },
                    child: InkWell(
                      onTap: controller.swapCities,
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: AppColors.bannerGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.secondary.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.swap_vert_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Date Selection Section
          const Text(
            'JOURNEY DATE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // Today Chip
              Obx(() {
                final isSelected = DateFormatter.isToday(controller.selectedDate.value);
                return _buildDateChip(
                  label: 'Today',
                  isSelected: isSelected,
                  onTap: () => controller.setDate(DateTime.now()),
                );
              }),
              const SizedBox(width: 8),
              // Tomorrow Chip
              Obx(() {
                final isSelected = DateFormatter.isTomorrow(controller.selectedDate.value);
                return _buildDateChip(
                  label: 'Tomorrow',
                  isSelected: isSelected,
                  onTap: () => controller.setDate(DateTime.now().add(const Duration(days: 1))),
                );
              }),
              const SizedBox(width: 8),
              // Custom Date Picker Tile
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: controller.selectedDate.value,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 90)),
                    );
                    if (picked != null) {
                      controller.setDate(picked);
                    }
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_month_rounded, size: 16, color: AppColors.secondary),
                        const SizedBox(width: 6),
                        Obx(
                          () => Text(
                            DateFormatter.toShortDisplay(controller.selectedDate.value),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Search Buses Button
          CustomButton(
            text: 'Search Buses',
            icon: Icons.search_rounded,
            type: ButtonType.gradient,
            onPressed: controller.searchBuses,
          ),
        ],
      ),
    );
  }

  Widget _buildLiveRadarCard(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: 16,
      color: Colors.white,
      child: Row(
        children: [
          const PulseRadarWidget(
            color: Color(0xFF10B981),
            size: 38,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Live Fleet Radar Active',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'All 12 fleet buses tracked via on-board GPS',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'LIVE',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF059669)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.secondary : Colors.transparent,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildCityDropdown({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color iconColor,
    required RxString selectedCity,
    required RxList<String> cities,
    required ValueChanged<String> onSelected,
  }) {
    return InkWell(
      onTap: () {
        _showCitySelectionSheet(context, label, cities, onSelected);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textTertiary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Obx(
                    () => Text(
                      selectedCity.value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  void _showCitySelectionSheet(
    BuildContext context,
    String title,
    List<String> cities,
    ValueChanged<String> onSelect,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Select City',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: cities.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final city = cities[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.location_city_rounded, color: AppColors.secondary),
                      title: Text(
                        city,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      onTap: () {
                        onSelect(city);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUpcomingBookingSection(BuildContext context, HomeController controller) {
    return Obx(() {
      final booking = controller.upcomingBooking.value;
      if (booking == null) return const SizedBox.shrink();

      final trip = booking.trip;
      final route = trip?.route;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upcoming Journey',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.bookingDetails, arguments: booking);
                },
                child: const Text('View Ticket', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppCard(
            onTap: () => Get.toNamed(AppRoutes.bookingDetails, arguments: booking),
            padding: const EdgeInsets.all(16),
            borderRadius: 18,
            color: Colors.white,
            border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'PNR: ${booking.pnr}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    StatusBadge(status: booking.bookingStatus),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      route?.sourceCity ?? 'Origin',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.textSecondary),
                    ),
                    Text(
                      route?.destinationCity ?? 'Destination',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      DateFormatter.formatDbStringToDisplay(trip?.journeyDate ?? ''),
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 14),
                    const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      trip?.departureTime ?? '',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const Spacer(),
                    Text(
                      'Seats: ${booking.bookingSeats.map((s) => s.seatNumber).join(', ')}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildPopularDestinationsSection(BuildContext context, HomeController controller) {
    final destinations = [
      {'name': 'Manali', 'state': 'Himachal Pradesh', 'tag': 'Snow & Valleys', 'icon': Icons.landscape_rounded},
      {'name': 'Shimla', 'state': 'Himachal Pradesh', 'tag': 'Queen of Hills', 'icon': Icons.forest_rounded},
      {'name': 'Jaipur', 'state': 'Rajasthan', 'tag': 'Pink City', 'icon': Icons.fort_rounded},
      {'name': 'Amritsar', 'state': 'Punjab', 'tag': 'Golden Temple', 'icon': Icons.temple_hindu_rounded},
      {'name': 'Chandigarh', 'state': 'Punjab/Haryana', 'tag': 'The City Beautiful', 'icon': Icons.park_rounded},
      {'name': 'Dehradun', 'state': 'Uttarakhand', 'tag': 'Doon Valley', 'icon': Icons.nature_people_rounded},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular Destinations',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              final d = destinations[index];
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 12),
                child: AppCard(
                  padding: const EdgeInsets.all(12),
                  borderRadius: 16,
                  onTap: () {
                    controller.toCity.value = d['name'] as String;
                    controller.searchBuses();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(d['icon'] as IconData, color: AppColors.secondary, size: 20),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d['name'] as String,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                          ),
                          Text(
                            d['tag'] as String,
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularRoutesSection(BuildContext context, HomeController controller) {
    final routes = [
      {'from': 'Delhi', 'to': 'Chandigarh', 'time': '4h 30m', 'price': '₹799'},
      {'from': 'Delhi', 'to': 'Jaipur', 'time': '5h 15m', 'price': '₹699'},
      {'from': 'Delhi', 'to': 'Manali', 'time': '11h 30m', 'price': '₹1,399'},
      {'from': 'Chandigarh', 'to': 'Amritsar', 'time': '4h 15m', 'price': '₹450'},
      {'from': 'Delhi', 'to': 'Dehradun', 'time': '5h 00m', 'price': '₹550'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular Express Routes',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: routes.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final r = routes[index];
            return AppCard(
              padding: const EdgeInsets.all(14),
              borderRadius: 16,
              onTap: () => controller.selectQuickRoute(r['from']!, r['to']!),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.directions_bus_filled_rounded, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${r['from']} ➔ ${r['to']}',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Duration: ${r['time']}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        r['price']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.secondary,
                        ),
                      ),
                      const Text(
                        'Book Now ➔',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.accent),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
