String formatDuration(String duration) {
  String finalDuration = 'Duration: ';
  String hours = duration.substring(0, 2);
  if (hours != '00') {
    if (hours[0] == '0') {
      finalDuration += '${hours[1]}h';
    } else {
      finalDuration += '${hours}h';
    }
  }
  String minutes = duration.substring(3, 5);
  if (minutes != '00') {
    if (minutes[0] == '0') {
      finalDuration += ' ${minutes[1]}m';
    } else {
      finalDuration += ' ${minutes}m';
    }
  }
  if (duration.length == 8) {
    String seconds = duration.substring(6);
    if (seconds != '00') {
      if (seconds[0] == '0') {
        finalDuration += ' ${seconds[1]}s';
      } else {
        finalDuration += ' ${seconds}s';
      }
    }
  }
  return finalDuration;
}
