import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:spark_talk_reddit/core/constant/constants.dart';
import 'package:spark_talk_reddit/core/providers/storage_repository.dart';
import 'package:spark_talk_reddit/core/utils.dart';
import 'package:spark_talk_reddit/features/auth/controller/auth_controller.dart';
import 'package:spark_talk_reddit/features/community/repository/community_repository.dart';
import 'package:spark_talk_reddit/models/community_model.dart';

final userCommunitiesProvider = StreamProvider((ref) {
  final communitiesController = ref.watch(communityControllerProvider.notifier);
  return communitiesController.getUserCommunities();
});

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>((ref) {
      final communityRepository = ref.read(communityRepositoryProvider);
      final storageRepository = ref.read(storageRepositoryProvider);
      return CommunityController(
        communityRepository: communityRepository,
        storageRepository: storageRepository,
        ref: ref,
      );
    });

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  CommunityController({
    required CommunityRepository communityRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  }) : _communityRepository = communityRepository,
       _storageRepository = storageRepository,
       _ref = ref,
       super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );

    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Community created successfully');
      Routemaster.of(context).pop();
    });
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  Stream<List<Community>> getUserCommunities() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getUserCommunity(uid);
  }

  void editCommunity({
    required File? profileFile,
    required File? bannerFile,
    required BuildContext context,
    required Community community,
  }) async {
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'communities/profile',
        id: community.id,
        file: profileFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => community.copyWith(avatar: r),
      );
    }
    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'communities/banner',
        id: community.id,
        file: bannerFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => community.copyWith(banner: r),
      );
    }

    final res = await _communityRepository.editCommunity(community);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }
}
