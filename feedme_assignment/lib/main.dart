import 'package:flutter/material.dart';
import 'domain/bot.dart';
import 'domain/order.dart';
import 'domain/restaurant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "McDonald's (powered by FeedMe)",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: "McDonald's (powered by FeedMe)"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
          // Bots
          Text("BOTS"),
          Expanded(
            child: ListView.builder(
              itemCount: bots.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: bots[index].order == null
                            ? Text('Bot not processing order')
                            : Text(
                                'Bot processing order ${bots[index].order?.orderNo} ${bots[index].order?.orderType.name}',
                              ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _removeBot(bots[index]);
                      },
                      child: Text("Remove bot"),
                    ),
                  ],
                );
              },
            ),
          ),

          // Pending Area
          Text("PENDING AREA"),
          Expanded(
            child: ListView.builder(
              itemCount: pendingOrders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    'Pending Order ${pendingOrders[index].orderNo} ${pendingOrders[index].orderType.name} (${pendingOrders[index].state.name})',
                  ),
                );
              },
            ),
          ),

          // Completed Area
          Text("COMPLETED AREA"),
          Expanded(
            child: ListView.builder(
              itemCount: completedOrders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    'Completed Order ${completedOrders[index].orderNo} ${completedOrders[index].orderType.name}',
                  ),
                );
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
            child: Text("Add bot"),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              _addOrder(OrderType.normal);
            },
            child: Text("Add normal order"),
          ),
          SizedBox(height: 10), // spacing
          FloatingActionButton(
            onPressed: () {
              _addOrder(OrderType.vip);
            },
            child: Text("Add VIP order"),
          ),
          SizedBox(height: 10), // sp
        ],
      ),
    );
  }
}
