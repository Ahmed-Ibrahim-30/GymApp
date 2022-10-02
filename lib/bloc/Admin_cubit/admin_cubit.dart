import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gym_project/bloc/newCreate/create_bloc.dart';
import 'package:gym_project/services/admin-services/announcements_services.dart';
import 'package:gym_project/services/admin-services/branches-services.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_project/bloc/Admin_cubit/admin_states.dart';
import '../../constants.dart';
import '../../models/admin-models/nutritionist-Sessions/nutritionistSession-model.dart';
import '../../models/admin-models/nutritionist-Sessions/nutritionistSessions-list-model.dart';
import '../../models/classes.dart';
import '../../models/user/user_model.dart';
import '../../services/admin-services/membership-service.dart';
import '../../services/claseess_services.dart';
import '../../services/equipment-webservice.dart';
import '../../services/nutritionist/nutritionist_sessions.dart';
import '../../services/questions-webservice.dart';
import '../../services/user_services/coach-webservice.dart';
import '../../services/user_services/members-webservice.dart';
import '../../services/user_services/nutritionist-service.dart';
import '../../widget/global.dart';

class AdminCubit extends Cubit<AdminStates>{
  AdminCubit():super(AdminInitState());
  static AdminCubit get(context)=>BlocProvider.of(context);
  final String local=Constants.defaultUrl;
  //Bottom Nav Bar Screen (AdminUtil)
  int bottomNavBarIndex=0;
  List<User> allUsers = [];

  void changeBottomNavBarIndex(int index){
    bottomNavBarIndex=index;
    emit(ChangeBottomNavBarIndexState());
  }
  void updateState(){emit(NewState());}

  ////////////////////////////users//////////////////////////////////////////
  bool isLoadingUser=true;
  Future<void> fetchAllUser()async {
    await MembersWebService.fetchMembers();
    await CoachWebService.fetchCoaches();
    await NutritionistWebservice.fetchNutritionists();
    isLoadingUser=false;
    emit(FetchUsersSuccessState());
  }
  bool isLoadingBranch=true;
  Future<void> fetchAllBranches()async {
    await BranchService.fetchBranches();
    isLoadingBranch=false;
    emit(FetchBranchesSuccessState());
  }

  bool isLoadingAnnouncements=true;
  Future<void> fetchAllAnnouncements()async {
    await AnnouncementsServices.fetchAnnouncements();
    isLoadingAnnouncements=false;
    emit(FetchAnnouncementsSuccessState());
  }

  bool isLoadingEquipments=true;
  Future<void> fetchAllEquipments()async {
    await EquipmentsService.fetchEquipments();
    isLoadingEquipments=false;
    emit(FetchEquipmentsSuccessState());
  }
  bool isLoadingClasses=true;
  Future<void> fetchAllClasses()async {
    await ClassesServices.fetchClasses();
    isLoadingClasses=false;
    emit(FetchClassesSuccessState());
  }

  bool isLoadingNutritionistSessions=true;
  Future<void> fetchAllNutritionistSessions()async {
    await NutritionistSessionsServices.fetchNutritionistSessions();
    isLoadingNutritionistSessions=false;
    emit(FetchNutritionistSessionsSuccessState());
  }

  bool isLoadingMembersShips=true;
  Future<void> fetchAllMembersShips()async {
    await MembershipsWebservice.fetchMemberships();
    isLoadingMembersShips=false;
    emit(FetchMembershipsSuccessState());
  }

  bool isLoadingQuestions=true;
  Future<void> fetchAllQuestions()async {
    await QuestionsWebservice.fetchQuestions();
    isLoadingQuestions=false;
    emit(FetchQuestionsSuccessState());
  }



  void addUserSuccess(){emit(CreateUserSuccessState());}
  void addUserError(){emit(CreateUserErrorState());}
  void updateUserSuccess(){emit(UpdateUsersSuccessState());}
  void updateUserError(){emit(UpdateUsersErrorState());}
  void deleteUserSuccess(){emit(DeleteUsersSuccessState());}
  void deleteUserError(){emit(DeleteUsersErrorState());}
  void assignMemberSuccess(){emit(AssignMemberSuccessState());}
  void assignMemberError(){emit(AssignMemberErrorState());}
  void deleteAnnouncementsSuccess(){emit(DeleteAnnouncementsSuccessState());}
  void deleteAnnouncementsError(){emit(DeleteAnnouncementsErrorState());}
  void addAnnouncementsSuccess(){emit(AddAnnouncementsSuccessState());}
  void addAnnouncementsError(){emit(AddAnnouncementsErrorState());}
  void editAnnouncementsSuccess(){emit(EditAnnouncementsSuccessState());}
  void editAnnouncementsError(){emit(EditAnnouncementsErrorState());}
  void addEquipmentsLoading(){emit(AddEquipmentsLoadingState());}
  void addEquipmentsSuccess(){emit(AddEquipmentsSuccessState());}
  void addEquipmentsError(){emit(AddEquipmentsErrorState());}
  void editEquipmentsSuccess(){emit(UpdateEquipmentsSuccessState());}
  void editEquipmentsError(){emit(UpdateEquipmentsErrorState());}
  void deleteEquipmentsSuccess(){emit(DeleteEquipmentsErrorState());}
  void deleteEquipmentsError(){emit(DeleteEquipmentsErrorState());}
  void addClassesSuccess(){emit(AddClassesSuccessState());}
  void addClassesError(){emit(AddClassesErrorState());}
  void editClassesLoading(){emit(UpdateClassesLoadingState());}
  void editClassesSuccess(){emit(UpdateClassesSuccessState());}
  void editClassesError(){emit(UpdateClassesErrorState());}
  void deleteClassesLoading(){emit(DeleteClassesLoadingState());}
  void deleteClassesSuccess(){emit(DeleteClassesSuccessState());}
  void deleteClassesError(){emit(DeleteClassesErrorState());}

