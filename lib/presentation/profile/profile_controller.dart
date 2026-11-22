import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/validators.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_user_bookings_usecase.dart';
import '../../data/datasources/preferences_datasource.dart';
import '../../domain/repositories/user_repository.dart';

class ProfileController extends GetxController {
  final UserRepository userRepository = Get.find<UserRepository>();
  final GetUserBookingsUseCase getBookingsUseCase = Get.find<GetUserBookingsUseCase>();
  final PreferencesDataSource prefs = Get.find<PreferencesDataSource>();

  final Rx<UserEntity?> currentUser = Rx<UserEntity?>(null);
  final RxInt totalBookingsCount = 0.obs;
  final RxInt upcomingCount = 0.obs;
  final RxInt completedCount = 0.obs;
  final RxInt cancelledCount = 0.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      final user = await userRepository.getCurrentUser();
      currentUser.value = user;

      final bookings = await getBookingsUseCase.getAll(user?.id ?? 1);
      totalBookingsCount.value = bookings.length;
      upcomingCount.value = bookings.where((b) => b.isConfirmed).length;
      completedCount.value = bookings.where((b) => b.isCompleted).length;
      cancelledCount.value = bookings.where((b) => b.isCancelled).length;
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void openEditProfileDialog(BuildContext context) {
    final nameCtrl = TextEditingController(text: currentUser.value?.name ?? '');
    final emailCtrl = TextEditingController(text: currentUser.value?.email ?? '');
    final phoneCtrl = TextEditingController(text: currentUser.value?.phone ?? '');
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Edit Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameCtrl,
                    validator: Validators.validateName,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: const Icon(Icons.person_rounded),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailCtrl,
                    validator: Validators.validateEmail,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: const Icon(Icons.email_rounded),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: phoneCtrl,
                    validator: Validators.validatePhone,
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      prefixIcon: const Icon(Icons.phone_android_rounded),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final updated = UserEntity(
                              id: currentUser.value?.id ?? 1,
                              name: nameCtrl.text.trim(),
                              email: emailCtrl.text.trim(),
                              phone: phoneCtrl.text.trim(),
                              createdAt: currentUser.value?.createdAt ?? DateTime.now().toIso8601String(),
                            );
                            await userRepository.updateUser(updated);
                            currentUser.value = updated;
                            Get.back();
                            Get.snackbar(
                              'Profile Updated',
                              'Your profile details have been saved',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
