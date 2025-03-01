import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frosted_glass_effect/frosted_glass_effect.dart';
import 'package:rive/rive.dart' as Rive;
import 'package:where_is_my_bus/features/social/data/data_source/social_remote_datasource.dart';
import 'package:where_is_my_bus/features/social/domain/entities/mini_post.dart';
import 'package:where_is_my_bus/features/social/presentation/blocs/comments_bloc/comments_bloc.dart';
import 'package:where_is_my_bus/features/social/presentation/blocs/mini_posts_bloc/mini_posts_bloc.dart';
import 'package:where_is_my_bus/features/social/presentation/pages/post_page.dart';
import 'package:where_is_my_bus/init_dependencies.dart';

class SocailPageWidget extends StatefulWidget {
  final Map<String, List<MiniPost>> items;
  const SocailPageWidget({Key? key, required this.items}) : super(key: key);

  static String routeName = 'socail_page';
  static String routePath = '/socailPage';

  @override
  State<SocailPageWidget> createState() => _SocailPageWidgetState();
}

class _SocailPageWidgetState extends State<SocailPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    context.read<MiniPostsBloc>().add(GetMiniPostsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BlocListener<MiniPostsBloc, MiniPostsState>(
                listener: (context, state) {
                  // if (state is SocialStateInitial) {
                  //   const CircularProgressIndicator();
                  // } else if (state is SocialStateLoaded) {
                  //   Map<String, List<MiniPost>> posts = state.posts;
                  //   Column(
                  //     children: posts.entries.map((entry) {
                  //       return _buildSection(
                  //         context,
                  //         title: entry.key,
                  //         items: entry.value,
                  //       );
                  //     }).toList(),
                  //   );
                  // }
                },
                child: BlocBuilder<MiniPostsBloc, MiniPostsState>(
                    builder: (context, state) {
                  if (state is MiniPostsLoadedState) {
                    Map<String, List<MiniPost>> posts = state.posts;
                    return SingleChildScrollView(
                      child: Column(
                        children: posts.entries.map((entry) {
                          return Column(
                            children: [
                              //profile -> Hello, name , notification
                              //Goodmorning
                              //search bar
                              //facilities near you
                              // Profile section
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Hello, User!',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      Text(
                                        'Good morning',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.notifications),
                                    onPressed: () {
                                      // Handle notification tap
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Search bar
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search...',
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Facilities near you
                              Text(
                                'Facilities near you',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              _buildSection(
                                context,
                                title: entry.key,
                                items: entry.value,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                }),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required List<MiniPost> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassContainer(
          radius: 10,
          widget: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 300,
          child: ListView.separated(
            physics: ClampingScrollPhysics(),
            // shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostPageWidget(postID: item.uuid),
                    ),
                  );
                },
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(children: [
                      Container(),
                      ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.lowResImageUrl!,
                                width: double.infinity,
                                height: 220,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
