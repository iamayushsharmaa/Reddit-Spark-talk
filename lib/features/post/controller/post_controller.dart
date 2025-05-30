import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:spark_talk_reddit/core/enums/enums.dart';
import 'package:spark_talk_reddit/core/utils.dart';
import 'package:spark_talk_reddit/features/auth/controller/auth_controller.dart';
import 'package:spark_talk_reddit/features/user_profile/controller/user_controller.dart';
import 'package:spark_talk_reddit/models/comment_model.dart';
import 'package:spark_talk_reddit/models/post_model.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/storage_repository.dart';
import '../../../models/community_model.dart';
import '../repository/post_repository.dart';

final postControllerProvider = StateNotifierProvider<PostController, bool>((
  ref,
) {
  final postRepository = ref.read(postRepositoryProvider);
  final storageRepository = ref.read(storageRepositoryProvider);
  return PostController(
    postRepository: postRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

final userPostsProvider = StreamProvider.family((ref, List<Community> communities,) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPost(communities);
});
final guestPostsProvider = StreamProvider((ref) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchGuestPost();
});

final getPostByIdProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostById(postId);
});

final getPostCommentProvider = StreamProvider.family((ref, String postId) {
  return ref.watch(postControllerProvider.notifier).getCommentsOfPost(postId);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  PostController({
    required PostRepository postRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  }) : _postRepository = postRepository,
       _storageRepository = storageRepository,
       _ref = ref,
       super(false);

  void shareTextPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String description,
  }) async {
    state = true;
    String postId = Uuid().v1();

    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postId,
      title: title,
      description: description,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      awards: [],
      link: null,
    );

    final res = await _postRepository.addPost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.textPost);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted Succesfully!');
      Routemaster.of(context).pop();
    });
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String link,
  }) async {
    state = true;
    String postId = Uuid().v1();

    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postId,
      title: title,
      link: link,
      description: null,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'link',
      createdAt: DateTime.now(),
      awards: [],
    );

    final res = await _postRepository.addPost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.linkPost);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted Succesfully!');
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required File? file,
    required Uint8List? webFile,
  }) async {
    state = true;
    String postId = Uuid().v1();

    final user = _ref.read(userProvider)!;
    final res = await _storageRepository.storeFile(
      path: 'post/${selectedCommunity.name}',
      id: postId,
      file: file,
      webFile: webFile,
    );

    res.fold((l) => showSnackBar(context, l.message), (r) async {
      final Post post = Post(
        id: postId,
        title: title,
        link: r,
        description: null,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: 'image',
        createdAt: DateTime.now(),
        awards: [],
      );

      final res = await _postRepository.addPost(post);
      _ref
          .read(userProfileControllerProvider.notifier)
          .updateUserKarma(UserKarma.imagePost);
      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Posted Succesfully!');
        Routemaster.of(context).pop();
      });
    });
  }

  Stream<List<Post>> fetchUserPost(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPost(communities);
    }
    return Stream.value([]);
  }

  Stream<List<Post>> fetchGuestPost() {
    return _postRepository.fetchGuestPost();
  }

  void deletePost(Post post, BuildContext context) async {
    final res = await _postRepository.deletePost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.deletePost);

    res.fold(
      (l) => null,
      (r) => showSnackBar(context, 'Post Deleted Successfully'),
    );
  }

  void upvote(Post post) async {
    final userId = _ref.watch(userProvider)!.uid;

    _postRepository.upvotePost(post, userId);
  }

  void downvote(Post post) async {
    final userId = _ref.watch(userProvider)!.uid;

    _postRepository.downvotePost(post, userId);
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

  void addComment({
    required BuildContext context,
    required String text,
    required Post post,
  }) async {
    final user = _ref.read(userProvider)!;
    String commentId = const Uuid().v1();
    Comment comment = Comment(
      id: commentId,
      text: text,
      createdAt: DateTime.now(),
      postId: post.id,
      uid: user.uid,
      username: user.name,
      profilePic: user.profilePic,
    );

    final res = await _postRepository.addComment(comment);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.comment);

    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  Stream<List<Comment>> getCommentsOfPost(String postId) {
    return _postRepository.getCommentsOfPost(postId);
  }

  void awardPost({
    required String award,
    required Post post,
    required BuildContext context,
  }) async {
    final user = _ref.read(userProvider)!;

    final res = await _postRepository.awardPost(post, award, user.uid);

    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref
          .read(userProfileControllerProvider.notifier)
          .updateUserKarma(UserKarma.awardPost);
      _ref.read(userProvider.notifier).update((state) {
        state?.awards.remove(award);
        return state;
      });
      Routemaster.of(context).pop();
    });
  }
}
