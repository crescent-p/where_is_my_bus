import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:where_is_my_bus/features/social/data/data_source/social_remote_datasource.dart';
import 'package:where_is_my_bus/features/social/domain/entities/mini_post.dart';
import 'package:where_is_my_bus/features/social/domain/usecases/get_mini_posts_usecase.dart';
import 'package:where_is_my_bus/features/social/presentation/blocs/social_bloc/social_bloc.dart';
import 'package:where_is_my_bus/features/social/presentation/pages/post_page.dart';

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
    context.read<SocialBloc>().add(GetMiniPostsEvent(limit: 10));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlocListener<SocialBloc, SocialState>(
              listener: (context, state) {
                if (state is SocialStateInitial) {
                  const CircularProgressIndicator();
                } else if (state is SocialStateLoaded) {
                  Map<String, List<MiniPost>> posts = state.posts;
                  Column(
                    children: posts.entries.map((entry) {
                      return _buildSection(
                        context,
                        title: entry.key,
                        items: entry.value,
                      );
                    }).toList(),
                  );
                }
              },
              child: BlocBuilder<SocialBloc, SocialState>(
                  builder: (context, state) {
                if (state is SocialStateLoaded) {
                  Map<String, List<MiniPost>> posts = state.posts;
                  return SingleChildScrollView(
                    child: Column(
                      children: posts.entries.map((entry) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                SocialRemoteDataSource source =
                                    SocialRemoteDataSourceImple();
                                source.getComments("hi");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PostPageWidget(postID: "df"),
                                  ),
                                );
                              },
                              child: _buildSection(
                                context,
                                title: entry.key,
                                items: entry.value,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                }
                return CircularProgressIndicator();
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required List<MiniPost> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () {
                  SocialRemoteDataSource source = SocialRemoteDataSourceImple();
                  source.getComments("hi");
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
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
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
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.description,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
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
