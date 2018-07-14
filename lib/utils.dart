import 'dart:convert' show json;
import 'package:url_launcher/url_launcher.dart';


convertToString(dynamic value, [String defaultValue]){

  if(value == null){
    return defaultValue;
  }

  if((value is int) || (value is double)){
    return value.toString();
  }

  if((value is Map) ?? (value is List)){
    return json.encode(value);
  }

  return value;

}

void openURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}