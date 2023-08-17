import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'file_uploader.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


class FileUploaderMobile implements FileUploader {
  final picker = ImagePicker();

  @override
  Future<List<File>> pickImages() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return [File(pickedFile.path)];
    } else {
      return [];
    }
  }

  @override
  Future<List<File>> pickVideos() async {
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      return [File(pickedFile.path)];
    } else {
      return [];
    }
  }
}
