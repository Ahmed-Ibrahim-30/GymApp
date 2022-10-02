import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_project/screens/admin/equipment/show_branch_equipments.dart';
import 'Create_states.dart';

class CreateCubit extends Cubit<CreateStates> {
  CreateCubit() :super(CreateUserInitStates());
  static CreateCubit get(context) => BlocProvider.of(context);

  void selectCheckBox(branchEquipment valid){
    valid.isSelected=!valid.isSelected;
    valid.selectedIcon=valid.isSelected?Icons.check_box:Icons.check_box_outline_blank;
    updateState();
  }


  void updateState(){
    emit(NewState());
  }

  void loading1(){
    emit(Loading1());
  }
  void loading2(){
    emit(Loading2());
  }
  void finishLoading(){
    emit(FinishLoading());
  }
  bool showPassword=false;

  void changePasswordVisibility(){
    showPassword=!showPassword;
    emit(ShowPasswordState());
  }
  String branchValue;
  void changeBranchValue(String value){
    branchValue=value;
    emit(ChangeBranchState());
  }
}