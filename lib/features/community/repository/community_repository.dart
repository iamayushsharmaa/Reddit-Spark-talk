import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spark_talk_reddit/core/constant/firestore_constants.dart';
import 'package:spark_talk_reddit/core/failure.dart';
import 'package:spark_talk_reddit/core/providers/firebase_providers.dart';
import 'package:spark_talk_reddit/core/type_defs.dart';
import 'package:spark_talk_reddit/models/community_model.dart';

final communityRepositoryProvider = Provider(
  (ref) => CommunityRepository(
      firestore: ref.read(firestoreProvider)
  ),
);

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  FutureVoid createCommunity(Community community) async {
    try {
      final communityDoc = await _communities.doc(community.name).get();
      if (communityDoc.exists) {
        throw 'Community with the same name already exists';
      }
      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunity(String uid){
    return _communities.where('members', arrayContains: uid).snapshots().map((event) {
      List<Community> communities = [];
      for(var doc in event.docs){
        communities.add(Community.fromMap(doc.data() as Map<String, dynamic>));
      }
      return communities;
    },);
  }

  CollectionReference get _communities => _firestore.collection(FirebaseConstant.communityCollection);
}
