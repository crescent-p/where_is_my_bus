import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:where_is_my_bus/core/common/widgets/cicular_loading_animation.dart';
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
          CachedNetworkImage(
            imageUrl: widget.post.highResImageUrl!,
            placeholder: (context, url) => CircularLoadingScreen(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Text(widget.post.description),
          // StreamBuilder(stream: stream, builder: builder)
        ],
      ),
    );
  }
}
