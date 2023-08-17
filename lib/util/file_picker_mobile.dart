import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'file_picker_stub.dart';


class FilePickerMobile implements FilePickerInterface {
  @override
  Future<List<File>> pickImages() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    return pickedFile != null ? [File(pickedFile.path)] : [];
  }

  @override
  Future<List<File>> pickVideos() async {
    final pickedFile = await ImagePicker().getVideo(source: ImageSource.gallery);
    return pickedFile != null ? [File(pickedFile.path)] : [];
  }
}
