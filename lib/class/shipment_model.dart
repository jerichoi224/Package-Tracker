import 'package:objectbox/objectbox.dart';

@Entity()
class ShipmentItem {
  int id = 0;
  String caption;
  String trackingId;
  String serviceName;
  bool visible = true;
  String status = "retrieving info";
  int lastUpdateTime = 0;
  Map<String, dynamic> packageJson = {};
  List<dynamic> progress = [];

  ShipmentItem(
      {
        required this.caption,
        required this.trackingId,
        required this.serviceName
      }
  );

  void parseJson()
  {
    if(packageJson.containsKey("state")) {
      status = packageJson["state"]["text"];
    }

    if(packageJson.containsKey("progresses"))
      {
        progress = packageJson["progresses"];
      }
    // TODO: work on shipping history 5637 1140 5633
  }

  @override
  String toString(){
    return "{id: $id, visible: $visible, progress: $progress";
  }
}