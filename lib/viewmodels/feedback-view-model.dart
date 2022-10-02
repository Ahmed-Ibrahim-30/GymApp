import 'package:flutter/cupertino.dart';
import 'package:gym_project/models/complaint.dart';
import 'package:gym_project/services/complaint-webservice.dart';

class ComplaintViewModel extends ChangeNotifier {
  Complaint complaint;
  List<Complaint> _allComplaints =[];

  Future<void> getAllComplaints(token) async
  {
    _allComplaints= await ComplaintWebService(token).GetAllComplaints();
    notifyListeners();
  }


  Future<void> addComplaint(title, description,token) async
  {
    await ComplaintWebService(token).addFeedback(title, description);
  }


  List<Complaint> get allComplaints => _allComplaints;

  
}
