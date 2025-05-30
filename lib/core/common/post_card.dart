import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:spark_talk_reddit/core/common/error_text.dart';
import 'package:spark_talk_reddit/core/common/loader.dart';
import 'package:spark_talk_reddit/core/constant/constants.dart';
import 'package:spark_talk_reddit/features/community/controller/community_controller.dart';
import 'package:spark_talk_reddit/features/post/controller/post_controller.dart';
import 'package:spark_talk_reddit/models/post_model.dart';
import 'package:spark_talk_reddit/responsive/responsive.dart';

import '../../features/auth/controller/auth_controller.dart';
import '../../theme/pallete.dart';

class PostCard extends ConsumerWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  void deletePost(WidgetRef ref, BuildContext context) {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  void upVotes(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void downVotes(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  void navigateToUser(BuildContext context) {
    Routemaster.of(context).push('/u/${post.uid}');
  }

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/u/${post.communityName}');
  }

  void navigateToComment(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  void awardPost(WidgetRef ref, String award, BuildContext context) {
    ref
        .read(postControllerProvider.notifier)
        .awardPost(post: post, award: award, context: context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Responsive(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: currentTheme.drawerTheme.backgroundColor,
            ),
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (kIsWeb)
                  Column(
                    children: [
                      IconButton(
                        onPressed: isGuest ? () {} : () => upVotes(ref),
                        icon: Icon(
                          Constants.up,
                          size: 30,
                          color:
                              post.upvotes.contains(user.uid)
                                  ? Pallete.redColor
                                  : null,
                        ),
                      ),
                      Text(
                        '${post.upvotes.length - post.downvotes.length == 0 ? 'Votes' : post.upvotes.length - post.downvotes.length}',
                        style: const TextStyle(fontSize: 17),
                      ),
                      IconButton(
                        onPressed: isGuest ? () {} : () => downVotes(ref),
                        icon: Icon(
                          Constants.down,
                          size: 30,
                          color:
                              post.downvotes.contains(user.uid)
                                  ? Pallete.blueColor
                                  : null,
                        ),
                      ),
                    ],
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 16,
                        ).copyWith(right: 0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => navigateToCommunity(context),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          post.communityProfilePic,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'r/${post.communityName}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap:
                                                () => navigateToUser(context),
                                            child: Text(
                                              'r/${post.username}',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (post.uid == user.uid)
                                  IconButton(
                                    onPressed: () => deletePost(ref, context),
                                    icon: Icon(
                                      Icons.delete,
                                      color: Pallete.redColor,
                                    ),
                                  ),
                              ],
                            ),
                            if (post.awards.isNotEmpty) ...[
                              const SizedBox(height: 5),
                              SizedBox(
                                height: 25,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: post.awards.length,
                                  itemBuilder: (context, index) {
                                    final award = post.awards[index];
                                    return Image.asset(
                                      Constants.awards[award]!,
                                      height: 23,
                                    );
                                  },
                                ),
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                post.title,
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isTypeImage)
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                width: double.infinity,
                                child: Image.network(
                                  post.link!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            if (isTypeLink)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                child: AnyLinkPreview(
                                  displayDirection:
                                      UIDirection.uiDirectionHorizontal,
                                  link: post.link!,
                                ),
                              ),
                            if (isTypeText)
                              Container(
                                alignment: Alignment.bottomLeft,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Text(
                                  post.description!,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (!kIsWeb)
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed:
                                            isGuest
                                                ? () {}
                                                : () => upVotes(ref),
                                        icon: Icon(
                                          Constants.up,
                                          size: 30,
                                          color:
                                              post.upvotes.contains(user.uid)
                                                  ? Pallete.redColor
                                                  : null,
                                        ),
                                      ),
                                      Text(
                                        '${post.upvotes.length - post.downvotes.length == 0 ? 'Votes' : post.upvotes.length - post.downvotes.length}',
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                      IconButton(
                                        onPressed:
                                            isGuest
                                                ? () {}
                                                : () => downVotes(ref),
                                        icon: Icon(
                                          Constants.down,
                                          size: 30,
                                          color:
                                              post.downvotes.contains(user.uid)
                                                  ? Pallete.blueColor
                                                  : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed:
                                          () => navigateToComment(context),
                                      icon: const Icon(Icons.comment),
                                    ),
                                    Text(
                                      '${post.upvotes.length - post.downvotes.length == 0 ? 'Votes' : post.upvotes.length - post.downvotes.length}',
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                  ],
                                ),
                                ref
                                    .watch(
                                      getCommunityByNameProvider(
                                        post.communityName,
                                      ),
                                    )
                                    .when(
                                      data: (data) {
                                        if (data.mods.contains(user.uid)) {
                                          return IconButton(
                                            onPressed:
                                                () => deletePost(ref, context),
                                            icon: Icon(
                                              Icons.admin_panel_settings,
                                            ),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                      error:
                                          (err, stack) =>
                                              ErrorText(error: err.toString()),
                                      loading: () => const Loader(),
                                    ),
                                IconButton(
                                  onPressed:
                                      isGuest
                                          ? () {}
                                          : () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          20,
                                                        ),
                                                    child: GridView.builder(
                                                      shrinkWrap: true,
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 4,
                                                          ),
                                                      itemCount:
                                                          user.awards.length,
                                                      itemBuilder: (
                                                        context,
                                                        index,
                                                      ) {
                                                        final award =
                                                            user.awards[index];
                                                        return GestureDetector(
                                                          onTap:
                                                              () => awardPost(
                                                                ref,
                                                                award,
                                                                context,
                                                              ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  8.0,
                                                                ),
                                                            child: Image.asset(
                                                              Constants
                                                                  .awards[award]!,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                  icon: Icon(Icons.card_giftcard_outlined),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
