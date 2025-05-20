import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spark_talk_reddit/features/auth/controller/auth_controller.dart';
import 'package:spark_talk_reddit/features/user_profile/controller/user_controller.dart';
import 'package:spark_talk_reddit/responsive/responsive.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/constant/constants.dart';
import '../../../core/utils.dart';
import '../../../theme/pallete.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;

  const EditProfileScreen({super.key, required this.uid});

  @override
  ConsumerState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;
  Uint8List? webBannerFile;
  Uint8List? webProfileFile;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      if (webBannerFile != null) {
        setState(() {
          webBannerFile = res.files.first.bytes;
        });
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
      if (webProfileFile != null) {
        setState(() {
          webProfileFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          profileFile = File(res.files.first.path!);
        });
      }
    }
  }

  void save() {
    ref
        .read(userProfileControllerProvider.notifier)
        .editProfile(
          profileFile: profileFile,
          bannerFile: bannerFile,
          webProfileFile: webProfileFile,
          webBannerFile: webBannerFile,
          context: context,
          name: nameController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.read(themeNotifierProvider);
    return ref
        .watch(getUserDataProvider(widget.uid))
        .when(
          data:
              (user) => Scaffold(
                backgroundColor: currentTheme.scaffoldBackgroundColor,
                appBar: AppBar(
                  title: const Text('Edit Profile'),
                  centerTitle: false,
                  actions: [TextButton(onPressed: () {}, child: Text('Save'))],
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
                                                webBannerFile != null
                                                    ? Image.memory(
                                                      webBannerFile!,
                                                    )
                                                    : bannerFile != null
                                                    ? Image.file(bannerFile!)
                                                    : user.banner.isEmpty ||
                                                        user.banner ==
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
                                                      user.banner,
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
                                              webProfileFile != null
                                                  ? Image.memory(webProfileFile!,)
                                                  : profileFile != null
                                                  ? CircleAvatar(
                                                    backgroundImage: FileImage(
                                                      profileFile!,
                                                    ),
                                                    radius: 32,
                                                  )
                                                  : CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                          user.profilePic,
                                                        ),
                                                    radius: 32,
                                                  ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    hintText: 'Name',
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(18),
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
