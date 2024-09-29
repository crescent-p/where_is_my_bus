import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:where_is_my_bus/core/entities/user.dart' as myUser;

class BusListPage extends StatefulWidget {
  final myUser.User user;
  const BusListPage({super.key, required this.user});
  static route(myUser.User user) =>
      MaterialPageRoute(builder: (context) => BusListPage(user: user));
  @override
  State<BusListPage> createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Text("{user.name}"),
    );
  }
}
