enum PaymentStatus {
  unpaid,
  paid,
  canceled,
}

class PaymentStatusConvertor {
  static PaymentStatus fromJson(json) {
    if (json == "paid") {
      return PaymentStatus.paid;
    } else if (json == "canceled") {
      return PaymentStatus.canceled;
    } else {
      return PaymentStatus.unpaid;
    }
  }

  static String toJson(PaymentStatus paymentStatus) {
    if (PaymentStatus.paid == paymentStatus) {
      return 'paid';
    } else if (PaymentStatus.canceled == paymentStatus) {
      return 'canceled';
    } else if (PaymentStatus.unpaid == paymentStatus) {
      return 'unpaid';
    } else {
      return 'unpaid';
    }
  }
}
