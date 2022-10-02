import 'dart:io';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/bloc/newCreate/Create_states.dart';
import 'package:gym_project/bloc/newCreate/create_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../bloc/Admin_cubit/admin_cubit.dart';
import '../../../bloc/Admin_cubit/admin_states.dart';
import '../../../models/admin-models/equipments/equipment-model.dart';
import '../../../services/equipment-webservice.dart';
import '../helping-widgets/create-form-widgets.dart';


class EquipmentDetails extends StatelessWidget {
  final Equipment equipment;
  final AdminCubit adminCubit;
  final bool allowUpdate;
  EquipmentDetails({@required this.equipment,this.adminCubit,this.allowUpdate=true});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  PickedFile _imageFile; //'assets/images/branch.png'
  final ImagePicker _picker = ImagePicker();
  bool isEdit=false;
  bool equipmentAssign=false;
  @override
  Widget build(BuildContext context) {
    if(!equipmentAssign){
      nameController.text = equipment.name;
      descriptionController.text =equipment.description ;
      equipmentAssign=true;
    }
    return BlocProvider(
      create: (context)=>CreateCubit(),
      child: BlocConsumer<CreateCubit,CreateStates>(
        listener: (context,state){},
        builder: (context,state){
          CreateCubit myCubit=CreateCubit.get(context);
          return Scaffold(
            backgroundColor: Color(0xFF181818),
            appBar: AppBar(
              backgroundColor: Color(0xFF181818),
              foregroundColor: Colors.white,
              title: Text(
                'Equipment Details',
                style: TextStyle(
                  fontSize: 19.sp,
                  fontFamily: 'assets/fonts/Changa-Bold.ttf',
                ),
              ),
              leading: IconButton(
                color: Colors.yellow,
                icon: Icon(Icons.arrow_back_rounded,size: 24.sp,),
                onPressed: (){Navigator.pop(context);},
              ),
              actions: [
                if(allowUpdate)FloatingActionButton(
                  heroTag: 'one',
                  child: Icon(Icons.edit,color: Colors.black,size: 20.sp,),
                  backgroundColor: Colors.yellow,
                  mini: true,
                  onPressed: (){
                    isEdit=!isEdit;
                    myCubit.updateState();
                  },
                ),
                if(allowUpdate)SizedBox(width: 15.w,),
                if(allowUpdate)ConditionalBuilder(
                  condition: state is! Loading1,
                  builder:(context)=>FloatingActionButton(
                    heroTag: 'two',
                    child: Icon(Icons.delete,color: Colors.black,size: 20.sp,),
                    backgroundColor: Colors.yellow,
                    mini: true,
                    onPressed: (){
                      EquipmentsService.deleteEquipments(
                          id: equipment.id,
                          createCubit: myCubit,
                          context: context,
                        adminCubit:adminCubit
                      );
                    },
                  ),
                  fallback: (context)=>Center(child: CircularProgressIndicator(color: Colors.yellow,strokeWidth: 3.r,)),
                ),
              ],
            ),
            body: Padding(
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

                          field('name', '', nameController,enable: isEdit,maxLines: 3),
                          field(
                            'Description',
                            '',
                            descriptionController,
                            maxLines: 9,
                            enable: isEdit,
                          ),
                          //create button
                          isEdit?Center(
                            child: ConditionalBuilder(
                              condition: state is! Loading2,
                              builder: (context)=>Container(
                                width: 200.w,
                                height: 30.h,
                                child: new ElevatedButton(
                                    child: new Text(
                                      "Update",
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
                                      EquipmentsService.updateEquipments(
                                          id: equipment.id,
                                          name: nameController.text,
                                          description: descriptionController.text,
                                          picture: _imageFile==null?"assets/images/branch.png":_imageFile.path,
                                        createCubit: myCubit,
                                        context: context,
                                        adminCubit: adminCubit
                                      );
                                    }
                                ),
                              ),
                              fallback: (context)=>CircularProgressIndicator(color: Colors.yellow,),
                            ),
                          ):SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget imageProfile(BuildContext context,CreateCubit myCubit) {
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
        isEdit?Positioned(
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
        ):SizedBox(),
      ]),
    );
  }

  Widget bottomSheet(BuildContext context,CreateCubit myCubit) {
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

  void takePhoto(ImageSource source,CreateCubit myCubit) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    _imageFile = pickedFile;
    myCubit.updateState();
  }
}
