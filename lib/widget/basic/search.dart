import 'package:flutter/material.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/categories.dart';
import 'package:shopping/model/homescreenModel.dart';
import 'package:shopping/model/topRestourants.dart';
import 'package:shopping/widget/basic/restaurants.dart';
import 'isearch.dart';

bool _filterWindow = false;

bHomeScreenSearch(List<Widget> list, TextEditingController _searchController, Function() onPressRightIcon,
    Function(String) _onPressSearch, Function() redraw, double windowWidth){
  list.add(Container(
    color: appSettings.searchBackgroundColor,
    height: 50,
    padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
    child: Row(
      children: [
        Expanded(child: ISearch(
          radius: appSettings.radius,
          shadow: appSettings.shadow,
          direction: strings.direction,
          hint: strings.get(34), // "Search",
          icon: Icons.search,
          iconRight: Icons.close,
          onPressRightIcon: (){
            onPressRightIcon();
          },
          onChangeText: _onPressSearch,
          colorDefaultText: theme.colorDefaultText,
          colorBackground: theme.colorBackgroundDialog,
          controller: _searchController,
        )),
        SizedBox(width: 10,),
        Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: UnconstrainedBox(
                  child: Container(
                      height: 30,
                      width: 30,
                      child: Image.asset("assets/filter.png",
                        fit: BoxFit.contain, color: theme.colorDefaultText,
                      )
                  )),
            ),
            Positioned.fill(
              child: Material(
                  color: Colors.transparent,
                  shape: CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.grey[400],
                    onTap: (){
                      _filterWindow = !_filterWindow;
                      redraw();
                    }, // needed
                  )),
            )
          ],
        ),
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

String restaurantSearchValue = "0";
String categoriesSearchValue = "0";

restaurantsComboBox(double windowWidth, Function redraw){
  List<DropdownMenuItem> menuItems = [];
  menuItems.add(DropdownMenuItem(
    child: Text(strings.get(133), style: theme.text14,), // All
    value: "0",
  ),);
  for (var item in nearYourRestaurants) {
    if (!isInCity(item,))
      continue;
    menuItems.add(DropdownMenuItem(
      child: Text(item.name, style: theme.text14,),
      value: item.id,
    ),);
  }
  return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      width: windowWidth,
      child: Row(
        children: [
          Text(strings.get(267), style: theme.text14bold,), // Market
          SizedBox(width: 10,),
          Expanded(child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                  isExpanded: true,
                  value: restaurantSearchValue,
                  items: menuItems,
                  onChanged: (value) {
                    restaurantSearchValue = value;
                    redraw();
                  })
          ))
        ],
      ));
}

cateroriesComboBox(double windowWidth, Function redraw){
  List<DropdownMenuItem> menuItems = [];
  menuItems.add(DropdownMenuItem(
    child: Text(strings.get(133), style: theme.text14,), // All
    value: "0",
  ),);
  for (var item in categories) {
    menuItems.add(DropdownMenuItem(
      child: Text(item.name, style: theme.text14,),
      value: item.id,
    ),);
  }
  return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      width: windowWidth,
      child: Row(
        children: [
          Text(strings.get(268), style: theme.text14bold,), // Categories
          SizedBox(width: 10,),
          Expanded(child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                  isExpanded: true,
                  value: categoriesSearchValue,
                  items: menuItems,
                  onChanged: (value) {
                    categoriesSearchValue = value;
                    redraw();
                  })
          ))
        ],
      ));
}
