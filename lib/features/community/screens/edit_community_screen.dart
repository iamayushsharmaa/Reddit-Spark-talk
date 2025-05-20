import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spark_talk_reddit/core/common/error_text.dart';
import 'package:spark_talk_reddit/core/common/loader.dart';
import 'package:spark_talk_reddit/core/constant/constants.dart';
import 'package:spark_talk_reddit/core/utils.dart';
import 'package:spark_talk_reddit/features/community/controller/community_controller.dart';
import 'package:spark_talk_reddit/responsive/responsive.dart';
import 'package:spark_talk_reddit/theme/pallete.dart';

import '../../../models/community_model.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;

  const EditCommunityScreen({super.key, required this.name});

  @override
  ConsumerState<EditCommunityScreen> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;
  Uint8List? bannerWebFile;
  Uint8List? profileWebFile;

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        bannerWebFile = res.files.first.bytes;
      } else {
        setState(() {
          bannerFile = File(res.files.first.path!);
        });
      }
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        profileWebFile = res.files.first.bytes;
      } else {
        setState(() {
          profileFile = File(res.files.first.path!);
        });
      }
    }
  }

  void save(Community community) {
    ref
        .read(communityControllerProvider.notifier)
        .editCommunity(
          profileFile: profileFile,
          bannerFile: bannerFile,
          webProfileFile: profileWebFile,
          webBannerFile: bannerWebFile,
          context: context,
          community: community,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    final currentTheme = ref.read(themeNotifierProvider);

    return ref
        .watch(getCommunityByNameProvider(widget.name))
        .when(
          data:
              (community) => Scaffold(
                backgroundColor: currentTheme.scaffoldBackgroundColor,
                appBar: AppBar(
                  title: const Text('Edit Community'),
                  centerTitle: false,
                  actions: [
                    TextButton(
                      onPressed: () => save(community),
                      child: Text('Save'),
                    ),
                  ],
                ),
                body:
                    isLoading
                        ? const Loader()
                        : Responsive(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 200,
                                  child: Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: selectBannerImage,
                                        child: DottedBorder(
                                          borderType: BorderType.RRect,
                                          radius: const Radius.circular(10),
                                          dashPattern: const [10, 4],
                                          strokeCap: StrokeCap.round,
                                          color:
                                              currentTheme
                                                  .textTheme
                                                  .bodyMedium!
                                                  .color!,
                                          child: Container(
                                            width: double.infinity,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child:
                                                bannerWebFile != null
                                                    ? Image.memory(
                                                      bannerWebFile!,
                                                    )
                                                    : bannerFile != null
                                                    ? Image.file(bannerFile!)
                                                    : community
                                                            .banner
                                                            .isEmpty ||
                                                        community.banner ==
                                                            Constants
                                                                .bannerDefault
                                                    ? const Center(
                                                      child: Icon(
                                                        Icons
                                                            .camera_alt_outlined,
                                                        size: 40,
                                                      ),
                                                    )
                                                    : Image.network(
                                                      community.banner,
                                                    ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 20,
                                        left: 20,
                                        child: GestureDetector(
                                          onTap: selectProfileImage,
                                          child:
                                              profileWebFile != null
                                                  ? CircleAvatar(
                                                    backgroundImage: MemoryImage(profileWebFile!),
                                                    radius: 32,
                                                  )
                                                  : profileFile != null
                                                  ? CircleAvatar(
                                                    backgroundImage: FileImage(profileFile!),
                                                    radius: 32,
                                                  )
                                                  : CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                          community.avatar,
                                                        ),
                                                    radius: 32,
                                                  ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
              ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
