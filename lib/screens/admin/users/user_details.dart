import 'dart:io';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/bloc/newCreate/Create_states.dart';
import 'package:gym_project/constants.dart';
import 'package:gym_project/models/user/user_model.dart';
import 'package:gym_project/services/user_services/coach-webservice.dart';
import 'package:gym_project/services/user_services/members-webservice.dart';
import 'package:gym_project/services/user_services/nutritionist-service.dart';
import 'package:image_picker/image_picker.dart';
import '../../../all_data.dart';
import '../../../bloc/Admin_cubit/admin_cubit.dart';
import '../../../bloc/Admin_cubit/admin_states.dart';
import '../../../bloc/newCreate/create_bloc.dart';
import '../../../common/my_list_tile_without_counter.dart';
import '../../../models/admin-models/branches/branch-model.dart';
import '../../../widget/global.dart';
import '../branches/branch_details.dart';
import '../classes/class_details.dart';
import '../helping-widgets/create-form-widgets.dart';
import 'own_members.dart';

class UserProfile extends StatelessWidget {
  var user;
  final AdminCubit adminCubit;
  UserProfile({@required this.user,@required this.adminCubit});
  bool editUser=false;
  final FocusNode myFocusNode = FocusNode();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController frozenController = TextEditingController();
  TextEditingController availableMembershipController = TextEditingController();
  TextEditingController medicalAllergicController = TextEditingController();
  TextEditingController medicalPhysicalController = TextEditingController();
  Branch userBranch;
  bool enter=false;
  File imageFile;
  Future<void> getImage(CreateCubit createCubit)async {
     // Pick an image
     final ImagePicker _picker = ImagePicker();
     final image = await _picker.pickImage(
         source: ImageSource.gallery,
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
    if(!enter){
      nameController.text=user.name;
      ageController.text="${user.age}";
      numberController.text=user.number;
      bioController.text=user.bio;
      weightController.text="${user.weight}";
      heightController.text="${user.height}";
      if(user.role=="member")medicalAllergicController.text=user.medicalAllergicHistory;
      if(user.role=="member")medicalPhysicalController.text=user.medicalPhysicalHistory;
      if(user.role=="member")frozenController.text="${user.availableFrozenDays}";
      if(user.role=="member")availableMembershipController.text="${user.availableMembershipDays}";
      int branchID=user.branchId;

      for(int i=0;i<branchesList.length;i++){
        if(branchesList[i].id==branchID){
         userBranch=branchesList[i];
          break;
        }
      }
      enter=true;
    }
    return BlocProvider(
      create: (context)=>CreateCubit(),
      child: BlocConsumer<CreateCubit,CreateStates>(
        listener: (context,state)=>{},
        builder: (context,state){
          CreateCubit myCubit=CreateCubit.get(context);
          return new Scaffold(
            backgroundColor:  myBlack,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Color(0xFF181818),
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
              title: new Text('User Info',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0.sp,
                      fontFamily: 'assets/fonts/Changa-Bold.ttf',
                      color: Colors.white)),
              actions: [
                Global.role == "admin"
                    ? _getEditIcon(user,context,state,myCubit)
                    : new Container(),
                SizedBox(width: 20.w,)
              ],
            ),
            body: new ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Center(
                  child:Container(
                    height: 150.0.h,
                    color: myBlack, //background color
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.0.h),
                      child: new Stack(
                        alignment: Alignment.bottomRight,
                        fit: StackFit.loose,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: myBlack,
                            radius: 80.r,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(80.r),
                              child: ConditionalBuilder(
                                condition: imageFile!=null,
                                builder: (context)=>Image.file(
                                  imageFile,
                                  width: 150.r,
                                  height: 150.r,
                                  fit: BoxFit.cover,
                                ),
                                fallback: (context)=>Image.asset(
                                  'assets/images/as.png',
                                  width: 150.r,
                                  height: 150.r,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          if(editUser)Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 8.w),
                            child: FloatingActionButton(
                              heroTag: "btn1",
                              mini: true,
                              onPressed: ()async{
                                getImage(myCubit);
                              },
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.r)),
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.fromLTRB(22.w, 0, 22.w, 0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.h,horizontal: 40.w),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        field("Name","", nameController,enable: editUser),
                        field("Email","", TextEditingController(text: user.email),enable: false),
                        field("Mobile","", numberController,enable: editUser),
                        field("Description","", bioController,enable: editUser),
                        if(user.role=="member")field("Membership ID","", TextEditingController(text:"${user.membership_id}"),enable: false),
                        field("Age", "Enter Your Age", ageController,keyboardType: TextInputType.number,enable: editUser),
                        field("Weight","Enter Your Weight", weightController,enable: editUser,keyboardType: TextInputType.number),
                        field("height","Enter Your height", heightController,enable: editUser,keyboardType: TextInputType.number),
                        if(user.role=="member")field("Available Frozen Days", "Enter a your frozen days", frozenController,keyboardType: TextInputType.number,enable: editUser),
                        //if(user.role=="member")field("Medical Physical Days", "Medical Physical Days", medicalPhysicalController,enable: editUser),
                        if(user.role=="member")field("Medical Allergic History", "Enter a Medical Allergic History", medicalAllergicController,enable: editUser),
                       // if(user.role=="member")field("Available Membership Days", "Enter available membership days", availableMembershipController,keyboardType: TextInputType.number,enable: editUser),
                        if(user.role=='coach')field("Rate","", TextEditingController(text: user.avg_rate),enable: false),
                        if(user.role=="coach" || user.role=="nutritionist")Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.h),
                          child: Container(
                            width: double.infinity,
                            height: 60.h,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            decoration: BoxDecoration(
                              color: myBlack,
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(15),
                              topLeft: Radius.circular(15))
                            ),
                            child:BlocConsumer<AdminCubit,AdminStates>(
                              listener: (context,state){},
                              builder: (context,state){
                                return  ListTile(
                                  leading: Icon(Icons.people,color: myYellow,size: 25.sp,),
                                  title: Text(
                                    user.role=="coach"?"${coachesUsers[user.index].allMembers.length}  Members":"${nutritionistsUsers[user.index].allMembers.length}  Members",
                                    maxLines: 4,
                                    style: TextStyle(
                                      fontSize: 16.0.sp,
                                      fontWeight: FontWeight.w600,
                                      color: myYellow,
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: 'assets/fonts/Changa-Bold.ttf',
                                    ),
                                  ),
                                  trailing: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: myYellow,
                                      ),
                                      onPressed: (){
                                        goToAnotherScreenPush(context,
                                          OwnMembers(context: context,user:user,role: user.role=="coach"?"Coach":"Nutritionist"),
                                        );
                                      },
                                      child: Text(
                                        "See All",
                                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                );
                              },
                            )
                          ),
                        ),
                        ConditionalBuilder(
                            condition: user.role=="member",
                            builder: (context){
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Coach",
                                      style: TextStyle(
                                        fontSize: 16.0.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 10.h,),
                                    ConditionalBuilder(
                                        condition: user.coach!=null,
                                        builder: (context)=> CustomListTileWithoutCounter(
                                          'assets/images/user_icon.png',
                                          user.coach.name,
                                          user.coach.number,
                                          "Rate : ${user.coach.avg_rate}",
                                          user.coach.email,
                                          isUser: true,
                                          isOnFunction: true,
                                        ),
                                      fallback: (context)=>Container(
                                        width: double.infinity,
                                        height: 80.h,
                                        margin: EdgeInsetsDirectional.only(bottom: 7.h),
                                        decoration: BoxDecoration(
                                          color: Color(0xff181818),
                                          borderRadius: BorderRadius.circular(16.r),
                                        ),
                                        child: Center(child: Text("Not Found",style: TextStyle(color: myYellow,fontSize: 20.sp,fontWeight: FontWeight.bold),)),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          fallback: (context)=>SizedBox(),
                        ),
                        ConditionalBuilder(
                          condition: user.role=="member",
                          builder: (context){
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Nutritionist",
                                    style: TextStyle(
                                      fontSize: 16.0.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 10.h,),
                                  ConditionalBuilder(
                                      condition: user.nutritionist!=null,
                                      builder: (context)=>CustomListTileWithoutCounter(
                                        'assets/images/user_icon.png',
                                        user.nutritionist.name,
                                        user.nutritionist.number,
                                        user.nutritionist.role,
                                        user.nutritionist.email,
                                        isUser: true,
                                        isOnFunction: true,
                                      ),
                                    fallback: (context)=>Container(
                                      width: double.infinity,
                                      height: 80.h,
                                      margin: EdgeInsetsDirectional.only(bottom: 7.h),
                                      decoration: BoxDecoration(
                                        color: Color(0xff181818),
                                        borderRadius: BorderRadius.circular(16.r),
                                      ),
                                      child: Center(child: Text("Not Found",style: TextStyle(color: myYellow,fontSize: 20.sp,fontWeight: FontWeight.bold),)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          fallback: (context)=>SizedBox(),
                        ),

                        SizedBox(height: 5.h,),
                        Text(
                          'Branch',
                          style: TextStyle(
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 3.h,),
                        ConditionalBuilder(
                          condition: false,//because branch id don't update
                          builder: (context)=>Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Container(
                              width: double.infinity,
                              child: DropdownButtonFormField(
                                items:branchesList.map((Branch items) {
                                  return DropdownMenuItem(
                                    value: items.title,
                                    child: Text(items.title),
                                  );
                                }).toList(),
                                isExpanded: true,
                                value: myCubit.branchValue,
                                hint: Text(userBranch.title,style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16.sp,
                                ),),
                                onChanged: (String value) {
                                  myCubit.changeBranchValue(value);
                                },
                              ),
                            ),
                          ),
                          fallback: (context)=>Padding(
                            padding: EdgeInsets.only(top: 3.h),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(Icons.class_outlined),
                              title: Text(
                                userBranch.title,
                                style: TextStyle(
                                  fontSize: 16.0.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              trailing: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: myYellow,
                                  ),
                                  onPressed: (){
                                    goToAnotherScreenPush(context,
                                      BranchDetails(adminCubit: adminCubit,index:userBranch.index),//TODO update
                                    );
                                  },
                                  child: Text(
                                    "See Branch",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h,),
                        ConditionalBuilder(
                          condition: editUser,
                          builder: (_)=>Center(
                            child: ConditionalBuilder(
                              condition: state is! Loading2,
                              builder: (context)=>Container(
                                width: 200.w,
                                height: 40.h,
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
                                    FocusScope.of(context).requestFocus(new FocusNode());
                                    if(user.role=="coach"){
                                      CoachWebService.updateCoach(
                                          id:user.id,
                                          coachIndex: user.index,
                                          weight: int.parse(weightController.text),
                                          height: int.parse(heightController.text),
                                          name: nameController.text,
                                          number: numberController.text,
                                          photo: imageFile,
                                          bio: bioController.text,
                                          age: int.parse(ageController.text),
                                          context: context,
                                          createCubit: myCubit,
                                          adminCubit: adminCubit
                                      );
                                    }
                                    else if(user.role=="nutritionist"){
                                      NutritionistWebservice.updateNutritionist(
                                          id:user.id,
                                          nutritionistsIndex: user.index,
                                          weight: int.parse(weightController.text),
                                          height: int.parse(heightController.text),
                                          name: nameController.text,
                                          number: numberController.text,
                                          photo: imageFile,
                                          bio: bioController.text,
                                          age: int.parse(ageController.text),
                                          context: context,
                                          createCubit: myCubit,
                                          adminCubit: adminCubit
                                      );
                                    }
                                    else if(user.role=="member"){
                                      MembersWebService.updateMember(
                                          id:user.id,
                                          memberIndex: user.index,
                                          weight: int.parse(weightController.text),
                                          height: int.parse(heightController.text),
                                          name: nameController.text,
                                          number: numberController.text,
                                          //photo: imageFile,
                                          bio: bioController.text,
                                          age: int.parse(ageController.text),
                                          available_frozen_days: int.parse(frozenController.text),
                                          available_membership_days: int.parse(availableMembershipController.text),
                                          medical_allergic_history: medicalAllergicController.text,
                                          medical_physical_history: medicalPhysicalController.text,
                                          context: context,
                                          createCubit: myCubit,
                                          adminCubit: adminCubit
                                      );
                                    }
                                  },
                                ),
                              ),
                              fallback: (context)=>CircularProgressIndicator(color: Colors.yellow,),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


  Widget _getEditIcon(var user,BuildContext context,state,CreateCubit myCubit) {
    return Row(
      children: [
        new GestureDetector(
          child: new CircleAvatar(
            backgroundColor: Color(0xFFFFCE2B),
            radius: 20.0.r,
            child: new Icon(
              Icons.edit,
              color: Colors.black,
              size: 23.0.sp,
            ),
          ),
          onTap: () {
            editUser=!editUser;
            myCubit.updateState();
          },
        ),
        SizedBox(width: 10.w,),
        ConditionalBuilder(
          condition: state is! Loading1,
          builder: (context)=>new GestureDetector(
            child: new CircleAvatar(
              backgroundColor: Color(0xFFFFCE2B),
              radius: 20.0.r,
              child: new Icon(
                Icons.delete,
                color: Colors.black,
                size: 23.0.sp,
              ),
            ),
            onTap: () {
              if(user.role=="member"){
                MembersWebService.deleteMember(
                    id: user.id,
                    memberIndex: user.index,
                    context: context,
                    createCubit: myCubit,
                    adminCubit: adminCubit
                );
              }
              else if(user.role=="coach"){
                CoachWebService.deleteCoach(
                    id: user.id,
                    coachIndex: user.index,
                    userIndex: user.indexInAll,
                    context: context,
                    createCubit: myCubit,
                    adminCubit: adminCubit
                );
              }
              else if(user.role=="nutritionist"){
                NutritionistWebservice.deleteNutritionist(
                    id: user.id,
                    nutritionistsIndex: user.index,
                    userIndex: user.indexInAll,
                    context: context,
                    createCubit: myCubit,
                    adminCubit: adminCubit
                );
              }
            },
          ),
          fallback: (context)=>CircularProgressIndicator(color: Colors.yellow,),
        ),

      ],
    );
  }

}

class ScreenArguments {
  final User userInfo;

  ScreenArguments(this.userInfo);
}
