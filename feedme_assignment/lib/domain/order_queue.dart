import 'order.dart'; // Add 'fm' prefix

class OrderQueue {
  final List<Order> queue = [];

  void addOrder(Order order, Function? onCompleted) {
    // TODO: If more order types are added, might need to implement Strategy pattern otherwise switch block here will be hard to maintain
    switch (order.orderType) {
      case OrderType.normal:
        queue.add(order); // Insert normal order after last normal order
        if (onCompleted != null) {
          onCompleted();
        }
        break;
      case OrderType.vip:
        int lastVipIndex = queue.lastIndexWhere((order) {
          return order.orderType == OrderType.vip;
        });
        queue.insert(lastVipIndex + 1, order); // Insert vip order after last vip order
        if (onCompleted != null) {
          onCompleted();
        }
    }
  }

  bool hasNextOrder() {
    // Check if there are any unprocessed orders
    return queue.any((order) {
      return order.state == OrderState.unprocessed;
    });
  }

  Order getNextOrder() {
    if (!queue.any((order) {
      return order.state == OrderState.unprocessed;
    })) {
      throw Exception("No unprocessed orders.");
    };
    return queue.firstWhere((order) {
      return order.state == OrderState.unprocessed;
    });
  }
}