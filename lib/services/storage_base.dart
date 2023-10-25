import 'dart:io';

abstract class StrogeBase {
  Future<String> uploadFile(
      String userID, String fileType, File yuklenecekdosya);
}
