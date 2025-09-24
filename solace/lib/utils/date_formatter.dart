class DateFormatter {
  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  static const List<String> _weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  /// Format date as "MMM d, yyyy - hh:mm a" (e.g., "Dec 25, 2023 - 02:30 PM")
  static String formatDateTimeShort(DateTime date) {
    final month = _months[date.month - 1];
    final day = date.day;
    final year = date.year;
    final hour = date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    
    return '$month $day, $year - $hour:$minute $amPm';
  }

  /// Format date as "EEEE, MMM d, y" (e.g., "Monday, Dec 25, 2023")
  static String formatDateLong(DateTime date) {
    final weekday = _weekdays[date.weekday - 1];
    final month = _months[date.month - 1];
    final day = date.day;
    final year = date.year;
    
    return '$weekday, $month $day, $year';
  }

  /// Format time as "hh:mm a" (e.g., "02:30 PM")
  static String formatTime(DateTime date) {
    final hour = date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    
    return '$hour:$minute $amPm';
  }

  /// Format date as "MMM d" (e.g., "Dec 25")
  static String formatDateShort(DateTime date) {
    final month = _months[date.month - 1];
    final day = date.day;
    
    return '$month $day';
  }
}