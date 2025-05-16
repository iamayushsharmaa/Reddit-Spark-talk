import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spark_talk_reddit/core/common/error_text.dart';
import 'package:spark_talk_reddit/core/common/loader.dart';
import 'package:spark_talk_reddit/features/auth/controller/auth_controller.dart';
import 'package:spark_talk_reddit/features/community/controller/community_controller.dart';

class AddModScreen extends ConsumerStatefulWidget {
  final String name;

  const AddModScreen({super.key, required this.name});

  @override
  ConsumerState createState() => _AddModScreenState();
}

class _AddModScreenState extends ConsumerState<AddModScreen> {
  Set<String> uids = {};
  int counter = 0;

  void addUids(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUids(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void saveMods() {
    ref
        .read(communityControllerProvider.notifier)
        .addMods(widget.name, uids.toList(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Mod'),
        actions: [
          IconButton(
              onPressed: () => saveMods(),
              icon: Icon(Icons.done)
          ),
        ],
      ),
      body: ref
          .watch(getCommunityByNameProvider(widget.name))
          .when(
            data:
                (community) => ListView.builder(
                  itemCount: community.members.length,
                  itemBuilder: (context, index) {
                    final member = community.members[index];
                    return ref
                        .watch(getUserDataProvider(member))
                        .when(
                          data: (user) {
                            if (community.mods.contains(member) &&
                                counter == 0) {
                              uids.add(member);
                            }
                            counter++;
                            return CheckboxListTile(
                              value: uids.contains(user.uid),
                              onChanged: (value) {
                                if (value!) {
                                  addUids(user.uid);
                                } else {
                                  removeUids(user.uid);
                                }
                              },
                              title: Text(member),
                            );
                          },
                          error:
                              (error, stackTrace) =>
                                  ErrorText(error: error.toString()),
                          loading: () => const Loader(),
                        );
                  },
                ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
