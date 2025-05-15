import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:spark_talk_reddit/core/common/error_text.dart';
import 'package:spark_talk_reddit/core/common/loader.dart';
import 'package:spark_talk_reddit/features/community/controller/community_controller.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final Ref ref;

  SearchCommunityDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  void navigateToCommunityScreen(BuildContext context, String communityName) {
    Routemaster.of(context).push('/r/${communityName}');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref
        .watch(searchCommunityProvider(query))
        .when(
          data:
              (communities) => ListView.builder(
                itemCount: communities.length,
                itemBuilder: (BuildContext context, int index) {
                  final community = communities[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(community.avatar),
                    ),
                    title: Text("r/${community.name}"),
                    onTap: () {
                      navigateToCommunityScreen(context, community.name);
                    },
                  );
                },
              ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
