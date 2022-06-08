import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_tracker/class/shipment_model.dart';
import 'package:package_tracker/dbTool.dart';

import 'ServiceEnum.dart';

Future<Map<String, dynamic>> requestShippingInfo(ServiceEnum service, String trackingId) async{
  String endpoint = 'https://apis.tracker.delivery/carriers/${service.carrierId}/tracks/$trackingId';

  print(endpoint);
  final response = await http.get(
      Uri.parse(endpoint)
  );
  if (response.statusCode == 200) {
    return jsonDecode(utf8.decode(response.bodyBytes));
  } else {
    throw Exception(
      'Failed to get response: ${response.statusCode}'
    );
  }
}

Future<bool> updateShipment(dataStore db, int id) async
{
  ShipmentItem item = db.shipmentList.firstWhere((element) => element.id == id);

  try{
    Map<String, dynamic> updateInfo = await requestShippingInfo(
        ServiceEnum.values.firstWhere((element) => element.displayName == item.serviceName),
        item.trackingId);

    item.packageJson = updateInfo;
    item.parseJson();
    db.shipmentBox.put(item);
    print("post put");
    print(db.shipmentBox.getAll());
    db.replaceShipment(id, item);
  }on Exception catch(e){
    debugPrint(e.toString());
    return false;
  }
  return true;
}