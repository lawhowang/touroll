import 'dart:io';
import 'package:touroll/models/upload.dart';
import 'package:touroll/utils/http.dart';

class UploadService {
  Future<String> upload(File file) async {
    final res = await HttpUtils.postData('uploads', {});
    Upload upload = Upload.fromJson(res);
    await HttpUtils.upload(upload.uploadURL, file);
    final regexp = RegExp(r'.*\/(.*)\.jpg');
    final match = regexp.firstMatch(upload.uploadURL);
    final matchedText = match.group(1);
    return matchedText;
  }
}
