import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gym_project/models/tuple.dart';
import 'package:gym_project/services/image-upload-web-service.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadViewModel with ChangeNotifier {
  String imagePath = '';
  bool status = false;

  Future<void> uploadImageFile(
      XFile image, String imageName, bool isOld) async {
    if (!isOld) {
      Tuple<bool, String> result =
          await ImageUploadWebService().uploadImage(image, imageName);

      status = result.item1;
      imagePath = result.item2;
    } else {
      imagePath = imageName;
    }

    // if (status == true) {
    //   imagePath = imageName;
    // }
    notifyListeners();
  }
}
