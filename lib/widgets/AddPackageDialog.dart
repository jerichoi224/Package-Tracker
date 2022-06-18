import 'package:flutter/material.dart';
import 'package:package_tracker/class/shipment_model.dart';
import 'package:package_tracker/dbTool.dart';
import 'package:package_tracker/requestTool/ServiceEnum.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:package_tracker/requestTool/requestAPI.dart';
import 'package:package_tracker/util/koreanSearch.dart';

Future<dynamic> showAddPackageDialog(BuildContext context, dataStore db) async{
  String? carrier = "";
  TextEditingController trackingId = new TextEditingController();
  TextEditingController caption = new TextEditingController();

  bool validateId = false;
  bool validateCaption = false;
  bool validateCarrier = false;

  print(db.getPref("displayCarrier"));
  List<String> carriers = db.getPref("displayCarrier") as List<String>;
  print(carriers);
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                scrollable: true,
                content: SizedBox(
                  // Increate size everytime a new warning is added
                  height: 370 + [validateCaption, validateId, validateCarrier].where((element) => element).length * 23,
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topRight,
                        child: InkResponse(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.black26,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text( "Add Package",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text( "Tracking ID",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      TextField(
                        controller: trackingId,
                        onChanged: (String s){
                          setState((){
                            validateId = s.isEmpty;
                          });
                        },
                        decoration: InputDecoration(
                          errorText: validateId ? 'Please Enter Tracking ID' : null,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text( "Package Name",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      TextField(
                        controller: caption,
                        onChanged: (String s){
                          setState((){
                            validateCaption = s.isEmpty;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "e.g. Camera Lens",
                          hintStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.normal,
                            fontSize: 14
                          ),
                          errorText: validateCaption ? 'Please Enter Name for Package' : null,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text( "Carrier",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      DropdownSearch<String>(
                        asyncItems: (filter) => getData(carriers,filter),
                        compareFn: (i, s) => i == s,
                        onChanged: (String? data){
                          setState((){
                            carrier = data;
                            validateCarrier = carrier!.isEmpty;
                          });
                        } ,
                        dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: "Choose Carrier",
                              errorText: validateCarrier ? 'Please choose Carrier' : null,
                            )
                        ),
                        popupProps: PopupPropsMultiSelection.modalBottomSheet(
                          isFilterOnline: true,
                          showSelectedItems: true,
                          showSearchBox: true,
                          itemBuilder: _popupItemBuilder,
                          favoriteItemProps: FavoriteItemProps(
                            showFavoriteItems: true,
                            favoriteItems: (us) {
                              List<String> favorites = db.getPref("favorites") ?? [];
                              return us
                                  .where((e) => favorites.contains(e))
                                  .toList();
                            },
                          ),
                        ),
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                            customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            onTap: (){
                              carrier ??= "";
                              validateCarrier = carrier!.isEmpty;
                              validateId = trackingId.text.isEmpty;
                              validateCaption = caption.text.isEmpty;

                              if(validateCarrier || validateCaption || validateId)
                              {
                                setState((){});
                                return;
                              }

                              ShipmentItem item = ShipmentItem(caption: caption.text, trackingId: trackingId.text, serviceName: carrier!);
                              item.lastUpdateTime = DateTime.now().millisecondsSinceEpoch;
                              db.shipmentBox.put(item);
                              db.shipmentList.add(item);
                              Navigator.of(context).pop(item.id);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              child: Text(
                                "Add Package",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.indigoAccent,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                )
            );
          }
        );
      }
  );
}


Future<List<String>> getData(list, filter) async {
  return Future.value(list
      .where((element) => filter.toString().isEmpty || containsKr(element, filter))
      .toList());
}

Widget _popupItemBuilder(
    BuildContext context,
    String? item,
    bool isSelected,
    )
{
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 8),
    decoration: !isSelected
        ? null
        : BoxDecoration(
      border: Border.all(color: Theme.of(context).primaryColor),
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
    ),
    child: ListTile(
      selected: isSelected,
      title: Text(item!),
    ),
  );
}