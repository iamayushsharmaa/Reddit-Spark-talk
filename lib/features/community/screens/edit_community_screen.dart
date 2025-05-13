import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spark_talk_reddit/core/common/error_text.dart';
import 'package:spark_talk_reddit/core/common/loader.dart';
import 'package:spark_talk_reddit/core/constant/constants.dart';
import 'package:spark_talk_reddit/features/community/controller/community_controller.dart';
import 'package:spark_talk_reddit/theme/pallete.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;

  const EditCommunityScreen({super.key, required this.name});

  @override
  ConsumerState<EditCommunityScreen> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return ref
        .watch(getCommunityByNameProvider(widget.name))
        .when(
          data:
              (community) => Scaffold(
                backgroundColor:
                    Pallete.darkModeAppTheme.scaffoldBackgroundColor,
                appBar: AppBar(
                  title: const Text('Edit Community'),
                  centerTitle: false,
                  actions: [TextButton(onPressed: () {}, child: Text('Save'))],
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: Stack(
                          children: [
                            DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(10),
                              dashPattern: const [10, 4],
                              strokeCap: StrokeCap.round,
                              color:
                                  Pallete
                                      .darkModeAppTheme
                                      .textTheme
                                      .bodyMedium!
                                      .color!,
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child:
                                    community.banner.isEmpty ||
                                            community.banner ==
                                                Constants.bannerDefault
                                        ? const Center(
                                          child: Icon(
                                            Icons.camera_alt_outlined,
                                            size: 40,
                                          ),
                                        )
                                        : Image.network(community.banner),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(community.avatar),
                                radius: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
