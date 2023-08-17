import 'dart:async';
import 'dart:html' as html;

import 'file_picker_stub.dart';

class FilePickerWeb implements FilePickerInterface {
  @override
  Future<List<html.File>> pickImages() {
    return _pickFiles(accept: 'image/*');
  }

  @override
  Future<List<html.File>> pickVideos() {
    return _pickFiles(accept: 'video/*');
  }

  Future<List<html.File>> _pickFiles({required String accept}) {
    final completer = Completer<List<html.File>>();
    final input = html.FileUploadInputElement()..accept = accept;
    input.multiple = true;
    input.click();
    input.onChange.listen((e) {
      final files = input.files!.toList();
      completer.complete(files);
    });
    input.onError.listen((e) => completer.completeError(e));
    return completer.future;
  }
}