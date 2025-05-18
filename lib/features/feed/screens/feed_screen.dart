import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spark_talk_reddit/core/common/error_text.dart';
import 'package:spark_talk_reddit/core/common/loader.dart';
import 'package:spark_talk_reddit/core/common/post_card.dart';
import 'package:spark_talk_reddit/features/community/controller/community_controller.dart';
import 'package:spark_talk_reddit/features/post/controller/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(userCommunitiesProvider)
        .when(
          data:
              (communities) => ref
                  .watch(userPostsProvider(communities))
                  .when(
                    data: (data) {
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final post = data[index];
                          return PostCard(post: post);
                        },
                      );
                    },
                    error:
                        (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                    loading: () => const Loader(),
                  ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
