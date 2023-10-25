import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:ilkvisual/services/storage_base.dart';

class FirebaseStrogeService implements StrogeBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  late Reference _storageReference;

  @override
  Future<String> uploadFile(
      String userID, String fileType, File yuklenecekdosya) async {
    _storageReference = _firebaseStorage.ref().child(userID).child(fileType);
    //var uploadTask = _storageReference.putFile(yuklenecekdosya);
    UploadTask uploadTask = _storageReference.putFile(yuklenecekdosya);
    var url = await uploadTask.then((a) => a.ref.getDownloadURL());

    //var url = (await uploadTask.whenComplete(() => null);
    return url;
  }
}
