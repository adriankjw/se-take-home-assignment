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
    return queue.isNotEmpty;
  }

  Order getNextOrder() {
    if (queue.isEmpty) {
      throw Exception("Tried to get order from an empty queue.");
    };
    return queue.removeAt(0);
  }
}