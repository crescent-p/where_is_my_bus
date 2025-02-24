import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:where_is_my_bus/features/social/domain/entities/comments.dart';
import 'package:where_is_my_bus/features/social/domain/entities/post.dart';
import 'package:where_is_my_bus/features/social/domain/usecases/get_comments_usecase.dart';
import 'package:where_is_my_bus/features/social/presentation/blocs/comments_bloc/comments_bloc.dart';
import 'package:where_is_my_bus/features/social/presentation/blocs/social_bloc/social_bloc.dart';
import 'package:where_is_my_bus/init_dependencies.dart';

class PostPageWidget extends StatefulWidget {
  const PostPageWidget({Key? key, required this.postID}) : super(key: key);
  final String postID;
  @override
  State<PostPageWidget> createState() => _PostPageWidgetState();
}

class _PostPageWidgetState extends State<PostPageWidget> {
  final TextEditingController commentController = TextEditingController();

  List<Comments> postComments = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    serviceLocator<CommentsBloc>.call().add(
      FetchCommentsEvent(postID: widget.postID),
    );
    serviceLocator<SocialBloc>.call().add(
      FetchPostEvent(postID: widget.postID),
    );
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Post'),
        ),
        body: Column(
          children: [
            BlocBuilder<SocialBloc, SocialState>(
              builder: (context, state) {
                if (state is SocialStateInitial) {
                  return CircularProgressIndicator();
                } else if (state is SocialPostFetchedState) {
                  return postWidget(context, widget, state.post);
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            BlocBuilder<CommentsBloc, CommentsState>(
              builder: (context, state) {
                if (state is CommentsInitial) {
                  return CircularProgressIndicator();
                } else if (state is CommentsFetchedState) {
                  postComments = state.comments;
                  return commentsList(postComments);
                } else {
                  return commentsList(postComments);
                }
              },
            )
          ],
        ),
        bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final comment = commentController.text.trim();
                    if (comment.isNotEmpty) {
                      serviceLocator<SocialBloc>().add(PostCommentEvent(
                        uuid: widget.postID,
                        email: "currentUserEmail", // Replace with actual email
                      ));
                      print('Comment submitted: $comment');
                      commentController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget postWidget(context, widget, Post post) {
  return Container(
    height: 500,
    width: MediaQuery.of(context).size.width,
    child: GestureDetector(
      // When user taps outside, unfocus to dismiss keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          // Main post content wrapped in an Expanded scrollable area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post Heading
                  Text(
                    post.type ?? "Post Heading",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  // Display a photo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      post.highResImageUrl!,
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Post description
                  Text(
                    post.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  // Comments header
                  Text(
                    'Comments',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  // List of sample comments
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget commentsList(postComments) {
  if (postComments.isEmpty) {
    return Text("NO COMMENTS");
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: postComments.map((entry) {
      return ListTile(
        leading: CircleAvatar(child: Text(entry.userEmail[0])),
        title: Text(entry.userEmail),
        subtitle: Text(entry.text),
      );
    }).toList(),
  );
}
