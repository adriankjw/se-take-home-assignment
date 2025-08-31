import "order.dart";
import "order_queue.dart";
import "dart:async";

enum BotState {
  idle,
  busy
}

class Bot {
  Order? order;
  OrderQueue orderQueue;
  // TODO: State machine if more complex states are added
  BotState state = BotState.idle;
  Function onCompleted;
  Timer? timer;

  Bot({
    required this.orderQueue,
    required this.onCompleted
  });

  void prepareNextOrder() {
    try {
      if (orderQueue.hasNextOrder()) {
        state = BotState.busy;
        Order nextOrder = orderQueue.getNextOrder();
        order = nextOrder;
        order?.processOrder();

        // This is a hack to simulate 10 seconds order processing
        timer = Timer(Duration(seconds: 10), () {
          order?.completeOrder();
          orderQueue.queue.remove(order);
          order = null;
          state = BotState.idle;
          notify();
          onCompleted();
        });
      }
    } catch (e) {
      state = BotState.idle;
      if (order != null) {
        orderQueue.addOrder(order!, onCompleted);
      }
    }
  }

  void notify() {
    if (isIdle()) {
      prepareNextOrder();
    }
  }

  bool isIdle() {
    return state == BotState.idle;
  }

  // Clean up the bot and release order before removing the bot
  void cleanUp(Function onCompleted) {
    state = BotState.idle;
    timer?.cancel();
    if (order != null) {
      order?.releaseOrder();
    }
  }
}