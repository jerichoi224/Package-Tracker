import 'package:flutter/material.dart';
import 'package:package_tracker/class/shipment_model.dart';
import 'package:package_tracker/dbTool.dart';
import 'package:package_tracker/requestTool/requestAPI.dart';
import 'package:package_tracker/util/stringTools.dart';
import 'package:package_tracker/widgets/AddPackageDialog.dart';
import 'package:package_tracker/widgets/SettingsWidget.dart';
import 'package:package_tracker/widgets/ViewShipmentWidget.dart';

class HomeWidget extends StatefulWidget {
  final BuildContext parentCtx;
  final dataStore db;

  const HomeWidget({super.key, required this.parentCtx, required this.db});

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<HomeWidget>{

  List<ShipmentItem> shipmentList = [
  ];

  @override
  void initState(){
    super.initState();
    updateList();
  }

  void updateList()
  {
    setState((){
      shipmentList = widget.db.shipmentList.where((element) => element.visible).toList();
    });
  }

  void updateAllShipments(){
    for(ShipmentItem item in shipmentList)
      {
        if(item.visible && !item.delivered)
          {
            updateShipment(widget.db, item.id).then((value){
              widget.db.updateShipment(item);
              updateList();
            });
          }
      }
  }

  void openSettings(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsWidget(db: widget.db,),
        ));

    if(result.runtimeType == bool && result)
    {
      setState(() {});
    }
  }

  void addPackage(BuildContext context) async {
    final result = await showAddPackageDialog(context, widget.db);
    if(result.runtimeType == int) {
      updateList();

      ShipmentItem? item = widget.db.shipmentBox.get(result);
      if(item != null)
        {
          updateShipment(widget.db, item.id).then((value){
              widget.db.updateShipment(item);
              updateList();
          });
        }
    }
  }

  void viewPackage(BuildContext context, int id) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewShipmentWidget(db: widget.db, id: id),
        ));

    if(result.runtimeType == bool && result) {
      updateList();
    }
  }


  Widget _buildCards(int index) {
    ShipmentItem item = shipmentList[index];
    return Dismissible(
        background: Container(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.delete, color: Colors.black),
                )
              ],
            ),
          ),
        ),
        secondaryBackground: Container(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.delete, color: Colors.black),
                )
              ],
            ),
          ),
        ),
       key: UniqueKey(),
       onDismissed: (DismissDirection direction) {
          item.visible = false;
          widget.db.updateShipment(item);
          updateList();
       },
       child: Container(
          color: Colors.transparent,
          height: 90,
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  onTap: () {
                    viewPackage(context, item.id);
                  },
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                              width: 100,
                              child: Icon(
                                Icons.inbox,
                                size: 60,
                              )
                          ),
                          RichText(
                            text: TextSpan(
                                style: const TextStyle(color: Colors.black),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: "${item.caption}\n",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  TextSpan(
                                      text: "${item.statusText}\n",
                                      style: TextStyle(
                                        fontSize: 12,
                                      )
                                  ),
                                  TextSpan(
                                      text: "Last Update: ${updateDateFormat(item.lastUpdateTime)}",
                                      style: TextStyle(
                                        fontSize: 12,
                                      )
                                  )
                                ]
                            ),
                          )
                        ],
                      )
                  )
              )
          )
      )
    );
  }

  Widget menu()
  {
    return PopupMenuButton(
        elevation: 5,
        icon: const Icon(
            Icons.menu,
          color: Colors.white,
        ),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 0,
            child: Text("Settings"),
          ),
        ],

        onSelected: (selectedIndex) {
          // Edit
          if(selectedIndex == 0){
            openSettings(context);
          }
          // Delete
          else if(selectedIndex == 1) {

          }
        },
      );
  }

  @override
  Widget build(BuildContext context){
    // App Loads
    final mediaQueryData = MediaQuery.of(context);
    return MediaQuery(
        data: mediaQueryData.copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                snap: false,
                floating: true,
                backgroundColor: Colors.indigoAccent.shade400,
                collapsedHeight: 100,
                expandedHeight: 200,
                leading: menu(),
                centerTitle: true,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
//                        bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60))
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.none,
                  expandedTitleScale: 1.2,
                  title: const Text("Package Tracker",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  background: Container(
                    color: Colors.transparent,
                  )
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                    [
                      if(shipmentList.isEmpty)
                        Container(
                          // TODO: Show that there's no shipment
                        )
                      else
                        ListView.builder(
                          itemCount: shipmentList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildCards(index);
                          },
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                        ),
                    ]
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              addPackage(context);
            },
            label: const Text('Add Package'),
            icon: const Icon(Icons.add),
            backgroundColor: Colors.indigoAccent,
          ),
        )
    );
  }
}