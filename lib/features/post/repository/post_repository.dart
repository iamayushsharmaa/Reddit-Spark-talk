import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spark_talk_reddit/core/constant/firestore_constants.dart';
import 'package:spark_talk_reddit/core/failure.dart';
import 'package:spark_talk_reddit/core/providers/firebase_providers.dart';
import 'package:spark_talk_reddit/core/type_defs.dart';
import 'package:spark_talk_reddit/models/comment_model.dart';

import '../../../models/community_model.dart';
import '../../../models/post_model.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.read(firestoreProvider));
});

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  CollectionReference get _post =>
      _firestore.collection(FirebaseConstant.postCollection);

  CollectionReference get _comment =>
      _firestore.collection(FirebaseConstant.commentsCollection);

  CollectionReference get _user =>
      _firestore.collection(FirebaseConstant.userCollection);

  FutureVoid addPost(Post post) async {
    try {
      return right(_post.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchUserPost(List<Community> communities) {
    return _post
        .where(
          'communityName',
          whereIn: communities.map((e) => e.name).toList(),
        )
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) =>
              event.docs
                  .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
                  .toList(),
        );
  }

  Stream<List<Post>> fetchGuestPost() {
    return _post
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .map(
          (event) =>
              event.docs
                  .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
                  .toList(),
        );
  }

  FutureVoid deletePost(Post post) async {
    try {
      return right(_post.doc(post.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void upvotePost(Post post, String userId) async {
    if (post.downvotes.contains(userId)) {
      _post.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    }
    if (post.upvotes.contains(userId)) {
      _post.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _post.doc(post.id).update({
        'upvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  void downvotePost(Post post, String userId) async {
    if (post.upvotes.contains(userId)) {
      _post.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    }
    if (post.downvotes.contains(userId)) {
      _post.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _post.doc(post.id).update({
        'downvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  Stream<Post> getPostById(String postId) {
    return _post
        .doc(postId)
        .snapshots()
        .map((event) => Post.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid addComment(Comment comment) async {
    try {
      await _comment.doc(comment.id).set(comment.toMap());
      return right(
        _post.doc(comment.postId).update({
          'commentCount': FieldValue.increment(1),
        }),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Comment>> getCommentsOfPost(String postId) {
    return _comment
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) =>
              event.docs
                  .map((e) => Comment.fromMap(e.data() as Map<String, dynamic>))
                  .toList(),
        );
  }

  FutureVoid awardPost(Post post, String award, String senderId) async {
    try {
      _post.doc(post.id).update({
        'awards': FieldValue.arrayUnion([award]),
      });

      _user.doc(senderId).update({
        'awards': FieldValue.arrayRemove([award]),
      });
      return right(
        _user.doc(post.uid).update({
          'awards': FieldValue.arrayUnion([award]),
        }),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
