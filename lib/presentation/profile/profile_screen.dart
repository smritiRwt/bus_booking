import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_card.dart';
import 'profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () => controller.openEditProfileDialog(context),
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadProfile,
        color: AppColors.secondary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // User Avatar & Name Card
              _buildUserCard(context, controller),
              const SizedBox(height: 16),

              // Booking Stats Row
              _buildStatsCard(controller),
              const SizedBox(height: 16),

              // Quick Actions List
              _buildSettingsList(context, controller),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, ProfileController controller) {
    return Obx(() {
      final user = controller.currentUser.value;

      return AppCard(
        padding: const EdgeInsets.all(20),
        borderRadius: 20,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      user != null && user.name.isNotEmpty
                          ? user.name.substring(0, 1).toUpperCase()
                          : 'S',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Smriti Rawat',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.email_outlined, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              user?.email ?? 'smriti.rawat@example.com',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.phone_outlined, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 6),
                          Text(
                            '+91 ${user?.phone ?? "9876543210"}',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatsCard(ProfileController controller) {
    return Obx(() {
      return AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        borderRadius: 16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Total', '${controller.totalBookingsCount.value}', AppColors.primary),
            _buildVerticalDivider(),
            _buildStatItem('Upcoming', '${controller.upcomingCount.value}', AppColors.secondary),
            _buildVerticalDivider(),
            _buildStatItem('Completed', '${controller.completedCount.value}', AppColors.success),
            _buildVerticalDivider(),
            _buildStatItem('Cancelled', '${controller.cancelledCount.value}', AppColors.error),
          ],
        ),
      );
    });
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(width: 1, height: 28, color: AppColors.border);
  }

  Widget _buildSettingsList(BuildContext context, ProfileController controller) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 8),
      borderRadius: 16,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline_rounded, color: AppColors.secondary),
            title: const Text('Edit Account Details', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Update your personal details', style: TextStyle(fontSize: 12)),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => controller.openEditProfileDialog(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.shield_outlined, color: AppColors.secondary),
            title: const Text('Travel Safety & Insurance', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('All SmartBus trips are insured', style: TextStyle(fontSize: 12)),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              Get.snackbar('Safety Guidelines', '24/7 passenger roadside assistance and GPS tracking enabled.');
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.policy_outlined, color: AppColors.secondary),
            title: const Text('Cancellation Policy', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Terms for ticket refund and cancellations', style: TextStyle(fontSize: 12)),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              Get.defaultDialog(
                title: 'Cancellation Policy',
                middleText:
                    '1. Full refund for cancellations made >24 hours prior to journey.\n\n2. 50% refund between 12-24 hours prior.\n\n3. No refund for cancellations within 12 hours of departure.',
                textConfirm: 'Understood',
                confirmTextColor: Colors.white,
                onConfirm: () => Get.back(),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded, color: AppColors.accent),
            title: const Text('About SmartBus', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Portfolio Showcase & Architecture Info', style: TextStyle(fontSize: 12)),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: AppColors.accentGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.directions_bus_rounded, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('SmartBus', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                      Text('Version 1.0.0 (Portfolio Project)', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Key Highlights:',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                '• State Management: GetX\n• Architecture: MVVM + Clean Architecture\n• Local DB: SQLite (sqflite) with Transactions\n• PDF Generation: pdf & printing with QR Code\n• UI: Material 3 Design System\n• 100% Offline with zero remote APIs or Firebase',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
