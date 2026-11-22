import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import 'passenger_details_controller.dart';

class PassengerDetailsScreen extends GetView<PassengerDetailsController> {
  const PassengerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PassengerDetailsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Passenger Details'),
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Details Card
              _buildContactDetailsCard(controller),
              const SizedBox(height: 16),

              // Boarding & Dropping Point Selection Card
              _buildPointsSelectionCard(context, controller),
              const SizedBox(height: 20),

              // Passenger Forms for Each Seat
              const Text(
                'Passenger Information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              ...List.generate(controller.passengerForms.length, (index) {
                final formData = controller.passengerForms[index];
                return _buildPassengerCard(index, formData);
              }),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: CustomButton(
            text: 'Proceed to Booking Summary',
            type: ButtonType.gradient,
            onPressed: controller.proceedToSummary,
          ),
        ),
      ),
    );
  }

  Widget _buildContactDetailsCard(PassengerDetailsController controller) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.contact_mail_rounded, color: AppColors.secondary, size: 20),
              SizedBox(width: 8),
              Text(
                'Primary Contact Details',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Ticket details and updates will be sent to these details',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: controller.phoneController,
            label: 'Mobile Number',
            hint: '10-digit mobile number',
            prefixIcon: Icons.phone_android_rounded,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: Validators.validatePhone,
          ),
          const SizedBox(height: 14),
          CustomTextField(
            controller: controller.emailController,
            label: 'Email Address',
            hint: 'name@example.com',
            prefixIcon: Icons.email_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),
        ],
      ),
    );
  }

  Widget _buildPointsSelectionCard(BuildContext context, PassengerDetailsController controller) {
    final trip = controller.trip;

    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Boarding & Dropping Points',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          // Boarding Point
          const Text('Boarding Point', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondary)),
          const SizedBox(height: 6),
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: controller.selectedBoardingPoint.value.isEmpty
                      ? null
                      : controller.selectedBoardingPoint.value,
                  items: trip.boardingPoints.map((bp) {
                    return DropdownMenuItem<String>(
                      value: bp.pointName,
                      child: Text('${bp.pointName} (${bp.time})', style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) controller.selectedBoardingPoint.value = val;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Dropping Point
          const Text('Dropping Point', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.accent)),
          const SizedBox(height: 6),
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: controller.selectedDroppingPoint.value.isEmpty
                      ? null
                      : controller.selectedDroppingPoint.value,
                  items: trip.droppingPoints.map((dp) {
                    return DropdownMenuItem<String>(
                      value: dp.pointName,
                      child: Text('${dp.pointName} (${dp.time})', style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) controller.selectedDroppingPoint.value = val;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerCard(int index, PassengerFormData formData) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          child: AppCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Passenger ${index + 1}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Seat ${formData.seat.seatNumber}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: formData.nameController,
                  label: 'Full Name',
                  hint: 'e.g. John Doe',
                  prefixIcon: Icons.person_rounded,
                  textCapitalization: TextCapitalization.words,
                  validator: Validators.validateName,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextField(
                        controller: formData.ageController,
                        label: 'Age',
                        hint: 'Yrs',
                        prefixIcon: Icons.cake_rounded,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3),
                        ],
                        validator: Validators.validateAge,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gender',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: formData.gender,
                                items: const [
                                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => formData.gender = val);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
