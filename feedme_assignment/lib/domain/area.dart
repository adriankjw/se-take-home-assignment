import "order.dart";
import "order_queue.dart";

class Area {
  final String areaName;
  final Area? nextArea;
  final List<Order> orders = [];

  Area({
    required this.areaName,
    this.nextArea,
  });

  void addOrder(Order order, Function? onCompleted) {
    orders.add(order);
  }

  void removeOrder(Order order) {
    orders.remove(order);
  }

  void moveOrderToNextArea(Order order) {
    removeOrder(order);
    nextArea?.addOrder(order, null);
  }
}

class PendingArea extends Area {
  final OrderQueue orderQueue;
  @override
  List<Order> get orders => orderQueue.queue;

  PendingArea({
    required super.areaName,
    super.nextArea,
    required this.orderQueue
  });

  @override
  void addOrder(Order order, Function? onCompleted) {
    orderQueue.addOrder(order, onCompleted);
  }
}