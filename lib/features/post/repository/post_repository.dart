import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spark_talk_reddit/core/constant/firestore_constants.dart';
import 'package:spark_talk_reddit/core/failure.dart';
import 'package:spark_talk_reddit/core/providers/firebase_providers.dart';
import 'package:spark_talk_reddit/core/type_defs.dart';

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

  FutureVoid addPost(Post post) async {
    try {
      return right(_post.doc(post.id).set(post.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
