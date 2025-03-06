import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:where_is_my_bus/core/theme/colors.dart';
import 'package:where_is_my_bus/features/social/domain/entities/comments.dart';
import 'package:where_is_my_bus/features/social/domain/entities/post.dart';
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
    super.initState();
    serviceLocator<SocialBloc>().add(
      FetchPostEvent(postID: widget.postID),
    );
    serviceLocator<CommentsBloc>().add(
      FetchCommentsEvent(postID: widget.postID),
    );
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: OGS_THEME.black,
        body: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<SocialBloc, SocialState>(
                builder: (context, state) {
                  if (state is SocialStateInitial) {
                    return Hero(
                      tag: widget.postID,
                      child: SizedBox(
                        height: screenHeight,
                        width: screenWidth,
                        child: Lottie.asset(
                          'assets/animations/list_loading_animation.json',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    );
                  } else if (state is SocialPostFetchedState) {
                    return postWidget(context, state.post);
                  } else {
                    return SizedBox(
                      height: screenHeight,
                      width: screenWidth,
                      child: Lottie.asset(
                        'assets/animations/list_loading_animation.json',
                        fit: BoxFit.fitWidth,
                      ),
                    );
                    ;
                  }
                },
              ),
              BlocListener<CommentsBloc, CommentsState>(
                listener: (context, state) {
                  if (state is CommentPostedState) {
                    postComments.insert(0, state.comment);
                    serviceLocator<CommentsBloc>()
                        .add(EmitFetchEvent(comments: postComments));
                  }
                },
                child: BlocBuilder<CommentsBloc, CommentsState>(
                  builder: (context, state) {
                    if (state is CommentsInitial) {
                      return Lottie.asset(
                        'assets/animations/list_loading_animation.json',
                        fit: BoxFit.fitWidth,
                      );
                    } else if (state is CommentsFetchedState) {
                      postComments = state.comments;
                      return commentsList(context, postComments);
                    } else {
                      return Lottie.asset(
                        'assets/animations/list_loading_animation.json',
                        fit: BoxFit.fitWidth,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: bottomCommentBar(),
      ),
    );
  }

  Widget bottomCommentBar() {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Colors.black,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: TextField(
                  cursorColor: OGS_THEME.blue,
                  controller: commentController,
                  decoration: InputDecoration(
                    fillColor: OGS_THEME.yellow,
                    filled: true,
                    focusColor: OGS_THEME.yellow,
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: OGS_THEME.yellow),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: OGS_THEME.yellow),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                final comment = commentController.text.trim();
                if (comment.isNotEmpty) {
                  serviceLocator<CommentsBloc>().add(PostCommentEvent(
                    postID: widget.postID,
                    text: comment,
                    email: GoogleSignIn().currentUser?.email ??
                        'unknown@gmail.com',
                  ));
                  commentController.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget postWidget(BuildContext context, Post post) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: widget.postID,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Image.network(
                      post.highResImageUrl!,
                      fit: BoxFit.cover,
                      height: 432,
                      width: double.infinity,
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: OGS_THEME.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        post.heading ?? "Event",
                        style: GoogleFonts.outfit(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: OGS_THEME.white,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.heading ?? "Event",
                    style: GoogleFonts.outfit(
                      color: OGS_THEME.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Event Timings",
                            style: GoogleFonts.outfit(
                              color: OGS_THEME.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: OGS_THEME.white,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                post.eventTiming!,
                                style: GoogleFonts.outfit(
                                  color: OGS_THEME.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 15),
                      const SizedBox(
                        height: 60,
                        child: VerticalDivider(
                          color: Colors.white,
                          thickness: 2.0,
                          width: 10,
                          indent: 5,
                          endIndent: 5,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Venue",
                            style: GoogleFonts.outfit(
                              color: OGS_THEME.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_pin,
                                size: 20,
                                color: OGS_THEME.white,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                post.venue!,
                                style: GoogleFonts.outfit(
                                  color: OGS_THEME.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    "Description",
                    style: GoogleFonts.outfit(
                      color: OGS_THEME.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    post.description,
                    style: GoogleFonts.outfit(
                      color: OGS_THEME.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Comments',
                    style: GoogleFonts.outfit(
                      color: OGS_THEME.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget commentsList(BuildContext context, List<Comments> postComments) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (postComments.isEmpty)
            Text(
              "     Add a comment to start the conversation...",
              style: GoogleFonts.outfit(
                color: OGS_THEME.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // Disable scrolling within the ListView
              itemCount: postComments.length,
              itemBuilder: (context, index) {
                final entry = postComments[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: OGS_THEME.yellow,
                    radius: 30,
                    child: Text(
                      entry.userEmail[0].toUpperCase(),
                      style: GoogleFonts.outfit(
                        color: OGS_THEME.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    entry.userEmail.trim(),
                    style: GoogleFonts.outfit(
                      color: OGS_THEME.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  subtitle: Text(
                    entry.text,
                    style: GoogleFonts.outfit(
                      color: OGS_THEME.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
