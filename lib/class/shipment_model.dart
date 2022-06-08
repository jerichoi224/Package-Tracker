import 'dart:convert';

import 'package:objectbox/objectbox.dart';

/*
* dart clean
* flutter pub get
* flutter pub run build_runner build --delete-conflicting-outputs
* */

@Entity()
class ShipmentItem {
  int id = 0;
  String caption;
  String trackingId;
  String serviceName;
  bool visible = true;
  String status = "retrieving info";
  int lastUpdateTime = 0;
  String packageJson = "";

  ShipmentItem(
      {
        required this.caption,
        required this.trackingId,
        required this.serviceName
      }
  );

  Map<String, dynamic> getJsonMap()
  {
    if(packageJson.isNotEmpty)
      {
        return jsonDecode(packageJson);
      }
    return {};
    // 5637 1140 5633
  }

  void parseJson()
  {
    Map<String, dynamic> json = getJsonMap();

    if(json.containsKey("state")) {
      status = json["state"]["text"];
    }

  }

  @override
  String toString(){
    return "{id: $id, visible: $visible, json: $packageJson}";
  }
}