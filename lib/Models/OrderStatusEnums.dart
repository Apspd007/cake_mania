enum OrderStatus {
  pending,
  accepted,
  rejected,
  onHold,
}

class OrderStatusConvertor {
  static OrderStatus fromJson(json) {
    if (json == "pending") {
      return OrderStatus.pending;
    } else if (json == "accepted") {
      return OrderStatus.accepted;
    } else if (json == "rejected") {
      return OrderStatus.rejected;
    } else {
      return OrderStatus.onHold;
    }
  }

  static String toJson(OrderStatus orderStatus) {
    if (OrderStatus.pending == orderStatus) {
      return 'pending';
    } else if (OrderStatus.accepted == orderStatus) {
      return 'accepted';
    } else if (OrderStatus.rejected == orderStatus) {
      return 'rejected';
    } else {
      return 'onHold';
    }
  }
}
