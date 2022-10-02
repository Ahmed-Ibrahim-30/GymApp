String formatDateTime(String dateTime) {
  //2021-09-13 14:13:51
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  String year = dateTime.substring(0, 4);
  String month = dateTime.substring(5, 7);
  String day = dateTime.substring(8, 10);
  String time = dateTime.substring(12);
  return '$day ${months[int.parse(month) - 1]} $year at $time';
}

String formatTime(String dateTime) {
  //2021-09-13 14:13:51
  String time = dateTime.substring(12);
  return '$time';
}

String formatDate(String dateTime) {
  //2021-09-13 14:13:51
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  String year = dateTime.substring(0, 4);
  String month = dateTime.substring(5, 7);
  String day = dateTime.substring(8, 10);
  return '$day ${months[int.parse(month) - 1]} $year';
}
