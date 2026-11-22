import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PromoCardWidget extends StatefulWidget {
  final VoidCallback onCouponApplied;

  const PromoCardWidget({super.key, required this.onCouponApplied});

  @override
  State<PromoCardWidget> createState() => _PromoCardWidgetState();
}

class _PromoCardWidgetState extends State<PromoCardWidget>
    with SingleTickerProviderStateMixin {
  bool _isRevealed = false;
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _reveal() {
    if (_isRevealed) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _isRevealed = true;
    });
    _bounceController.forward(from: 0.0);
    widget.onCouponApplied();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _reveal,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: _isRevealed
                  ? const LinearGradient(
                      colors: [Color(0xFF065F46), Color(0xFF047857)],
                    )
                  : const LinearGradient(
                      colors: [Color(0xFF1E1B4B), Color(0xFF4338CA)],
                    ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _isRevealed
                      ? const Color(0xFF047857).withValues(alpha: 0.3)
                      : const Color(0xFF4338CA).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Animated Icon
                ScaleTransition(
                  scale: Tween<double>(begin: 1.0, end: 1.25)
                      .chain(CurveTween(curve: Curves.elasticOut))
                      .animate(_bounceController),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isRevealed ? Icons.celebration_rounded : Icons.card_giftcard_rounded,
                      color: _isRevealed ? const Color(0xFFFDE047) : Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isRevealed ? '₹100 DISCOUNT UNLOCKED! 🎊' : 'Mystery Travel Voucher 🎁',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isRevealed
                          ? 'Promo "SMARTBUS100" applied to your trip!'
                          : 'Tap here to reveal your secret discount coupon',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                // Action tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _isRevealed ? const Color(0xFFFDE047) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _isRevealed ? 'APPLIED ✓' : 'TAP TO REVEAL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: _isRevealed ? const Color(0xFF065F46) : const Color(0xFF4338CA),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
