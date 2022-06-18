import 'dart:convert';

import 'package:objectbox/objectbox.dart';
import 'package:package_tracker/requestTool/ShippingStatusEnum.dart';

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
  String status = ShippingStatusEnum.gettingInfo.caption;
  String statusText = "";
  bool delivered = false;
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
      statusText = json["state"]["text"];

      if(json["state"]["id"] == "delivered")
        {
          status = ShippingStatusEnum.delivered.caption;
          delivered = true;
        }

    }
  }

  @override
  String toString(){
    return "{id: $id, visible: $visible, json: $packageJson}";
  }
}