import 'package:flutter/cupertino.dart';
import 'package:gym_project/models/invitation.dart';
import 'package:gym_project/services/invitation-webservice.dart';

class InvitationViewModel extends ChangeNotifier {
  Invitation invitation;
  List<Invitation> _allInvitations =[];

  Future<void> getAllInvitations(token) async
  {
    _allInvitations= await InvitationWebService(token).GetAllInvitations();
    notifyListeners();
  }


  Future<void> addInvitation(name, number,token) async
  {
    await InvitationWebService(token).addInvitation(name, number);
  }

  Future<void> deleteInvitation(id,token) async
  {
    await InvitationWebService(token).deleteInvitation(id);
  }


  List<Invitation> get allInvitations => _allInvitations;

  
}
