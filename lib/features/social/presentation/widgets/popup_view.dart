import 'package:flutter/material.dart';
import 'package:where_is_my_bus/features/social/domain/entities/post.dart';

class PopViewPage extends StatefulWidget {
  final String heading;
  PopViewPage({super.key, required this.heading});
  @override
  State<PopViewPage> createState() => _PopViewPageState();
}

class _PopViewPageState extends State<PopViewPage> {
  final int selected = -1;
  @override
  Widget build(BuildContext context) {
    if (selected == -1) {
      return listView([]);
    } else {
      return selectedView();
    }
  }
}

Widget listView(List<Post> posts) {
  return Padding(padding: EdgeInsets.all(3));
}

Widget selectedView() {
  return Container(
    height: 100,
    width: 100,
    padding: EdgeInsetsGeometry.infinity,
    child: const Text("data"),
  );
}
