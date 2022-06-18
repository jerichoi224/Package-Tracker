import 'package:flutter/material.dart';
import 'package:package_tracker/class/shipment_model.dart';
import 'package:package_tracker/dbTool.dart';
import 'package:package_tracker/requestTool/ShippingStatusEnum.dart';
import 'package:package_tracker/requestTool/requestAPI.dart';
import 'package:package_tracker/util/customWidgets.dart';
import 'package:package_tracker/util/stringTools.dart';
import 'package:package_tracker/util/textStyles.dart';

class ViewShipmentWidget extends StatefulWidget {
  final dataStore db;
  final int id;
  const ViewShipmentWidget({Key? key, required this.db, required this.id}): super(key: key);

  @override
  State createState() => _ViewShipmentState();
}

class _ViewShipmentState extends State<ViewShipmentWidget>{
  late ShipmentItem item;
  Map<String, dynamic> json = {};
  List<dynamic> history = [];
  @override
  void initState(){
    super.initState();
    updateItem();
  }

  void updateItem()
  {
    setState((){
      item = widget.db.shipmentList.firstWhere((element) => element.id == widget.id);
      json = item.getJsonMap();
      if(json.containsKey("progresses")){
        history = json["progresses"];
      }
    });
  }

  Widget _buildHistory(int index) {
    Map<String, dynamic> item = history[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PaddedText("${item["status"]["text"]} - ${item["location"]["name"]}",
            padding: EdgeInsets.fromLTRB(10, 10, 0, 5),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold
            )
        ),
        PaddedText(updateDateFormat(DateTime.parse(item["time"]).millisecondsSinceEpoch),
            padding: EdgeInsets.fromLTRB(15, 0, 0, 5),
            style: TextStyle(
                fontSize: 12
            )
        ),
        PaddedText(item["description"],
          padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
          style: TextStyle(
            fontSize: 12
          )
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(
              elevation:0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(item.caption),
            ),
            body: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        PaddedText(item.serviceName,
                                          style: bold(16)
                                        ),
                                        const Spacer(),
                                        PaddedText(item.statusText,
                                            style: normal(16)
                                        ),
                                      ],
                                    ),
                                    PaddedText(item.trackingId),
                                  ],
                                )
                            ),
                          ],
                        )
                      ),
                      if(history.isNotEmpty)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          PaddedText("History",
                              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                              style: TextStyle(
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          Spacer(),
                          PaddedText(updateDateFormat(item.lastUpdateTime),
                            style: TextStyle(
                              fontSize: 14
                            ),
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),

                          ),
                        ],
                        ),
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.all(8.0),
                        child:
                          ListView.builder(
                          itemCount: history.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildHistory(index);
                          },
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                        ),
                      ),
                      if(item.status != ShippingStatusEnum.delivered.caption)
                        Center(
                            child: TextButton(
                                onPressed: () async {
                                  await updateShipment(widget.db, item.id);
                                  if(mounted)
                                    {
                                      updateItem();
                                    }
                                },
                                child: PaddedText("Update Shipment",
                                  padding: const EdgeInsets.all(8),
                                  style: const TextStyle(
                                    color: Colors.indigo
                                  ),
                                )
                            )
                        )
                    ]
                )
            )
        )
    );
  }
}