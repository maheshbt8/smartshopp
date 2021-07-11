import 'package:flutter/material.dart';
import 'package:fooddelivery/main.dart';
import 'package:fooddelivery/model/homescreenModel.dart';
import 'package:fooddelivery/widget/basic/search.dart';

bool _filterWindow = false;

sHomeScreenSearch(List<Widget> list, TextEditingController _searchController, Function() onPressRightIcon,
    Function(String) _onPressSearch, Function() redraw, double windowWidth){

  if (_searchController.text.isNotEmpty)
    list.add(Container(
      color: appSettings.searchBackgroundColor,
      height: 50,
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Row(
          children: [
            Expanded(child: Text(strings.get(34), style: theme.text16,)), // Search
            Stack(
              children: <Widget>[

                Container(
                    child: Icon(Icons.close,)
                ),

                Positioned.fill(
                  child: Material(
                      color: Colors.transparent,
                      shape: CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        splashColor: Colors.grey,
                        onTap: (){
                          onPressRightIcon();
                        }, // needed
                      )),
                )
              ],
            ),
          ]
      )));

  list.add(Container(
    color: appSettings.searchBackgroundColor,
    height: 50,
    padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
    child: Row(
      children: [
        Expanded(child: Container(
              height: 40,
              padding: EdgeInsets.only(left: 10, right: 10, ),
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(appSettings.radius),
                border: new Border.all(
                  color: Colors.black.withAlpha(100),
                  width: 0.5,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: TextField(
                    controller: _searchController,
                    onChanged: (String value) async {
                      _onPressSearch(value);
                    },
                    cursorColor: Colors.black,
                    style: TextStyle(fontSize: 14),
                    cursorWidth: 1,
                    obscureText: false,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      hintText: strings.get(311),                 // Search for products
                      hintStyle: TextStyle(fontSize: 14),
                    ),
                  )),

                  SizedBox(width: 10,),
                  Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: theme.sGreyColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Row(
                          children: [
                            Text(strings.get(312)), // Filter
                            SizedBox(width: 5,),
                            Container(
                                alignment: Alignment.center,
                                child:
                                Icon(Icons.apps,)
                            )
                          ],
                        ),
                        Positioned.fill(
                          child: Material(
                              color: Colors.transparent,
                              shape: CircleBorder(),
                              clipBehavior: Clip.hardEdge,
                              child: InkWell(
                                splashColor: Colors.grey,
                                onTap: (){
                                  _filterWindow = !_filterWindow;
                                  redraw();
                                }, // needed
                              )),
                        )
                      ],
                    ),
                  )


                ],
              )
            )),



      ],
    ),
  ));


  if (_filterWindow)
    list.add(Container(child: Column(
      children: [
        if (theme.multiple)
          restaurantsComboBox(windowWidth, (){redraw();}),
        cateroriesComboBox(windowWidth, (){redraw();}),
        SizedBox(height: 5,),
        Text(strings.get(276), style: theme.text14bold), // "This filter will work throughout the application.",
        SizedBox(height: 10,),
        Container(height: 0.5, color: Colors.black.withAlpha(120))
      ],
    )));
}


