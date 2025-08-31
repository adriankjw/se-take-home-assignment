import 'package:flutter/material.dart';
import 'view_bot_list_item.dart';
import 'view_completed_order_list_item.dart';
import 'view_order_list_item.dart';
import '../domain/bot.dart';
import '../domain/order.dart';
import '../domain/restaurant.dart';

class ViewRestaurant extends StatelessWidget {
  const ViewRestaurant({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "McDonald's (powered by FeedMe)",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
      ),
      home: const ViewRestaurantState(title: "McDonald's (powered by FeedMe)"),
    );
  }
}

class ViewRestaurantState extends StatefulWidget {
  const ViewRestaurantState({super.key, required this.title});

  final String title;

  @override
  State<ViewRestaurantState> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ViewRestaurantState> {
  late Restaurant restaurant = Restaurant(onCompleted: redrawUICallback);
  List<Bot> get bots => restaurant.bots;
  List<Order> get pendingOrders => restaurant.pendingArea.orders;
  List<Order> get completedOrders => restaurant.completeArea.orders;

  void _addBot() {
    setState(() {
      restaurant.addBot();
    });
  }

  void _removeBot(Bot bot) {
    setState(() {
      restaurant.removeBot(bot);
    });
  }

  void _addOrder(OrderType orderType) {
    setState(() {
      restaurant.addOrder(orderType);
    });
  }

  // TODO: Use state management library or ChangeNotifier. Did not implement here to avoid dependencies and keep things simple.
  void redrawUICallback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Text("BOTS"),
          Expanded(
            child: ListView.builder(
              itemCount: bots.length,
              itemBuilder: (context, index) {
                return BotListItem(
                  bot: bots[index],
                  onRemove: () => _removeBot(bots[index]),
                );
              },
            ),
          ),
          Text("PENDING AREA"),
          Expanded(
            child: ListView.builder(
              itemCount: pendingOrders.length,
              itemBuilder: (context, index) {
                return OrderListItem(order: pendingOrders[index]);
              },
            ),
          ),
          Text("COMPLETED AREA"),
          Expanded(
            child: ListView.builder(
              itemCount: completedOrders.length,
              itemBuilder: (context, index) {
                return CompletedOrderListItem(order: completedOrders[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              _addBot();
            },
            child: Center(child: Text(
              "Add bot",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              _addOrder(OrderType.normal);
            },
            child: Text(
              "Add normal order",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 10), // spacing
          FloatingActionButton(
            onPressed: () {
              _addOrder(OrderType.vip);
            },
            child: Center(child: Text(
              "Add VIP order",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),),
          ),
          SizedBox(height: 10), // sp
        ],
      ),
    );
  }
}
