import "package:feedme_assignment/domain/order.dart";

import "area.dart";
import "bot.dart";
import "order_queue.dart";

class Restaurant {
  late PendingArea pendingArea;
  late Area completeArea;
  late OrderQueue orderQueue;
  late List<Bot> bots;
  int orderNo = 0;
  Function onCompleted;

  Restaurant({required this.onCompleted}) {
    orderQueue = OrderQueue();
    completeArea = Area(areaName: "COMPLETE");
    pendingArea = PendingArea(areaName: "PENDING", nextArea: completeArea, orderQueue: orderQueue);
    bots = [];
  }

  void addBot() {
    Bot bot = Bot(orderQueue: orderQueue, onCompleted: onCompleted);
    bots.add(bot);
    notifyBots();
  }

  void removeBot(Bot bot) {
    bot.cleanUp(onCompleted);
    bots.remove(bot);
    notifyBots();
  }

  void addOrder(OrderType orderType) {
    int nextOrderNoInt = ++orderNo;
    String nextOrderNoString = nextOrderNoInt.toString();
    Order order = Order(
      orderNo: nextOrderNoString,
      orderType: orderType,
      area: pendingArea,
    );
    pendingArea.addOrder(order, onCompleted);
    notifyBots();
  }

  // TODO: Follow Observer pattern if more complex notifications are needed later
  void notifyBots() {
    for (Bot bot in bots) {
      bot.notify();
    }
  }
}