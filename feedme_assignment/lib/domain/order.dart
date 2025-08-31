import "area.dart";

enum OrderType {
  normal,
  vip
}

enum OrderState {
  unprocessed,
  processing,
  completed
}

class Order {
  late String orderNo;
  final OrderType orderType;
  final Area area;
  // TODO: Add state machine if more complex states are added later
  OrderState state = OrderState.unprocessed;

  Order({
    required this.orderNo,
    required this.orderType,
    required this.area
  });

  void processOrder() {
    state = OrderState.processing;
  }

  void completeOrder() {
    area.moveOrderToNextArea(this);
    state = OrderState.completed;
  }

  void releaseOrder() {
    state = OrderState.unprocessed;
  }
}