import 'dart:html' as html;

import 'file_uploader.dart';


class FileUploaderWeb implements FileUploader {
  @override
  Future<List<html.File>> pickImages() async {
    final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
    uploadInput.multiple = true;
    uploadInput.click();
    await uploadInput.onChange.first;
    return uploadInput.files ?? [];
  }

  @override
  Future<List<html.File>> pickVideos() async {
    final uploadInput = html.FileUploadInputElement()..accept = 'video/*';
    uploadInput.multiple = true;
    uploadInput.click();
    await uploadInput.onChange.first;
    return uploadInput.files ?? [];
  }
}
