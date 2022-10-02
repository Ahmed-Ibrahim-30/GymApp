import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class MyImagePicker2 extends StatefulWidget {
  const MyImagePicker2({Key key}) : super(key: key);

  @override
  _MyImagePicker2State createState() => _MyImagePicker2State();
}

class _MyImagePicker2State extends State<MyImagePicker2> {
  File image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: pickImage, child: Text('Choose Image')),
        if (image == null) FlutterLogo(size: 100),
        if (image != null && kIsWeb)
          Image.network(image.path, height: 160, width: 160),
        if (image != null && !kIsWeb)
          Image.file(image, height: 160, width: 160),
      ],
    );
  }
}
