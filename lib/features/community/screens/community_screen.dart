import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:spark_talk_reddit/core/common/error_text.dart';
import 'package:spark_talk_reddit/core/common/loader.dart';
import 'package:spark_talk_reddit/features/auth/controller/auth_controller.dart';
import 'package:spark_talk_reddit/features/community/controller/community_controller.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;

  const CommunityScreen({super.key, required this.name});

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      body: ref
          .watch(getCommunityByNameProvider(name))
          .when(
            data:
                (community) => NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        expandedHeight: 150,
                        floating: true,
                        snap: true,
                        flexibleSpace: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                community.banner,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            Align(
                              alignment: Alignment.topLeft,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(community.avatar),
                                radius: 35,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'r/${community.name}',
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                community.mods.contains(user.uid)
                                    ? OutlinedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 25,
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: Text('Mod tools'),
                                    )
                                    : OutlinedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 25,
                                        ),
                                      ),
                                      onPressed: () {
                                        navigateToModTools(context);
                                      },
                                      child: Text(
                                        community.members.contains(user.uid)
                                            ? 'Joined'
                                            : 'Join',
                                      ),
                                    ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                '${community.members.length} members',
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ];
                  },
                  body: const Text('Displaying posts'),
                ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
