import 'package:flutter/cupertino.dart';
import 'package:gym_project/models/event.dart';
import 'package:gym_project/services/event-webservice.dart';

class EventViewModel extends ChangeNotifier {
  Event event;
  List<Event> AllEvents =[];
  List<Event> UpcomingEvents =[];
  List<Event> PreviousEvents =[];
  Event singleEvent =Event();


  String get title {
    return event.title;
  }
  
  String get description {
    return event.description;
  }

  String get price {
    return event.price;
  }

  String get starttime {
    return event.startTime;
  }

  String get endTime {
    return event.endTime;
  }

  int get tickets {
    return event.ticketsAvailable;
  }

  Future<void> getAllEvents(token) async
  {
    AllEvents= await EventWebService(token).GetAllEvents();
    notifyListeners();
  }

  Future<void> getUpcomingEvents(token) async
  {
    UpcomingEvents= await EventWebService(token).GetUpcomingEvents();
    notifyListeners();
  }

  Future<void> getPreviousEvents(token) async
  {
    PreviousEvents= await EventWebService(token).GetPreviousEvents();
    notifyListeners();
  }

  Future<void> addEvent(title, description, startTime, endTime, price, status, tickets,token) async
  {
    await EventWebService(token).addEvent(title, description, startTime, endTime, price, status, tickets);
    notifyListeners();
  }

  Future<void> editEvent(id,title, description, startTime, endTime, price, status, tickets,token) async
  {
    await EventWebService(token).editEvent(id,title, description, startTime, endTime, price, status, tickets);
    notifyListeners();
  }

  Future<void> deleteEvent(id,token) async
  {
    await EventWebService(token).deleteEvent(id);
    notifyListeners();

  }

   Future<void> registerEvent(id,token) async
  {
    await EventWebService(token).registerEvent(id);
    notifyListeners();

  }

  Future<void> getEventById(int id, String token) async {
    this.singleEvent =
        await EventWebService(token).getEventByID(id);
    // print(singleEvent.title);    
    notifyListeners();
  }

  List<Event> get allEvents => AllEvents;
  List<Event> get upcomingEvents => UpcomingEvents;
  List<Event> get previousEvents => PreviousEvents;
  Event get currentevent => singleEvent;


  
}
