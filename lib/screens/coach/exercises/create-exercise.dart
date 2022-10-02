import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gym_project/models/admin-models/equipments/equipment-model.dart';
import 'package:gym_project/models/exercise.dart';
import 'package:gym_project/style/error-pop-up.dart';
import 'package:gym_project/style/success-pop-up.dart';
import 'package:gym_project/viewmodels/equipment-view-model.dart';
import 'package:gym_project/viewmodels/exercise-list-view-model.dart';
import 'package:gym_project/viewmodels/image-upload-view-model.dart';
import 'package:gym_project/widget/form-widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../../all_data.dart';
import '../../../constants.dart';

EquipmentViewModel selectedEquipment;

class CreateExerciseForm extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

//you can change the form heading from line 51,93
//you can change the form fields from lines (119 ,138 , etc ) -> each padding represent a field
class MapScreenState extends State<CreateExerciseForm>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  XFile _imageFile;
  XFile _gifFile;
  final ImagePicker _picker = ImagePicker();

  Exercise _exercise = Exercise();
  bool status = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController repetitionsController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();

  bool emptyImage = false;
  bool emptyGIF = false;
  bool emptyEquipment = false;
  String equipmentName='';

  @override
  void didChangeDependencies() {
    exerciseListViewModel = Provider.of<ExerciseListViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  refresh() {
    setState(() {});
  }

  bool saveExercise(XFile image, String imageName, XFile gif, String gifName) {
    setState(() {
      Provider.of<ImageUploadViewModel>(context, listen: false)
          .uploadImageFile(image, imageName, false)
          .then((value) {
        _exercise.image =
            Provider.of<ImageUploadViewModel>(context, listen: false).imagePath;
        return Provider.of<ImageUploadViewModel>(context, listen: false)
            .uploadImageFile(gif, gifName, false);
      }).then((value) {
        _exercise.gif =
            Provider.of<ImageUploadViewModel>(context, listen: false).imagePath;
        return Provider.of<ExerciseListViewModel>(context, listen: false)
            .postExercise(
          _exercise,
        );
      }).then((value) {
        showSuccessMessage(context, 'Exercise created successfully!');
      }).catchError((err) {
        showErrorMessage(context, 'Failed to create exercise! $err');
        print('error occured $err');
      });
    });
    return true;
  }

  // Future<bool> saveImageFile() {
  //   Provider.of<ImageUploadViewModel>(context, listen: false)
  //       .uploadImageFile(image, imageName)
  //       .then((value) {
  //     _exercise.image =
  //         Provider.of<ImageUploadViewModel>(context, listen: false).imagePath;
  //     return Future.value(true);
  //   }).catchError((err) {
  //     print('error found while saving image $err');
  //     showErrorMessage(context, 'Failed to upload image!');
  //     throw Exception('failed');
  //   });
  // }

  // Future<bool> saveGIFFile(XFile gif, String gifName) {
  //   Provider.of<ImageUploadViewModel>(context, listen: false)
  //       .uploadImageFile(gif, gifName)
  //       .then((value) {
  //     _exercise.gif =
  //         Provider.of<ImageUploadViewModel>(context, listen: false).imagePath;
  //     return Future.value(true);
  //   }).catchError((err) {
  //     print('error found while saving gif $err');
  //     showErrorMessage(context, 'Failed to upload image!');
  //     throw Exception('failed');
  //   });
  // }

  Widget imageProfile(String imageType) {
    ImageProvider backgroundImage;
    if (imageType == 'image') {
      if (_imageFile == null)
        backgroundImage = AssetImage("assets/images/as.png");
      else if (kIsWeb)
        backgroundImage = NetworkImage(_imageFile.path);
      else
        backgroundImage = FileImage(File(_imageFile.path));
    } else if (imageType == 'gif') {
      if (_gifFile == null)
        backgroundImage = AssetImage("assets/images/as.png");
      else if (kIsWeb)
        backgroundImage = NetworkImage(_gifFile.path);
      else
        backgroundImage = FileImage(File(_gifFile.path));
    }
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(radius: 80.0, backgroundImage: backgroundImage),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet(imageType)),
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.3),
              child: Icon(
                Icons.camera_alt,
                color: Colors.teal,
                size: 28.0,
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget bottomSheet(String imageType) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera, imageType);
                Navigator.of(context).pop();
              },
              label: Text("Camera"),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery, imageType);
                Navigator.of(context).pop();
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source, String imageType) async {
    // ignore: deprecated_member_use
    final pickedFile = await _picker.pickImage(
      source: source,
    );
    // File finalFile = File(pickedFile.path);
    setState(() {
      if (imageType == 'image')
        _imageFile = pickedFile;
      else if (imageType == 'gif') _gifFile = pickedFile;
    });
  }

  var exerciseListViewModel;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SafeArea(
        child: new Container(
          color: Color(0xFF181818), //background color
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  PageTitle('Create Exercise'),
                  new Container(
                    //height: 1000.0,
                    constraints: new BoxConstraints(minHeight: 500),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),

                    //color: Colors.white,
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Padding(
                      //padding: EdgeInsets.only(bottom: 30.0),
                      padding: EdgeInsets.all(30),
                      child: Form(
                        key: _formKey,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            FormTitle('Exercise Information'),

                            FieldTitle('Description'),
                            CustomTextFieldWidget(descriptionController,
                                "Enter your description"),
                            FieldTitle('Duration'),
                            CustomTextFieldWidget(
                                durationController, "Enter duration h:m:s"),
                            FieldTitle('Title'),
                            CustomTextFieldWidget(
                                titleController, "Enter your title"),
                            FieldTitle('GIF'),
                            if (emptyGIF)
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Center(
                                          child: new Text(
                                            'Insert GIF',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      imageProfile('gif'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            FieldTitle('Repetitions'),
                            CustomNumericalTextField(
                                controller: repetitionsController,
                                hintText: "Enter number of reps"),
                            FieldTitle('Calories'),
                            CustomNumericalTextField(
                                controller: caloriesController,
                                hintText: "Enter calories"),
                            SizedBox(
                              height: 10,
                            ),
                            FieldTitle('Image'),
                            if (emptyImage)
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Center(
                                          child: new Text(
                                            'Insert Image',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      imageProfile('image'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                              child: myDropDownList(
                                  items: allEquipment.map((e) => e.name).toList(),
                                  onChanged: (value){
                                    equipmentName=value;
                                    setState((){});
                                  },
                                  selectedItem: equipmentName,
                                  labelText: 'Equipment'
                              ),
                            ),


                            SizedBox(
                              height: 10,
                            ),
                            if (selectedEquipment != null)
                              CustomEquipmentListTile(
                                  selectedEquipment, refresh),
                            SizedBox(height: 10),
                            createButton(context),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container createButton(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: ElevatedButton(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text("Create"),
        ),
        style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          primary: Color(0xFFFFCE2B),
          onPrimary: Colors.black,
          textStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          minimumSize: Size(100, 30),
        ),
        onPressed: () async {
          setState(() {
            _status = true;
            FocusScope.of(context).requestFocus(new FocusNode());
          });
          Equipment equipment;
          for(int i=0;i<allEquipment.length;i++){
            if(equipmentName==allEquipment[i].name){
              equipment==allEquipment[i];
              break;
            }
          }

          if (_formKey.currentState.validate() &&
              _gifFile != null &&
              _imageFile != null) {
            _exercise = new Exercise(
              title: titleController.text,
              description: descriptionController.text,
              duration: durationController.text,
              reps: int.parse(repetitionsController.text),
              calBurnt: double.parse(caloriesController.text),
              equipment: equipment,
            );

            String imageName = _imageFile.path.split('/').last;
            String gifName = _gifFile.path.split('/').last;
            print('image name is $imageName');

            status = saveExercise(_imageFile, imageName, _gifFile, gifName);

            print("Back!");
          }
          if (_gifFile == null) {
            setState(() {
              emptyGIF = true;
            });
          }
          if (_imageFile == null) {
            setState(() {
              emptyImage = true;
            });
          }
          if (selectedEquipment == null) {
            setState(() {
              emptyEquipment = true;
            });
          }

          // // if (exerciseListViewModel.exercise != null)
        },
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }
}

class CustomEquipmentListTile extends StatefulWidget {
  final EquipmentViewModel equipment;
  final Function() notifyParent;

  CustomEquipmentListTile(this.equipment, this.notifyParent);
  @override
  _CustomEquipmentListTileState createState() =>
      _CustomEquipmentListTileState();
}

class _CustomEquipmentListTileState extends State<CustomEquipmentListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 10),
      decoration: BoxDecoration(
        color: Color(0xff181818),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        minVerticalPadding: 10,
        leading: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          child: Image.network(
            widget.equipment.picture,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          widget.equipment.name,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.equipment.description,
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
        trailing: GestureDetector(
          child: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onTap: () {
            selectedEquipment = null;
            widget.notifyParent();
          },
        ),
      ),
    );
  }
}