  void addNutritionistSessionsSuccess(){emit(AddNutritionistSessionsSuccessState());}
  void addNutritionistSessionsError(){emit(AddNutritionistSessionsErrorState());}
  void editNutritionistSessionsSuccess(){emit(UpdateNutritionistSessionsSuccessState());}
  void editNutritionistSessionsError(){emit(UpdateNutritionistSessionsErrorState());}
  void deleteNutritionistSessionsLoading(){emit(DeleteNutritionistSessionsLoadingState());}
  void deleteNutritionistSessionsSuccess(){emit(DeleteNutritionistSessionsSuccessState());}
  void deleteNutritionistSessionsError(){emit(DeleteNutritionistSessionsErrorState());}

  //Memberships
  void addMembershipsSuccess(){emit(AddMembershipsSuccessState());}
  void addMembershipsError(){emit(AddMembershipsErrorState());}

  void editMembershipsSuccess(){emit(EditMembershipsSuccessState());}
  void editMembershipsError(){emit(EditMembershipsErrorState());}

  void deleteMembershipsLoading(){emit(DeleteMembershipsLoadingState());}
  void deleteMembershipsSuccess(){emit(DeleteMembershipsSuccessState());}
  void deleteMembershipsError(){emit(DeleteMembershipsErrorState());}


  void fetchUsers() async{//NOT used
    String token = Global.token;
    http.get(Uri.parse('$local/api/users/getAll'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }).then((value) {
      String data = value.body;
      var jsonData = jsonDecode(data);
      if(jsonData['status']==true){
        jsonData['User'].forEach((item){
          //allUsers.add(User.fromJson(item, 0));
        });

        emit(FetchUsersSuccessState());
      }
    }).catchError((error){
      print("fetch users error ${error.toString()}");
      emit(FetchUsersErrorState());
    });
  }

  //add User
  void addAmin(
  {
    @required String name,
    @required String number,
    @required String gender,
    @required String email,
    @required String password,
    @required String role,
    @required String photo,
    @required String bio,
    @required String branchId,
    @required BuildContext context,
    @required CreateCubit createCubit,
  }
  )  {
    createCubit.loading1();
    String token = Global.token;
    http.post(
      Uri.parse('${Constants.defaultUrl}/api/users/store'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'number': number,
        'gender': gender,
        'email': email,
        'password': password,
        'role': role,
        'photo': photo,
        'bio': bio,
        'branch_id': branchId,
      }),
    ).then((value) {
      String data = value.body;
      var jsonData = jsonDecode(data);
      if(jsonData['status']==true){
        // User newUser=User.fromJson(jsonData['user'],0);
        // allUsers.add(newUser);
        emit(CreateUserSuccessState());
        Navigator.pop(context);
        createCubit.finishLoading();
        myToast(message: "Created Successfully",color:Colors.green);
      }
      else{
        myToast(message: jsonData['msg'],color:Colors.red);
        createCubit.finishLoading();
      }
    }).catchError((error){
      print(error.toString());
      Navigator.pop(context);
      emit(CreateUserErrorState());
    });
  }

  void deleteUser({@required int id,@required BuildContext context,@required CreateCubit cubit})
  {
    String token = Global.token;
    cubit.loading1();
    http.delete(
      Uri.parse('${Constants.defaultUrl}/api/users/delete/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    ).then((value) {
      String data = value.body;
      var jsonData = jsonDecode(data);
      if(jsonData['status']==true){
        for(int i=0;i<allUsers.length;i++){
          if(allUsers.elementAt(i).user_id==id){
            allUsers.removeAt(i);
            break;
          }
        }
        cubit.finishLoading();
        emit(DeleteUsersSuccessState());
        Navigator.pop(context);
        myToast(message: "Deleted Successfully",color:Colors.green);
      }
      else{
        cubit.finishLoading();
        myToast(message: jsonData['msg'],color:Colors.red);
      }
    }).catchError((error){
      print(error.toString());
      cubit.finishLoading();
      myToast(message: "Deleted Failed",color:Colors.red);
      Navigator.pop(context);
      emit(DeleteUsersErrorState());
    });
  }

  //edit User
  void updateAdmin({
    int id,
    String name,
    String number,
    String gender,
    String email,
    String password,
    String role,
    String photo,
    String bio,
    String branchId,
    CreateCubit myCubit,
    BuildContext context
})
  {
    String token =Global.token;
    myCubit.loading2();
    http.put(
      Uri.parse('${Constants.defaultUrl}/api/users/update/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'number': number,
        'gender': gender,
        'email': email,
        'password': password,
        'role': role,
        'photo': photo,
        'bio': bio,
        'branch_id': branchId,
      }),
    ).then((value) {
      String data = value.body;
      var jsonData = jsonDecode(data);
      print(jsonData);
      if(jsonData['status']==true){
        for(int i=0;i<allUsers.length;i++){
          if(allUsers.elementAt(i).user_id==id){
            //allUsers[i]=User.fromJson(json)
            break;
          }
        }
        myCubit.finishLoading();
        emit(UpdateUsersSuccessState());
        Navigator.pop(context);
        myToast(message: "updated Successfully",color:Colors.green);
      }
      else{
        myCubit.finishLoading();
        myToast(message: jsonData['msg'],color:Colors.red);
      }
      emit(UpdateUsersSuccessState());
    }).catchError((error){
      myCubit.finishLoading();
      myToast(message: "Updated Failed",color:Colors.red);
      print(error.toString());
      Navigator.pop(context);
      emit(UpdateUsersErrorState());
    });
  }

}
