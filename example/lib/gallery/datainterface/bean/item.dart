import 'package:adhara/adhara.dart';

class Item extends Bean {
  static const String TYPE = "type";
  static const String URL = "url";

  Item([data]) : super(data);

  String get type => data[TYPE];
  String get url => convertToString(data[URL]);

}
