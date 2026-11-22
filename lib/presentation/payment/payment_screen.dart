import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import 'payment_controller.dart';

class PaymentScreen extends GetView<PaymentController> {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Payment Simulation'),
      ),
      body: Obx(() {
        if (controller.isProcessing.value) {
          return _buildProcessingView(controller);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Demo Notice Banner
              _buildDemoBanner(),
              const SizedBox(height: 16),

              // Total Payable Card
              _buildPayableHeader(controller),
              const SizedBox(height: 20),

              // Payment Method Options
              const Text(
                'Select Payment Method',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              _buildMethodTile(
                controller: controller,
                method: 'UPI',
                title: 'UPI (Google Pay, PhonePe, Paytm)',
                subtitle: 'Fast and instant payment simulation',
                icon: Icons.qr_code_scanner_rounded,
              ),
              const SizedBox(height: 10),
              _buildMethodTile(
                controller: controller,
                method: 'CARD',
                title: 'Credit / Debit Card',
                subtitle: 'Visa, MasterCard, RuPay dummy form',
                icon: Icons.credit_card_rounded,
              ),
              const SizedBox(height: 10),
              _buildMethodTile(
                controller: controller,
                method: 'CASH',
                title: 'Cash on Boarding (Demo)',
                subtitle: 'Pay cash to driver during departure',
                icon: Icons.payments_outlined,
              ),
              const SizedBox(height: 20),

              // Method Details Input (UPI ID or Card Details)
              _buildMethodDetailsSection(controller),
              const SizedBox(height: 20),

              // Simulation Mode Switch (Success vs Failure)
              _buildSimulationToggle(controller),
              const SizedBox(height: 80),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.isProcessing.value) return const SizedBox.shrink();

        return Container(
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
              text: 'Pay ${CurrencyFormatter.format(controller.totalAmount)} (Demo)',
              type: ButtonType.gradient,
              onPressed: controller.executePayment,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDemoBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF59E0B)),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline_rounded, color: Color(0xFFB45309), size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'DEMO PAYMENT GATEWAY\nThis is a local simulation. No real transactions or money will be charged.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF92400E),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayableHeader(PaymentController controller) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      borderRadius: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Amount Payable', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text(
                CurrencyFormatter.format(controller.totalAmount),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primary),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${controller.selectedSeats.length} Seat(s)',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.secondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodTile({
    required PaymentController controller,
    required String method,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Obx(() {
      final isSelected = controller.selectedMethod.value == method;

      return AppCard(
        padding: const EdgeInsets.all(14),
        borderRadius: 14,
        onTap: () => controller.selectedMethod.value = method,
        border: Border.all(
          color: isSelected ? AppColors.secondary : AppColors.border,
          width: isSelected ? 1.8 : 1,
        ),
        color: isSelected ? AppColors.secondary.withOpacity(0.04) : Colors.white,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.secondary : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: isSelected ? Colors.white : AppColors.textSecondary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.secondary : AppColors.textTertiary,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMethodDetailsSection(PaymentController controller) {
    return Obx(() {
      if (controller.selectedMethod.value == 'UPI') {
        return AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Enter UPI ID (Demo)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              CustomTextField(
                label: 'UPI ID',
                hint: 'e.g. user@okaxis or user@okhdfcbank',
                prefixIcon: Icons.alternate_email_rounded,
                controller: TextEditingController(text: 'smriti@oksmartbus'),
              ),
            ],
          ),
        );
      } else if (controller.selectedMethod.value == 'CARD') {
        return AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Card Information (Demo)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              CustomTextField(
                label: 'Card Number',
                hint: '4532 •••• •••• 8912',
                prefixIcon: Icons.credit_card_rounded,
                controller: TextEditingController(text: '4532 8912 3456 7890'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Expiry',
                      hint: 'MM/YY',
                      controller: TextEditingController(text: '08/28'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      label: 'CVV',
                      hint: '•••',
                      controller: TextEditingController(text: '839'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
      return AppCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: const [
            Icon(Icons.check_circle_outline_rounded, color: AppColors.success),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'You will pay cash at the bus counter before boarding.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSimulationToggle(PaymentController controller) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 14,
      color: Colors.white,
      child: Obx(
        () => Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: controller.simulateFailure.value ? Colors.red.shade100 : Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                controller.simulateFailure.value ? Icons.cancel_outlined : Icons.check_circle_outline,
                color: controller.simulateFailure.value ? Colors.red.shade700 : Colors.green.shade700,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.simulateFailure.value ? 'Simulating: Payment Failure' : 'Simulating: Payment Success',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: controller.simulateFailure.value ? Colors.red.shade700 : Colors.green.shade700,
                    ),
                  ),
                  Text(
                    controller.simulateFailure.value
                        ? 'Payment will fail and no seats will be booked'
                        : 'Payment will succeed and confirm booking',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Switch(
              value: controller.simulateFailure.value,
              activeColor: Colors.red.shade700,
              onChanged: (val) => controller.simulateFailure.value = val,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingView(PaymentController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(
                strokeWidth: 3.5,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Processing Demo Payment...',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Obx(
              () => Text(
                controller.processingStatusText.value,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
