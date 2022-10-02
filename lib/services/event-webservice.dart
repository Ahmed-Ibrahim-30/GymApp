import 'dart:convert';
import 'package:gym_project/constants.dart';
import 'package:gym_project/models/event.dart';

import 'package:http/http.dart' as http;

const portNum = '8000';
// const token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjgwMDAvYXBpL2xvZ2luIiwiaWF0IjoxNjMyNjU3MTk0LCJleHAiOjE2MzI3NDM1OTQsIm5iZiI6MTYzMjY1NzE5NCwianRpIjoiekNUMmRtTDlvNDFIN0VnMyIsInN1YiI6MjEsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.Ix_wkb_V7FfNCmNj40cY_0cHUKEHTsVyvC64SPs1O5E";

class EventWebService {
  final String local = Constants.defaultUrl;
  String token;
  EventWebService(this.token);

  Future<List<Event>> GetAllEvents() async {
    final response = await http.get(
      Uri.parse('$local/api/events'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Accept': '*/*',
      },
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['msg'] == 'There are no events') return [];
      Iterable list = result['events'];
      return list.map((event) => Event.fromJson(event)).toList();
    } else {
      throw Exception('Failed to get events.');
    }
  }

  Future<List<Event>> GetUpcomingEvents() async {
    final response = await http.get(
      Uri.parse('$local/api/users/upcomingevents'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Accept': '*/*',
        'Authorization': 'Bearer $token'
      },
    );
    final result = json.decode(response.body);
    print(result);
    if (response.statusCode == 200) {
      if (result['msg'] == 'No Upcoming events') return [];
      Iterable list = result['events'];
      return list.map((event) => Event.fromJson(event)).toList();
    } else {
      throw Exception('Failed to get events.');
    }
  }

  Future<List<Event>> GetPreviousEvents() async {
    final response = await http.get(
      Uri.parse('$local/api/users/pastevents'),
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
      if (result['msg'] == 'No Previous events') return [];
      Iterable list = result['events'];
      return list.map((event) => Event.fromJson(event)).toList();
    } else {
      throw Exception('Failed to get events.');
    }
  }

  Future<void> addEvent(String title, String description, DateTime startTime,
      DateTime endTime, String price, String status, String tickets) async {
    final response = await http.post(
      Uri.parse('$local/api/events/create'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Accept': '*/*',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        "title": title,
        "description": description,
        "start_time": startTime.toString(),
        "end_time": endTime.toString(),
        "price": price,
        "status": status,
        "tickets_available": tickets,
      }),
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['msg'] != 'Event Added correctly')
        return 'Event Added correctly';
    } else {
      throw Exception('Failed to add event.');
    }
  }

  Future<void> editEvent(
      int id,
      String title,
      String description,
      DateTime startTime,
      DateTime endTime,
      String price,
      String status,
      String tickets) async {
    final response = await http.post(
      Uri.parse('$local/api/events/edit/$id'),
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
        'start_time': startTime.toString(),
        'end_time': endTime.toString(),
        'price': price,
        'status': status,
        'tickets_available': tickets,
      }),
    );
    if (response.statusCode == 200) {
      print(response.body);
      final result = json.decode(response.body);
      if (result['msg'] != 'Event Updated correctly')
        return 'Event Updated correctly';
    } else {
      throw Exception('Failed to update event.');
    }
  }

  Future<void> deleteEvent(int id) async {
    final response = await http.delete(
      Uri.parse('$local/api/events/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Accept': '*/*',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      final result = json.decode(response.body);
      if (result['msg'] != 'Event deleted correctly')
        return 'Event Deleted correctly';
    } else {
      throw Exception('Failed to delete event.');
    }
  }

  Future<void> registerEvent(int id) async {
    final response = await http.post(
      Uri.parse('$local/api/events/$id/register'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        
        'Access-Control-Allow-Methods': 'GET, POST, PUT, PATCH, DELETE',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        'Accept': '*/*',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(<String, String>{
        'status': 'Booked',
      }),
    );
    if (response.statusCode == 200) {
      print(response.body);
      final result = json.decode(response.body);
      if (result['msg'] != 'Congratulation you are registered !!')
        return 'Congratulation you are registered !!';
    } else {
      return ('User already registered in the event!');
    }
  }

  Future<Event> getEventByID(int id) async {
    final response = await http.get(
      Uri.parse('$local/api/events/$id'),
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
      if (result['msg'] == 'There is no event with this id') return null;
      return Event.fromJson(result['event']);
    } else {
      throw Exception('Failed to get event.');
    }
  }
}
