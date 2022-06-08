import 'package:intl/intl.dart';

final dateTimeFormatter = new DateFormat('yyyy/MM/dd HH:mm');

String updateDateFormat(int millisecondSinceEpoch)
{
  return dateTimeFormatter.format(DateTime.fromMillisecondsSinceEpoch(millisecondSinceEpoch));
}