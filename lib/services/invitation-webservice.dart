import 'dart:convert';
import 'package:gym_project/constants.dart';
import 'package:gym_project/models/invitation.dart';
import 'package:http/http.dart' as http;


class InvitationWebService {
  final String local = Constants.defaultUrl;
  String token;
  InvitationWebService(this.token);

  Future<List<Invitation>> GetAllInvitations() async {
    final response = await http.get(
      Uri.parse('$local/api/invitations'),
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
      if (result['msg'] == 'There are no Invitations') return [];
      Iterable list = result['invitations'];
      return list.map((invitation) => Invitation.fromJson(invitation)).toList();
    } else {
      throw Exception('Failed to get Invitations.');
    }
  }

  Future<void> addInvitation(String guestName, String phoneNumber) async {
    final response = await http.post(
      Uri.parse('$local/api/invitations/create'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Accept': '*/*',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'name': guestName,
        'number': phoneNumber,
      }),
    );
    if (response.statusCode == 200) {
      print(response.body);
      final result = json.decode(response.body);
      if (result['msg'] != 'invitation Added correctly')
        return 'invitation Added correctly';
    } else {
      throw Exception('Failed to add invitation.');
    }
  }

  Future<void> deleteInvitation(int id) async {
    final response = await http.delete(
      Uri.parse('$local/api/invitations/$id'),
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
      if (result['msg'] != 'invitation deleted correctly')
        return 'invitation Deleted correctly';
    } else {
      throw Exception('Failed to delete invitation.');
    }
  }
}
