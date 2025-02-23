import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:where_is_my_bus/core/constants/constants.dart';
import 'package:where_is_my_bus/features/social/data/database/hive_object.dart';
import 'package:where_is_my_bus/features/social/domain/entities/comments.dart';
import 'package:where_is_my_bus/features/social/domain/entities/mini_post.dart';
import 'package:where_is_my_bus/features/social/domain/entities/post.dart';

/*
  Home page neeed miniposts. There should be 10 minipost from each section
  when clicked on view all all the posts with that heading should be displayed.

*/

abstract interface class HiveStorage {
  int storePosts(List<HivePost> posts);
  List<Post> retrievePosts(String uuid);
  int storeMiniPosts(List<HiveMiniPost> posts);
  //should contain minposts for each secction.
  Map<String, List<MiniPost>> retrieveMiniPosts(int startIndex, int count);
  List<MiniPost> retrieveSpecificMiniPost(
      String heading, int startIndex, int count);
  bool isAlreadyInDatabaseMiniPost(String uuid);
  bool isAlreadyInDatabasePost(String uuid);
  int storeComments(List<Comments> comments, String postId);
  List<Comments> getComments(String postId, int startIndex, int count);
}

class HiveStorageImpl implements HiveStorage {
  final HiveInterface hive;
  final SharedPreferences preferences;

  HiveStorageImpl({required this.hive, required this.preferences});

  @override
  int storePosts(List<HivePost> posts) {
    for (int i = 0; i < posts.length; i++) {
      int count = TOTAL_POST_COUNT - hive.box(posts[i].type).length;

      if (isAlreadyInDatabasePost(posts[i].uuid)) continue;

      hive.box(posts[i].type).put(count - i, posts[i]);

      hive.box(POSTS_SET).put(posts[i].uuid, true);
    }

    return 0;
  }

  //retrive the latest 10 posts from startIndex
  @override
  List<Post> retrievePosts(String uuid) {
    // List<Post> posts = [];
    // int postIndex = TOTAL_POST_COUNT - startIndex;
    // for (int i = 0; i < count; i++) {
    //   HivePost post = hive.box(heading).get(postIndex + i);
    //   posts.add(post.toPost());
    // }
    // return posts;
    throw UnimplementedError();
  }

  @override
  int storeMiniPosts(List<HiveMiniPost> posts) {
    for (int i = 0; i < posts.length; i++) {
      int count = TOTAL_POST_COUNT - hive.box("MINI ${posts[i].type}").length;
      if (isAlreadyInDatabaseMiniPost(posts[i].uuid)) continue;

      hive.box("MINI ${posts[i].type}").put(count - i, posts[i]);

      hive.box(MINI_POSTS_SET).put(posts[i].uuid, true);
    }
    return 0;
  }

  @override
  Map<String, List<MiniPost>> retrieveMiniPosts(int startIndex, int count) {
    Map<String, List<MiniPost>> posts = {};

    for (int j = 0; j < MINI_SECTIONS.length; j++) {
      int postIndex = TOTAL_POST_COUNT - startIndex;
      List<MiniPost> temp = [];
      for (int i = 0; i < count; i++) {
        HiveMiniPost post = hive.box(MINI_SECTIONS[j]).get(postIndex + i);
        temp.add(post.toMiniPost());
      }
      //dont want the mini part in the string. Purposelfully used sections instead of MINI_SECITONS
      posts[SECTIONS[j]] = temp;
    }
    return posts;
  }

  @override
  bool isAlreadyInDatabaseMiniPost(String uuid) {
    if (hive.box(MINI_POSTS_SET).containsKey(uuid)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  bool isAlreadyInDatabasePost(String uuid) {
    if (hive.box(POSTS_SET).containsKey(uuid)) {
      return true;
    } else {
      return false;
    }
  }

  //HACKISH : get all posts and offset by startindex and count
  @override
  List<MiniPost> retrieveSpecificMiniPost(
      String heading, int startIndex, int count) {
    List<MiniPost> posts = [];
    final box = hive.box(heading);
    for (int i = TOTAL_POST_COUNT - startIndex;
        i > TOTAL_POST_COUNT - startIndex - count;
        i++) {
      HiveMiniPost hiveMiniPost = box.get(i);
      posts.add(hiveMiniPost.toMiniPost());
    }
    return posts;
  }

  @override
  List<Comments> getComments(String postId, int startIndex, int count) {
    int index = TOTAL_POST_COUNT - hive.box(postId).length - startIndex;
    List<Comments> comments = [];
    for (int i = 0; i < count; i++) {
      comments.add(hive.box(postId).get(i + index));
    }
    return comments;
  }

  @override
  int storeComments(List<Comments> comments, String postId) {
    final box = hive.box(postId);
    int commentsSoFar = hive.box(postId).length;
    for (int i = 0; i < comments.length; i++) {
      box.put(TOTAL_POST_COUNT - commentsSoFar, comments[i]);
    }
    return 1;
  }
}
