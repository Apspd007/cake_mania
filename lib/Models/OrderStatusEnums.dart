enum OrderStatus {
  pending,
  accepted,
  rejected,
  onHold,
  preparing,
  prepared,
  delivery,
  delivered,
}

class OrderStatusConvertor {
  static OrderStatus fromJson(json) {
    if (json == "pending") {
      return OrderStatus.pending;
    } else if (json == "accepted") {
      return OrderStatus.accepted;
    } else if (json == "rejected") {
      return OrderStatus.rejected;
    } else if (json == "preparing") {
      return OrderStatus.preparing;
    } else if (json == "prepared") {
      return OrderStatus.prepared;
    } else if (json == "delivery") {
      return OrderStatus.delivery;
    } else if (json == "delivered") {
      return OrderStatus.delivered;
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
    } else if (OrderStatus.preparing == orderStatus) {
      return 'preparing';
    } else if (OrderStatus.prepared == orderStatus) {
      return 'prepared';
    } else if (OrderStatus.delivery == orderStatus) {
      return 'delivery';
    } else if (OrderStatus.delivered == orderStatus) {
      return 'delivered';
    } else {
      return 'onHold';
    }
  }
}
