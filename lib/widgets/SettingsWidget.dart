import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:package_tracker/dbTool.dart';
import 'package:package_tracker/requestTool/ServiceEnum.dart';
import 'package:package_tracker/util/customWidgets.dart';
import 'package:package_tracker/widgets/SelectFavoriteDIalog.dart';

class SettingsWidget extends StatefulWidget {
  final dataStore db;
  const SettingsWidget({Key? key, required this.db}): super(key: key);

  @override
  State createState() => _SettingsState();
}

class _SettingsState extends State<SettingsWidget> {
  bool useFavorite = false;

  @override
  void initState() {
    super.initState();
    if(widget.db.getPref("useFavorite") == true)
      {
        useFavorite = true;
      }
    widget.db.setPref("useFavorite", useFavorite);
  }

  Widget div = const Divider(
    height: 1,
    color: Colors.grey,
  );

  TextStyle menuCategory = const TextStyle(
    color: Colors.indigo,
    fontWeight: FontWeight.bold,
    fontSize: 16
  );

  TextStyle menuText = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontSize: 14
  );


  void selectFavorite(BuildContext context) async {
    List<String> displayCarriers =  [];

    dynamic carrierList = widget.db.getPref("displayCarrier") ?? ServiceEnum.values.map((e) => e.displayName).toList();
    if(carrierList.runtimeType == List<String>)
      {
        displayCarriers = carrierList;
      }
    displayCarriers.sort();
    List<String> duplicate = displayCarriers.toSet().toList();
    final result = await selectFavoriteDialog(context, displayCarriers);
    if(result.runtimeType == List<String>) {
      result.sort();
      widget.db.setPref("displayCarrier", result);
    }else{
      widget.db.setPref("displayCarrier", duplicate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Settings"),
            elevation:0,
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
             child:Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 PaddedText("Carrier Settings",
                   padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                   style: menuCategory,
                 ),
                 ListTile(
                   dense: true,
                     contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                     title: Text("Select Carriers to Display",
                      style: menuText,
                     ),
                    onTap: (){
                       selectFavorite(context);
                    },
                 ),
                 div,
                 ListTile(
                   contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                   title: Text("Set Frequently Used as Favorite",
                     style: menuText,
                   ),
                   trailing: useFavorite ?
                   const Icon(
                     Icons.check,
                     color: Colors.indigo,
                   ):
                   Icon(
                     Icons.check,
                     color: Colors.grey.shade300,
                   ),
                   onTap: (){
                     useFavorite = !useFavorite;
                     widget.db.setPref("useFavorite", useFavorite);
                     setState((){});
                   },
                 ),
                 div,
               ]
             )
          )
        )
    );
  }
}