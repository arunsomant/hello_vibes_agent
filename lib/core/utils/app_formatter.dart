import 'package:intl/intl.dart';

class AppFormatter {
  AppFormatter._();

  static String formatDDDhhmma(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final timeFormat = DateFormat('hh:mm a').format(dateTime).toLowerCase();

    if (dateToCheck == today) {
      return 'Today, $timeFormat';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday, $timeFormat';
    } else {
      final monthDayFormat = DateFormat('dd MMM').format(dateTime);
      return '$monthDayFormat, $timeFormat';
    }
  }

  static String formathms(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final List<String> parts = [];

    if (hours > 0) parts.add('${hours}h');
    if (minutes > 0) parts.add('${minutes}m');
    if (seconds > 0 || parts.isEmpty) parts.add('${seconds}s');

    return parts.join(' ');
  }

  static String formathhmmss(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (hours > 0) {
      return "${hours.toString().padLeft(2, '0')}:$minutes:$seconds";
    } else {
      return "$minutes:$seconds";
    }
  }

  static String formatDDMMYYYY(DateTime? dateTime) {
    if (dateTime == null) return '';
    final dateFormat = DateFormat('dd/MM/yyyy');
    return dateFormat.format(dateTime);
  }

  static DateTime? parseDDMMYYYY(String dateStr) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return dateFormat.tryParse(dateStr);
  }

  static String formatHHMMSS(int seconds) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "$minutesStr:$secondsStr";
    }

    return "$hoursStr:$minutesStr:$secondsStr";
  }
}
