import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../../core/abstracts/abstracts.dart';
import '../../core/core.dart';

class FirebaseStorageUploader {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final String path;
  final Uint8List bytes;
  final SettableMetadata? meta;

  FirebaseStorageUploader({
    required this.path,
    required this.bytes,
    this.meta,
  });

  Future<Either<Failure, String>> upload() async {
    try {
      final task = await _storage.ref(path).putData(bytes, meta);
      return Right(await task.ref.getDownloadURL());
    } catch (e) {
      print(e);
      return Left(
        BaseGeneralFailure(message: e.toString(), actualException: e),
      );
    }
  }
}
