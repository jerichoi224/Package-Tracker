import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_tracker/class/shipment_model.dart';
import 'package:package_tracker/dbTool.dart';

import 'ServiceEnum.dart';

Future<String> requestShippingInfo(ServiceEnum service, String trackingId) async{
  String endpoint = 'https://apis.tracker.delivery/carriers/${service.carrierId}/tracks/$trackingId';

  print(endpoint);
  final response = await http.get(
      Uri.parse(endpoint)
  );
  if (response.statusCode == 200) {
    return utf8.decode(response.bodyBytes);
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
    String updateInfo = await requestShippingInfo(
        ServiceEnum.values.firstWhere((element) => element.displayName == item.serviceName),
        item.trackingId);
    item.packageJson = updateInfo;
    item.parseJson();
    db.updateShipment(item);
  }on Exception catch(e){
    item.status = "Failed to get Info";
    db.updateShipment(item);
    debugPrint(e.toString());
    return false;
  }
  return true;
}