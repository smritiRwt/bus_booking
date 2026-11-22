class PaymentModel {
  final int? id;
  final int bookingId;
  final String transactionId;
  final String paymentMethod;
  final double amount;
  final String paymentStatus;
  final String paymentDate;

  const PaymentModel({
    this.id,
    required this.bookingId,
    required this.transactionId,
    required this.paymentMethod,
    required this.amount,
    required this.paymentStatus,
    required this.paymentDate,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'] as int?,
      bookingId: map['booking_id'] as int,
      transactionId: map['transaction_id'] as String,
      paymentMethod: map['payment_method'] as String,
      amount: (map['amount'] as num).toDouble(),
      paymentStatus: map['payment_status'] as String,
      paymentDate: map['payment_date'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'booking_id': bookingId,
      'transaction_id': transactionId,
      'payment_method': paymentMethod,
      'amount': amount,
      'payment_status': paymentStatus,
      'payment_date': paymentDate,
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
