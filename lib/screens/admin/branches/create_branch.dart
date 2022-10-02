import 'dart:io';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/bloc/newCreate/Create_states.dart';
import 'package:gym_project/bloc/newCreate/create_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../bloc/Admin_cubit/admin_cubit.dart';
import '../../../models/admin-models/branches/branch-model.dart';
import '../../../services/admin-services/branches-services.dart';
import '../helping-widgets/create-form-widgets.dart';

class BranchForm extends StatelessWidget {
  final AdminCubit adminCubit;
  final bool isAdd;
  final Branch branch;
  final BuildContext detailsContext;
  BranchForm({@required this.adminCubit,this.isAdd=true,this.branch,this.detailsContext});
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController membersNumberController = TextEditingController();
  final TextEditingController coachesNumberController = TextEditingController();
  final FocusNode myFocusNode = FocusNode();
  var formKey=GlobalKey<FormState>();
  bool enter=false;
  File imageFile;

  Future<void> getImage({source,CreateCubit createCubit})async {
    // Pick an image
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(
        source: source,
        imageQuality: 50, // <- Reduce Image quality
        maxHeight: 500,  // <- reduce the image size
        maxWidth: 500
    );
    if(image!=null){
      File img=File(image.path);
      imageFile=img;
      createCubit.updateState();
    }
  }

  @override
  Widget build(BuildContext context) {
    if(!isAdd && !enter){
      titleController.text = branch.title;
      locationController.text =branch.location;
      numberController.text = branch.number;
      descriptionController.text =branch.info ;
      capacityController.text = branch.crowdMeter.toString();
      membersNumberController.text =branch.membersNumber.toString();
      coachesNumberController.text =branch.coachesNumber.toString();
      enter=true;
    }

    return BlocProvider(
      create: (context)=>CreateCubit(),
      child: BlocConsumer<CreateCubit,CreateStates>(
        listener: (context,state){},
        builder: (context,state){
          CreateCubit myCubit=CreateCubit.get(context);
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
                  isAdd?'Create Branch':"Edit Branch",
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

                            field('Title', 'Enter the branch title',
                                titleController,maxLines: 2),
                            field('Location', 'Enter the branch location',
                                locationController,maxLines: 3),
                            field('Number', 'Enter the branch phone number',
                                numberController,keyboardType: TextInputType.number,maxLines: 2),
                            field(
                                'Description',
                                'Enter extra information about the branch',
                                descriptionController,maxLines: 4),
                            field('Capacity', 'Enter the branch capacity',
                                capacityController,keyboardType: TextInputType.number,maxLines: 2),
                            field(
                                'Members number',
                                'How many members in the branch',
                                membersNumberController,keyboardType: TextInputType.number),
                            field(
                                'Coaches number',
                                'How many coaches in the branch',
                                coachesNumberController,keyboardType: TextInputType.number),
                            //create button
                            Center(
                              child: ConditionalBuilder(
                                condition: state is! Loading1,
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
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                      if(isAdd){
                                        if(formKey.currentState.validate()){
                                          BranchService.addBranch(
                                              title: titleController.text,
                                              location: locationController.text,
                                              number: numberController.text,
                                              crowdMeter: int.parse(capacityController.text),
                                              photo: imageFile,
                                              info: descriptionController.text,
                                              membersNumber: int.parse(membersNumberController.text),
                                              coachesNumber: int.parse(coachesNumberController.text),
                                              context: context,
                                              adminCubit: adminCubit,
                                              createCubit:myCubit
                                          );
                                        }
                                      }
                                      else{
                                        if(formKey.currentState.validate()){
                                          BranchService.updateBranch(
                                              title: titleController.text,
                                              location: locationController.text,
                                              number: numberController.text,
                                              crowdMeter: int.parse(capacityController.text),
                                              //picture: imageFile,
                                              info: descriptionController.text,
                                              membersNumber: int.parse(membersNumberController.text),
                                              coachesNumber: int.parse(coachesNumberController.text),
                                              context: context,
                                              createCubit:myCubit,
                                              adminCubit: adminCubit,
                                              id: branch.id,
                                              index: branch.index,
                                              detailsContext: detailsContext,
                                          );
                                        }
                                      }


                                    },
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
      ),
    );
  }

  Widget imageProfile(BuildContext context,CreateCubit myCubit) {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 80.0.r,
          backgroundImage: imageFile == null
              ? AssetImage("assets/images/as.png")
              : kIsWeb
                  ? NetworkImage(imageFile.path)
                  : FileImage(File(imageFile.path)),
        ),
        Positioned(
          bottom: 20.0.h,
          right: 20.0.w,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet(context,myCubit)),
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.3),
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

  Widget bottomSheet(BuildContext context,CreateCubit myCubit) {
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
    final pickedFile = await getImage(
      source: source,
      createCubit: myCubit,
    );
    myCubit.updateState();
  }

}
