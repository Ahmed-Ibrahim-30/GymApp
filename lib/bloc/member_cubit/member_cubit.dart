import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gym_project/all_data.dart';
import 'package:gym_project/bloc/newCreate/create_bloc.dart';
import 'package:gym_project/services/admin-services/branches-services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../services/admin-services/announcements_services.dart';
import '../../services/claseess_services.dart';
import '../../services/equipment-webservice.dart';
import '../../services/questions-webservice.dart';
import '../../services/user_services/coach-webservice.dart';
import '../../services/user_services/members-webservice.dart';
import '../../services/user_services/nutritionist-service.dart';
import '../../viewmodels/event-view-model.dart';
import '../../widget/global.dart';
import 'member_states.dart';

class MemberCubit extends Cubit<MemberStates>{
  MemberCubit():super(MemberInitState());
  static MemberCubit get(context)=>BlocProvider.of(context);
  final String local=Constants.defaultUrl;
  //Bottom Nav Bar Screen (AdminUtil)
  int bottomNavBarIndex=0;


  bool isLoadingMember=true;
  Future<void> fetchUserCoach()async {
    await MembersWebService.fetchMembers();
    await CoachWebService.fetchCoaches();
    await NutritionistWebservice.fetchNutritionists();
    for(int i=0;i<membersUsers.length;i++){
      if(Global.roleID==membersUsers[i].id){
        userMember=membersUsers[i];
        break;
      }
    }
    isLoadingMember=false;
    emit(Update());
  }

  bool isLoadingAnnouncements=true;
  Future<void> fetchAllAnnouncements()async {
    await AnnouncementsServices.fetchAnnouncements();
    isLoadingAnnouncements=false;
    emit(Update());
  }

  bool isLoadingBranch=true;
  Future<void> fetchAllBranches()async {
    await BranchService.fetchBranches();
    isLoadingBranch=false;
    emit(Update());
  }


  bool isLoadingEquipments=true;
  Future<void> fetchAllEquipments()async {
    await EquipmentsService.fetchEquipments();
    isLoadingEquipments=false;
    emit(Update());
  }
  bool isLoadingClasses=true;
  Future<void> fetchAllClasses()async {
    await ClassesServices.fetchClasses();
    print("Classes size = ${allClasses.length}");
    isLoadingClasses=false;
    emit(Update());
  }



  bool isLoadingQuestions=true;
  Future<void> fetchAllQuestions()async {
    await QuestionsWebservice.fetchQuestions();
    isLoadingQuestions=false;
    emit(Update());
  }

  bool isLoadingEvents=true;
  Future<void>getEventsList(BuildContext context) async{
    String token = Global.token;
    await Provider.of<EventViewModel>(context, listen: false).getAllEvents(token)
        .then((value) {
      allEvents = Provider.of<EventViewModel>(context, listen: false).allEvents;
      print("events = ${allEvents.length}");
    }).catchError((err) {
      print('error occured $err');
    });
  }
  Future<void> fetchAllEvents(BuildContext context)async {
    await getEventsList(context);
    isLoadingEvents=false;
    emit(Update());
  }

  void update(){emit(Update());}



}
