import 'package:flutter/material.dart';
import 'package:package_tracker/requestTool/ServiceEnum.dart';

Widget _buildList(int index, List<String> favorites) {
  List<String> list = ServiceEnum.values.map((e) => e.displayName).toList();
  list.sort();
  String item = list[index];
  return StatefulBuilder(
      builder: (context, setState)
      {
        return ListTile(
          title: Text(
              item
          ),
          onTap: (){
            if(favorites.contains(item)) {
              favorites.remove(item);
            }else{
              favorites.add(item);
            }
            setState((){});
          },
          trailing: favorites.contains(item) ?
          const Icon(
            Icons.check,
            color: Colors.indigo,
          ):
          Icon(
            Icons.check,
            color: Colors.grey.shade300,
          ),
        );
      }
    );
}


Future<dynamic> selectFavoriteDialog(BuildContext context, List<String> displayCarriers) async{
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                  scrollable: true,
                  content: SizedBox(
                    // Increate size everytime a new warning is added
                    height: 600,
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
                        const SizedBox(height: 10),
                        const Center(
                          child: Text( "Select Carriers",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 450,
                          child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                    itemCount: ServiceEnum.values.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return _buildList(index, displayCarriers);
                                    },
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                  ),
                                ],
                              )
                          ),
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                              customBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              onTap: (){
                                Navigator.of(context).pop(displayCarriers);
                              },
                              child: Container(
                                margin: const EdgeInsets.all(20),
                                child: Text(
                                  "Save Changes",
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