import 'package:intl/intl.dart';

formatDate(String date) {
  DateTime parseDate = DateFormat("yyyy-MM-dd").parse(date);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('MMMM dd, yyyy');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}
