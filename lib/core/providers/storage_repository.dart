import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:spark_talk_reddit/core/failure.dart';
import 'package:spark_talk_reddit/core/providers/firebase_providers.dart';

import '../type_defs.dart';

final storageRepositoryProvider = Provider((ref) =>
    StorageRepository(firebaseStorage: ref.read(storageProvider))
);

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({required FirebaseStorage firebaseStorage})
    : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File? file,
    required Uint8List? webFile
  }) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);

      UploadTask uploadTask;

      if(webFile != null){
        uploadTask = ref.putData(webFile);
      } else{
        uploadTask = ref.putFile(file!);
      }
      final snapshot = await uploadTask;

      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
