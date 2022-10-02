import 'dart:ffi';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:gym_project/bloc/newCreate/Create_states.dart';
import 'package:gym_project/bloc/newCreate/create_bloc.dart';
import 'package:gym_project/models/admin-models/branches/branch-model.dart';
import 'package:gym_project/models/admin-models/membership/membership-model.dart';
import 'package:gym_project/screens/admin/helping-widgets/create-form-widgets.dart';
import 'package:gym_project/services/user_services/coach-webservice.dart';
import 'package:gym_project/services/user_services/nutritionist-service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../all_data.dart';
import '../../../constants.dart';
import '../../../services/user_services/members-webservice.dart';

class UserCreate extends StatelessWidget {
  final AdminCubit adminCubit;
  UserCreate({this.adminCubit});
  final FocusNode myFocusNode = FocusNode();
  int genderVal = -1;
  int roleVal = -1;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController frozenController = TextEditingController();
  TextEditingController availableMembershipController = TextEditingController();
  TextEditingController planController = TextEditingController();
  String selectedMembership='';
  var formKey=GlobalKey<FormState>();
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
    return BlocProvider(
      create: (context)=>CreateCubit(),
      child: BlocConsumer<CreateCubit,CreateStates>(
        listener: (context,state){},
        builder: (context,state){
          CreateCubit myCubit=CreateCubit.get(context);
          return Scaffold(
              backgroundColor: myBlack,
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: myBlack,
                title: Text('Create User',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0.sp,
                        fontFamily:
                        'assets/fonts/Changa-Bold.ttf',
                        color: Colors.white)
                ),
                leading: backButton(context: context),
              ),
              body: Form(
                key: formKey,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          height: 180.0.h,
                          color: Color(0xFF181818), //background color
                          child: Center(
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              fit: StackFit.loose,
                              children: [
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
                                Padding(
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
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25.r)),
                            color: Colors.white,
                          ),
                          margin: EdgeInsets.fromLTRB(18.w, 0, 18.w, 0),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 32.h,horizontal: 32.w),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                //Form Header
                                field("Name", "Enter the user name", nameController),
                                field(
                                    "Email",
                                    "Enter the user email",
                                    emailController,
                                    keyboardType: TextInputType.emailAddress
                                ),
                                field("Password",
                                    "Enter the password",
                                    passwordController,
                                    maxLines: 1,
                                    passwordVisibility: myCubit.showPassword,
                                    changePasswordVisibility: myCubit.changePasswordVisibility
                                ),
                                field("Number",
                                    "Enter the user phone number",
                                    numberController,
                                    keyboardType: TextInputType.phone
                                ),
                                //gender picker
                                new Text(
                                  'Gender',
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 4.w, top: 3.0.h),
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        InkWell(
                                          child: ListTile(
                                            title: Text("male"),
                                            leading: Radio(
                                              value: 1,
                                              groupValue: genderVal,
                                              onChanged: (value) {
                                                print(value);
                                                genderController.text = "male";
                                                genderVal = value;
                                                myCubit.updateState();
                                              },
                                              activeColor: Colors.green,
                                            ),
                                          ),
                                          onTap: (){
                                            genderController.text = "male";
                                            genderVal = 1;
                                            myCubit.updateState();
                                          },
                                        ),
                                        InkWell(
                                          child: ListTile(
                                            title: Text("female"),
                                            leading: Radio(
                                              value: 2,
                                              groupValue: genderVal,
                                              onChanged: (value) {
                                                genderController.text = "female";
                                                genderVal = value;
                                                myCubit.updateState();
                                              },
                                              activeColor: Colors.green,
                                            ),
                                          ),
                                          onTap: (){
                                            genderController.text = "female";
                                            genderVal = 2;
                                            myCubit.updateState();
                                          },
                                        ),
                                      ],
                                    )),
                                SizedBox(height: 5.h,),
                                new Text(
                                  'Role',
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(left: 4.w, top: 3.0.h),
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        InkWell(
                                          child: ListTile(
                                            title: Text("Coach"),
                                            leading: Radio(
                                              value: 1,
                                              groupValue: roleVal,
                                              onChanged: (value) {
                                                roleController.text = "coach";
                                                roleVal = value;
                                                myCubit.updateState();
                                              },
                                              activeColor: Colors.green,
                                            ),
                                          ),
                                          onTap: (){
                                            roleController.text = "coach";
                                            roleVal = 1;
                                            myCubit.updateState();
                                          },
                                        ),
                                        InkWell(
                                          child: ListTile(
                                            title: Text("Nutritionist"),
                                            leading: Radio(
                                              value: 2,
                                              groupValue: roleVal,
                                              onChanged: (value) {
                                                roleController.text = "nutritionist";
                                                roleVal = value;
                                                myCubit.updateState();
                                              },
                                              activeColor: Colors.green,
                                            ),
                                          ),
                                          onTap: (){
                                            roleController.text = "nutritionist";
                                            roleVal = 2;
                                            myCubit.updateState();
                                          },
                                        ),
                                        InkWell(
                                          child: ListTile(
                                            title: Text("Member"),
                                            leading: Radio(
                                              value: 3,
                                              groupValue: roleVal,
                                              onChanged: (value) {
                                                roleController.text = "member";
                                                roleVal = value;
                                                myCubit.updateState();
                                              },
                                              activeColor: Colors.green,
                                            ),
                                          ),
                                          onTap: (){
                                            roleController.text = "member";
                                            roleVal = 3;
                                            myCubit.updateState();
                                          },
                                        ),
                                      ],
                                    )),
                                SizedBox(height: 7.h,),
                                field("Age", "Enter Your Age", ageController,keyboardType: TextInputType.number),
                                field("Description", "Enter a description about the user", bioController),
                                if(roleController.text=="member")field("Available Frozen Days", "Enter a your frozen days", frozenController,keyboardType: TextInputType.number),
                                if(roleController.text=="member")field("Plan", "Enter Plan Id", planController,keyboardType: TextInputType.number),
                                if(roleController.text=="member")field("Available Membership Days", "Enter available membership days", availableMembershipController,keyboardType: TextInputType.number),
                                if(roleController.text=="member")Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.h),
                                  child: myDropDownList(
                                      items: allMemberships.map((e) => e.title).toList(),
                                      onChanged: (value){
                                        selectedMembership=value;
                                        myCubit.updateState();
                                      },
                                      selectedItem: selectedMembership,
                                      labelText: "Membership"
                                  ),
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
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: Container(
                                    width: double.infinity,
                                    child: DropdownButtonFormField(
                                      validator: (value){
                                        if(value==null){
                                          return 'You must choose Branch';
                                        }
                                        else{
                                          return null;
                                        }
                                      },
                                      items:branchesList.map((Branch items) {
                                        return DropdownMenuItem(
                                          value: items.title,
                                          child: Text(items.title),
                                        );
                                      }).toList(),
                                      isExpanded: true,
                                      value: myCubit.branchValue,
                                      hint: Text('Enter Branch Location',style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14.sp,
                                      ),),
                                      onChanged: (String value) {
                                        myCubit.changeBranchValue(value);
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 7.h,),
                                Center(
                                  child: ConditionalBuilder(
                                    condition: state is! Loading1,
                                    builder: (context)=>Container(
                                      width: 200.w,
                                      height: 30.h,
                                      child: new ElevatedButton(
                                        child: new Text(
                                          "Create",
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
                                          if(formKey.currentState.validate()){
                                            if(genderVal==-1){
                                              myToast(message: "You must select user gender",color: Colors.red);
                                            }
                                            else if(roleVal==-1){
                                              myToast(message: "You must select user role ",color: Colors.red);
                                            }
                                            else {
                                              if(roleController.text=="coach"){
                                                CoachWebService.addCoach(
                                                    name: nameController.text,
                                                    email: emailController.text,
                                                    password: passwordController.text,
                                                    gender: genderController.text,
                                                    branchId: branchesList.where((element) => element.title==myCubit.branchValue).elementAt(0).id,
                                                    role: roleController.text,
                                                    number: numberController.text,
                                                    photo: imageFile,
                                                    bio: bioController.text,
                                                    age: int.parse(ageController.text),
                                                    context: context,
                                                    createCubit: myCubit,
                                                    adminCubit: adminCubit
                                                );
                                              }
                                              else if(roleController.text=="nutritionist"){
                                                NutritionistWebservice.addNutritionist(
                                                    name: nameController.text,
                                                    email: emailController.text,
                                                    password: passwordController.text,
                                                    gender: genderController.text,
                                                    branchId: branchesList.where((element) => element.title==myCubit.branchValue).elementAt(0).id,
                                                    role: roleController.text,
                                                    number: numberController.text,
                                                    photo: imageFile,
                                                    bio: bioController.text,
                                                    age: int.parse(ageController.text),
                                                    context: context,
                                                    createCubit: myCubit,
                                                    adminCubit: adminCubit
                                                );
                                              }
                                              else if(roleController.text=="member"){
                                                Membership membership;
                                                for(int i=0;i<allMemberships.length;i++){
                                                  if(selectedMembership==allMemberships[i].title){
                                                    membership=allMemberships[i];
                                                    break;
                                                  }
                                                }
                                                MembersWebService.addMember(
                                                    branchId: branchesList.where((element) => element.title==myCubit.branchValue).elementAt(0).id,
                                                    email: emailController.text,
                                                    gender: genderController.text,
                                                    name: nameController.text,
                                                    number: numberController.text,
                                                    password: passwordController.text,
                                                    photo: imageFile,
                                                    role: roleController.text.toLowerCase(),
                                                    context:context,
                                                    createCubit: myCubit,
                                                    current_plan: int.parse(planController.text),
                                                    bio: bioController.text,
                                                    available_frozen_days: int.parse(frozenController.text)??0,
                                                    available_membership_days: int.parse(availableMembershipController.text)??0,
                                                    membership_id: membership.id,
                                                    adminCubit:adminCubit,
                                                  age: int.parse(ageController.text),
                                                );
                                              }

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
                        )
                      ],
                    ),
                  ],
                ),
              )
          );
        },
      )
    );
  }

}
