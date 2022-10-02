import 'dart:convert';
import 'package:gym_project/constants.dart';
import 'package:gym_project/models/complaint.dart';
import 'package:http/http.dart' as http;

class ComplaintWebService {
  final String local = Constants.defaultUrl;
  String token;
  ComplaintWebService(this.token);

  Future<List<Complaint>> GetAllComplaints() async {
    final response = await http.get(
      Uri.parse('$local/api/feedbacks'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Accept': '*/*',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['msg'] == 'There are no Complaints') return [];
      print(result['feedbacks'][0]['user']['name']);
      Iterable list = result['feedbacks'];
      return list.map((feedback) => Complaint.fromJson(feedback)).toList();
    } else {
      throw Exception('Failed to get Complaints.');
    }
  }

  Future<void> addFeedback(String title, String description) async {
    final response = await http.post(
      Uri.parse('$local/api/feedbacks/create'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Accept': '*/*',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'description': description,
        'type': 'Feedback'
      }),
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['msg'] != 'Feedback Added correctly')
        return 'Feedback Added correctly';
    } else {
      throw Exception('Failed to add feedback.');
    }
  }
}
