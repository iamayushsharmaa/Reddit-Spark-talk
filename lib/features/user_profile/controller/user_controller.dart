import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:spark_talk_reddit/core/enums/enums.dart';
import 'package:spark_talk_reddit/features/auth/controller/auth_controller.dart';

import '../../../core/providers/storage_repository.dart';
import '../../../core/utils.dart';
import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import '../repository/user_repository.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
      final userProfileRepository = ref.read(userProfileRepositoryProvider);
      final storageRepository = ref.read(storageRepositoryProvider);
      return UserProfileController(
        userProfileRepository: userProfileRepository,
        storageRepository: storageRepository,
        ref: ref,
      );
    });

final getUserPostsProvider = StreamProvider.family((ref, String uid) {
  return ref.read(userProfileControllerProvider.notifier).getUserPosts(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  }) : _userRepository = userProfileRepository,
       _storageRepository = storageRepository,
       _ref = ref,
       super(false);

  void editProfile({
    required File? profileFile,
    required File? bannerFile,
    required Uint8List? webProfileFile,
    required Uint8List? webBannerFile,
    required BuildContext context,
    required String name,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;

    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/profile',
        id: user.uid,
        file: profileFile,
        webFile: webProfileFile
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user.copyWith(profilePic: r),
      );
    }
    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/banner',
        id: user.uid,
        file: bannerFile,
        webFile: webBannerFile
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user.copyWith(banner: r),
      );
    }

    user = user.copyWith(name: name);
    final res = await _userRepository.editProfile(user);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => user);
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _userRepository.getUserPosts(uid);
  }

  void updateUserKarma(UserKarma karma) async {
    UserModel user = _ref.read(userProvider)!;

    user = user.copyWith(karma: user.karma + karma.karma);
    final res = await _userRepository.updateUserKarma(user);

    res.fold((l) => null, (r) {
      _ref.read(userProvider.notifier).update((state) => user);
    });
  }
}
