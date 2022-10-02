import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/all_data.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:gym_project/bloc/newCreate/Create_states.dart';
import 'package:gym_project/bloc/newCreate/create_bloc.dart';
import 'package:gym_project/constants.dart';
import '../../../models/admin-models/branches/branch-model.dart';
import '../../../services/admin-services/membership-service.dart';
import '../helping-widgets/create-form-widgets.dart';


class EditMembership extends StatelessWidget {
  final int membershipIndex;
  final AdminCubit adminCubit;
  final bool isAdd;
  EditMembership({ this.membershipIndex,this.adminCubit,this.isAdd=true});
  bool edit = false;
  final FocusNode myFocusNode = FocusNode();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController limitController = TextEditingController();
  final TextEditingController availableClassController = TextEditingController();
  String branchTitle='';

  bool AssignValues=false;
  @override
  Widget build(BuildContext context) {
    if(!AssignValues && !isAdd){
      AssignValues=true;
      titleController.text=allMemberships[membershipIndex].title;
      descriptionController.text= allMemberships[membershipIndex].description;
      durationController.text="${allMemberships[membershipIndex].duration}";
      priceController.text="${allMemberships[membershipIndex].price}";
      discountController.text="${allMemberships[membershipIndex].discount}";
      limitController.text="${allMemberships[membershipIndex].limit_of_frozen_days}";
      availableClassController.text="${allMemberships[membershipIndex].duration}";
    }
    return BlocProvider(
      create: (context)=>CreateCubit(),
      child: BlocConsumer<CreateCubit,CreateStates>(
          listener: (context,state){},
          builder: (context,state){
            CreateCubit createCubit=CreateCubit.get(context);
            return Scaffold(
              backgroundColor: myBlack,
              appBar: AppBar(
                backgroundColor: myBlack,
                elevation: 0.0,
                actions: [
                  !edit && !isAdd ? Padding(
                    padding: EdgeInsets.only(right: 20.w,top: 5.h),
                    child: _getEditIcon(createCubit),
                  ) : new Container(),
                ],
                title: Text('Edit Membership',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0.sp,
                        fontFamily: 'assets/fonts/Changa-Bold.ttf',
                        color: Colors.white
                    )
                ),
                leading: backButton(context: context),
              ),
              body: SafeArea(
                child: Container(
                  constraints: new BoxConstraints(minHeight: 500.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.r)),
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 20.h),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 20.h),
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children:[
                        Text(
                          'Membership Information',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 30.h,),
                        //Form fields
                        field('Title','', titleController,enable: !isAdd?edit:true),
                        !isAdd?field('Branch Title','', TextEditingController(text: allMemberships[membershipIndex].branch.title),enable: false):
                        myDropDownList(
                            items: branchesList.map((e) => e.title).toList(),
                            onChanged: (value){branchTitle=value;},
                            selectedItem: branchTitle,
                          labelText: 'Branch Title'
                        ),
                        if(isAdd)SizedBox(height: 20.h,),
                        field('Duration','', durationController,keyboardType: TextInputType.number,enable: !isAdd?edit:true),
                        field('Description', "",descriptionController,enable: !isAdd?edit:true),
                        field('Price', "", priceController,keyboardType: TextInputType.number,enable: !isAdd?edit:true),
                        field('Discount', "", discountController,keyboardType: TextInputType.number,enable: !isAdd?edit:true),
                        field('Limit of frozen days', "",limitController,keyboardType: TextInputType.number,enable: !isAdd?edit:true),
                        field('Available classes', "",availableClassController,keyboardType: TextInputType.number,enable: !isAdd?edit:true),
                        edit ? _getActionButtons(
                          context,
                          createCubit
                        ) : new Container(),

                        isAdd?ConditionalBuilder(
                          condition: state is!Loading1,
                          builder: (context)=>Container(
                              child: new ElevatedButton(
                                child: new Text("Add"),
                                style: ElevatedButton.styleFrom(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(10.0.r),
                                    ),
                                    primary: Color(0xFFFFCE2B),
                                    onPrimary: Colors.black,
                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                  Branch branch;
                                  for(int i=0;i<branchesList.length;i++){
                                    if(branchTitle==branchesList[i].title){
                                      branch=branchesList[i];
                                      break;
                                    }
                                  }
                                  MembershipsWebservice.postMembership(
                                    branch_id: branch.id,
                                      duration: double.parse(durationController.text),
                                      title: titleController.text,
                                      description: descriptionController.text,
                                      price: double.parse(priceController.text),
                                      limit_of_frozen_days: int.parse(limitController.text),
                                      discount: double.parse(discountController.text),
                                      available_classes: double.parse(availableClassController.text).toInt(),
                                      context: context,
                                      adminCubit: adminCubit,
                                      createCubit: createCubit
                                  );
                                },
                              )),
                          fallback: (context)=>Center(child: CircularProgressIndicator(color: myYellow,),),
                        ):SizedBox()
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
      ),
    );
  }


  Widget _getActionButtons(
      BuildContext context,
      CreateCubit createCubit2,
      ) {
    return BlocProvider(
        create: (context)=>CreateCubit(),
      child: BlocConsumer<CreateCubit,CreateStates>(
        listener: (context,state){},
        builder: (context,state){
          CreateCubit createCubit=CreateCubit.get(context);
          return Padding(
            padding: EdgeInsets.only(left: 25.0.w, right: 25.0.w, top: 20.0.h),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 10.0.w),
                    child: ConditionalBuilder(
                      condition: state is!Loading1,
                      builder: (context)=>Container(
                          child: new ElevatedButton(
                            child: new Text("Save"),
                            style: ElevatedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                                primary: Color(0xFFFFCE2B),
                                onPrimary: Colors.black,
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () {
                              edit = true;
                              FocusScope.of(context).requestFocus(new FocusNode());
                              MembershipsWebservice.editMembership(
                                  id: allMemberships[membershipIndex].id,
                                  index: membershipIndex,
                                  duration: double.parse(durationController.text),
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  price: double.parse(priceController.text),
                                  limit_of_frozen_days: int.parse(limitController.text),
                                  discount: double.parse(discountController.text),
                                  available_classes: double.parse(availableClassController.text).toInt(),
                                  context: context,
                                  adminCubit: adminCubit,
                                  createCubit: createCubit
                              );
                            },
                          )),
                      fallback: (context)=>Center(child: CircularProgressIndicator(color: myYellow,),),
                    )
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Container(
                        child: new ElevatedButton(
                          child: new Text("Cancel"),
                          style: ElevatedButton.styleFrom(
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              primary: Color(0xFFFFCE2B),
                              onPrimary: Colors.black,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              )),
                          onPressed: () {
                            edit = false;
                            FocusScope.of(context).requestFocus(new FocusNode());
                            createCubit2.updateState();
                          },
                        )),
                  ),
                  flex: 2,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _getEditIcon(CreateCubit createCubit) {
    return GestureDetector(
      child: new CircleAvatar(
        backgroundColor: myYellow,
        radius: 20.0.r,
        child: new Icon(
          Icons.edit,
          color: Colors.black,
          size: 23.0.sp,
        ),
      ),
      onTap: () {
        edit = true;
        createCubit.updateState();
      },
    );
  }
}
