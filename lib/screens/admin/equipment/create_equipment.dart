import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_states.dart';
import 'package:gym_project/screens/admin/helping-widgets/create-form-widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../bloc/Admin_cubit/admin_cubit.dart';
import '../../../models/admin-models/equipments/equipment-model.dart';
import '../../../services/equipment-webservice.dart';
import '../helping-widgets/create-form-widgets.dart';
bool IsAssigned=false;
class EquipmentForm extends StatelessWidget {
  final bool isAdd;
  final bool assign;
  final Equipment equipment;
  EquipmentForm({this.isAdd=true,this.equipment,this.assign=false});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final FocusNode myFocusNode = FocusNode();
  var formKey=GlobalKey<FormState>();


  PickedFile _imageFile; //'assets/images/branch.png'
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    if(!isAdd && !IsAssigned){
      nameController.text = equipment.name;
      descriptionController.text =equipment.description ;
      IsAssigned=true;
    }

    return BlocConsumer<AdminCubit,AdminStates>(
      listener: (context,state){},
      builder: (context,state){
        AdminCubit myCubit=AdminCubit.get(context);
        return new Scaffold(
          backgroundColor: Color(0xFF181818),
          appBar: AppBar(
            backgroundColor: Color(0xFF181818),
            elevation: 0.0,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: new Icon(
                Icons.arrow_back_ios,
                color: Color(0xFFFFCE2B),
                size: 22.0.sp,
              ),
            ),
            title: Text(
                isAdd?'Create Equipment':"Edit Equipment",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0.sp,
                    fontFamily:
                    'assets/fonts/Changa-Bold.ttf',
                    color: Colors.white)),
          ),
          body: Form(
            key:formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 5.w),
              child: new ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Padding(
                    padding:EdgeInsets.only(top: 10.0.h,bottom: 20.h),
                    child: Container(
                      alignment: Alignment.center,
                      width:double.infinity,
                      child: imageProfile(context,myCubit),
                    ),
                  ),
                  new Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.r)),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.h,horizontal: 32.w),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          field('name', 'Enter the Equipment title', nameController),
                          field(
                              'Description',
                              'Enter extra information about the Equipment',
                              descriptionController,maxLines: 9,
                          ),
                          //create button
                          Center(
                            child: ConditionalBuilder(
                              condition: state is! AddEquipmentsLoadingState,
                              builder: (context)=>Container(
                                width: 200.w,
                                height: 30.h,
                                child: new ElevatedButton(
                                  child: new Text(
                                    isAdd?"Create":"Update",
                                    style: TextStyle(
                                        fontSize: 16.sp
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                        new BorderRadius.circular(10.0.r),
                                      ),
                                      primary: Color(0xFFFFCE2B),
                                      onPrimary: Colors.black,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      textStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  onPressed: () {
                                    FocusScope.of(context).requestFocus(new FocusNode());
                                    if(isAdd){
                                      if(formKey.currentState.validate()){
                                        if(!assign)EquipmentsService.addEquipments(
                                            name: nameController.text,
                                            description: descriptionController.text,
                                            picture: _imageFile==null?"assets/images/branch.png":_imageFile.path,
                                          context: context,
                                          adminCubit: myCubit
                                        );
                                        else {

                                        }
                                      }
                                    }
                                    else{
                                      //update
                                      }
                                    }
                                ),
                              ),
                              fallback: (context)=>CircularProgressIndicator(color: Colors.yellow,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget imageProfile(BuildContext context,AdminCubit myCubit) {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 80.0.r,
          backgroundImage: _imageFile == null
              ? AssetImage("assets/images/branch.png")
              : kIsWeb
              ? NetworkImage(_imageFile.path)
              : FileImage(File(_imageFile.path)),
        ),
        Positioned(
          bottom: 10.0.h,
          right: 10.0.w,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet(context,myCubit)),
              );
            },
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: Colors.yellow,
              child: Icon(
                Icons.camera_alt,
                color: Colors.black,
                size: 25.0.sp,
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget bottomSheet(BuildContext context,AdminCubit myCubit) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 20.h,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Equipment photo",
            style: TextStyle(
              fontSize: 20.0.sp,
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera,myCubit);
                Navigator.of(context).pop();
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery,myCubit);
                Navigator.of(context).pop();
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source,AdminCubit myCubit) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    _imageFile = pickedFile;
    myCubit.updateState();
  }

}

