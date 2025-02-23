import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:where_is_my_bus/features/social/domain/entities/post.dart';

class PostPage extends StatefulWidget {
  final Post post;

  const PostPage({super.key, required this.post});
  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(widget.post.type),
          Image.network(widget.post.highResImageUrl!),
          Text(widget.post.description),
          // StreamBuilder(stream: stream, builder: builder)
        ],
      ),
    );
  }
}
