import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spark_talk_reddit/models/user_model.dart';

import '../../../core/constant/firestore_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/type_defs.dart';
import '../../../models/community_model.dart';

final userProfileRepositoryProvider = Provider(
      (ref) => UserProfileRepository(firestore: ref.read(firestoreProvider)),
);

class UserProfileRepository{
  final FirebaseFirestore _firestore;

  UserProfileRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstant.userCollection);


  FutureVoid editProfile(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

}