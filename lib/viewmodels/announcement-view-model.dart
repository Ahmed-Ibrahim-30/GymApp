import 'package:gym_project/models/announcement.dart';
import 'package:intl/intl.dart';

class AnnouncementViewModel {
  Announcement _announcement;
  AnnouncementViewModel({Announcement announcement})
      : _announcement = announcement;

  int get id => _announcement.id;
  String get title => _announcement.title;
  String get description => _announcement.description;
  String get date =>
      DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(_announcement.date).add(Duration(hours: 2))) +
      ' at ' +
      DateFormat('kk:mm a')
          .format(DateTime.parse(_announcement.date).add(Duration(hours: 2)));
}
