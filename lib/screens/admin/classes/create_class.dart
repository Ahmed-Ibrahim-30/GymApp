import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_cubit.dart';
import 'package:gym_project/bloc/newCreate/Create_states.dart';
import 'package:gym_project/bloc/newCreate/create_bloc.dart';
import 'package:gym_project/screens/admin/helping-widgets/create-form-widgets.dart';

import '../../../bloc/coach_cubit/coach_cubit.dart';
import '../../../models/classes.dart';
import '../../../services/claseess_services.dart';


class CreateClassForm extends StatelessWidget {
  final bool isAdd;
  final AdminCubit adminCubit;
  final CoachCubit coachCubit;
  final Classes classes;
  CreateClassForm({this.isAdd=true,this.adminCubit,this.classes,this.coachCubit});
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final FocusNode myFocusNode = FocusNode();

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context,CreateCubit createCubit) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2060),
    );
    if (selected != null && selected != selectedDate){
      selectedDate = selected;
      dateController.text=selectedDate.toString();
      createCubit.updateState();
    }
  }
  var formKey=GlobalKey<FormState>();
  bool enter=false;

  @override
  Widget build(BuildContext context) {
    if(!isAdd && !enter){
      descriptionController.text=classes.description;
      titleController.text=classes.title;
      linkController.text=classes.link;
      levelController.text=classes.level;
      capacityController.text=classes.capacity.toString();
      priceController.text=classes.price.toString();
      durationController.text=classes.duration.toString();
      dateController.text=classes.date.toString();
      enter=true;
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
              title: new Text('Create Class',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0.sp,
                      fontFamily:
                      'assets/fonts/Changa-Bold.ttf',
                      color: Colors.white)
              ),
            ),
            body: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 5.w),
                child: new ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Container(
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
                            field('Title', 'Enter the class title',titleController,maxLines: 2),
                            field('Description', 'Enter the class description',descriptionController,maxLines: 4),
                            field('Capacity', 'Enter the class a capacity',capacityController,keyboardType: TextInputType.number),
                            field('Price', 'Enter the class price',priceController,keyboardType: TextInputType.number),
                            field('Duration', 'Enter the class duration',durationController,keyboardType: TextInputType.number),
                            field('Link', 'Enter the class link if online',linkController),
                            field('level', 'Enter the class level',levelController),
                            field(
                                'Date',
                                'Enter the class Date',
                                dateController,
                                onTabFunction: (){
                                  // Below line stops keyboard from appearing
                                  FocusScope.of(context).requestFocus(new FocusNode());
                                  _selectDate(context,myCubit);
                                }
                            ),
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
                                          ClassesServices.addClass(
                                              description: descriptionController.text,
                                              title: titleController.text,
                                              link: linkController.text,
                                              level: levelController.text,
                                              capacity: int.parse(capacityController.text),
                                              price: priceController.text,
                                              duration: durationController.text,
                                              date: dateController.text,
                                              context: context,
                                              createCubit: myCubit,
                                              adminCubit: adminCubit,
                                            coachCubit:coachCubit
                                              );
                                        }
                                      }
                                      else{
                                        ClassesServices.updateClass(
                                            id: classes.id,
                                            index: classes.index,
                                            description: descriptionController.text,
                                            title: titleController.text,
                                            link: linkController.text,
                                            level: levelController.text,
                                            capacity: int.parse(capacityController.text),
                                            price: priceController.text,
                                            duration:durationController.text,
                                            date: dateController.text,
                                            context: context,
                                            adminCubit: adminCubit,
                                            createCubit: myCubit
                                        );
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
}
