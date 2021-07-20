import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_webservice/places.dart';
import 'package:shopping/main.dart';
import 'package:shopping/model/geolocator.dart';
import 'package:shopping/model/homescreenModel.dart';
import 'package:shopping/widget/basic/isearch.dart';
import 'package:shopping/widget/iboxCircle.dart';

class MapInfoScreen extends StatefulWidget {
  final Function(double, double, String) callback;
  MapInfoScreen({this.callback});
  @override
  _MapInfoScreenState createState() => _MapInfoScreenState();
}

class _MapInfoScreenState extends State<MapInfoScreen> {

  GoogleMapsPlaces places;
  String _searchValue = "";

  _backButtonPress() {
    if (_currentPos != null)
      widget.callback(_currentPos.latitude, _currentPos.longitude, (_textAddress.isNotEmpty) ? _textAddress : _searchValue);

    Navigator.pop(context);
  }

  _onAddressClick(PlacesSearchResult ret){
    _searchResult = [];
    var pos = LatLng(ret.geometry.location.lat, ret.geometry.location.lng);
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: pos,
          zoom: _currentZoom,
        ),
      ),
    );
    _selectPos(pos);
  }

  _onMapTap(LatLng pos) async {
    PlacesSearchResponse response = await places.searchNearbyWithRadius(new Location(lat: pos.latitude, lng: pos.longitude), 20);
    _textAddress = "";
    if (response.results.isNotEmpty) {
      for (var item in response.results)
        if (item.vicinity != null)
          if (item.vicinity.length > _textAddress.length)
            _textAddress = item.vicinity;
    }
    setState(() {
    });
  }

  _onPressSearch(String val) async {
    _searchValue = val;
    PlacesSearchResponse response = await places.searchByText(val);
    print(response.toString());
    _searchResult = [];
    for (var ret in response.results) {
      _searchResult.add(
          Stack(
            children: [
              Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  width: windowWidth,
                  color: theme.colorBackgroundDialog,
                  child: Text(ret.formattedAddress, style: theme.text14bold,)
              ),
              Positioned.fill(
                child: Material(
                    color: Colors.transparent,
                    child:     InkWell(
                      splashColor: Colors.grey[400],
                      onTap: (){
                        _onAddressClick(ret);
                      }, // needed
                    )),
              )

            ],
          )
      );
      _searchResult.add(
          Container(height: 1,
              width: windowWidth,
              color: Colors.grey,
          )
      );
    }
    setState(() {
    });
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  String _mapStyle;
  String _textAddress = "";
  var location = MyLocation();
  double _currentZoom = 12;
  LatLng _currentPos;
  List<Widget> _searchResult = [];

  _init() async {
    places =  GoogleMapsPlaces(apiKey: appSettings.mapapikey);
    Position pos = await location.getCurrent();
    var pos2 = LatLng(pos?.latitude, pos?.longitude);
    _controller.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: pos2, zoom: _currentZoom,)
        ));
    _addMarker(pos?.latitude, pos?.longitude);
  }

  @override
  void initState() {
    _init();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(0, 0), zoom: 12,);
  Set<Marker> markers = {};
  GoogleMapController _controller;


  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    if (_controller != null)
      if (theme.darkMode)
        _controller.setMapStyle(_mapStyle);
      else
        _controller.setMapStyle(null);

    Alignment _buttonsBack = Alignment.bottomLeft;
    Alignment _buttonNavigation = Alignment.bottomRight;
    if (strings.direction == TextDirection.rtl){
      _buttonsBack = Alignment.bottomRight;
      _buttonNavigation = Alignment.bottomLeft;
    }

    return WillPopScope(
        onWillPop: () async {
          _backButtonPress();
          return true;
        },
        child: Scaffold(
        backgroundColor: theme.colorBackground,
        body: Directionality(
        textDirection: strings.direction,
        child: Container(
            child: Stack(children: <Widget>[

              _map(),

              Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 10+MediaQuery.of(context).padding.top),
                child: Column(children: [
                  ISearch(
                    radius: appSettings.radius,
                    shadow: appSettings.shadow,
                    direction: strings.direction,
                    hint: strings.get(34), // "Search",
                    icon: Icons.search,
                    onChangeText: _onPressSearch,
                    colorDefaultText: theme.colorDefaultText,
                    colorBackground: theme.colorBackground,
                  ),
              if (_searchResult.isNotEmpty)
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 1),
                    height: 200,
                    width: windowWidth,
                    //color: theme.colorBackgroundDialog,
                    child: ListView(
                      addAutomaticKeepAlives: false,
                      padding: EdgeInsets.only(top: 0),
                      children: _searchResult,
                    ),
                  )

                ],),
              ),

              Container(
                  alignment: _buttonsBack,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _buttonBack(),
                      SizedBox(height: 15,),
                    ],
                  )
              ),

              Container(
                  alignment: _buttonNavigation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _buttonPlus(),
                      _buttonMinus(),
                      _buttonMyLocation(),
                      SizedBox(height: 15,),
                    ],
                  )
              ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      margin: EdgeInsets.only(bottom: 10, right: 70, left: 70),
                      child: Container(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            color: theme.colorBackgroundDialog,
                            borderRadius: new BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withAlpha(40),
                                spreadRadius: 6,
                                blurRadius: 6,
                                offset: Offset(2, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child:
                          Text(
                            (_currentPos != null ) ? "$_textAddress \n ${_currentPos.latitude.toStringAsFixed(6)}, ${_currentPos.longitude.toStringAsFixed(6)}" : "${strings.get(181)}",
                            style: theme.text14bold, textAlign: TextAlign.center,) // ""Select place on map or find address on Search",",
                      )
                  ),
                ),


            ]
            )
        ))));
  }

  _map(){
    return GoogleMap(
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: false, // Whether to show zoom controls (only applicable for Android).
        myLocationEnabled: true,  // For showing your current location on the map with a blue dot.
        myLocationButtonEnabled: false, // This button is used to bring the user location to the center of the camera view.
        initialCameraPosition: _kGooglePlex,
        onCameraMove:(CameraPosition cameraPosition){
          _currentZoom = cameraPosition.zoom;
        },
        onTap: (LatLng pos) {
          _selectPos(pos);
          _onMapTap(pos);
        },
        onLongPress: (LatLng pos) {

        },
        markers: markers != null ? Set<Marker>.from(markers) : null,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          if (theme.darkMode)
            _controller.setMapStyle(_mapStyle);
        });
  }

  _buttonPlus(){
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(child: Icon(Icons.add, size: 30, color: Colors.black.withOpacity(0.5),)),
        ),
        Container(
          height: 60,
          width: 60,
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  _controller.animateCamera(
                    CameraUpdate.zoomIn(),
                  );
                }, // needed
              )),
        )
      ],
    );
  }

  _buttonMinus(){
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(child: Icon(Icons.remove, size: 30, color: Colors.black.withOpacity(0.5),)),
        ),
        Container(
          height: 60,
          width: 60,
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  _controller.animateCamera(
                    CameraUpdate.zoomOut(),
                  );
                }, // needed
              )),
        )
      ],
    );
  }

  _buttonBack(){
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(child: Container(
            margin: EdgeInsets.only(left: 10),
            child: Icon(Icons.arrow_back_ios, size: 30, color: Colors.black.withOpacity(0.5)),)),
        ),
        Container(
          height: 60,
          width: 60,
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  _backButtonPress();
                }, // needed
              )),
        )
      ],
    );
  }

  _buttonMyLocation(){
    return Stack(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          child: IBoxCircle(child: Icon(Icons.my_location, size: 30, color: Colors.black.withOpacity(0.5),)),
        ),
        Container(
          height: 60,
          width: 60,
          child: Material(
              color: Colors.transparent,
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.grey[400],
                onTap: (){
                  _getCurrentLocation();
                }, // needed
              )),
        )
      ],
    );
  }

  _getCurrentLocation() async {
    var position = await location.getCurrent();
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: _currentZoom,
        ),
      ),
    );
  }

  MarkerId _lastMarkerId;

  _addMarker(double lat, double lng){
    _lastMarkerId = MarkerId("addr$lat");
    final marker = Marker(
        markerId: _lastMarkerId,
        position: LatLng(lat, lng),
        onTap: () {

        }
    );
    markers.add(marker);
  }

  _selectPos(LatLng pos){
    markers.clear();
    _currentPos = pos;
    _lastMarkerId = MarkerId("addr${pos.latitude}");
    final marker = Marker(
        markerId: _lastMarkerId,
        position: LatLng(pos.latitude, pos.longitude),
        onTap: () {

        }
    );
    markers.add(marker);
    setState(() {
    });
  }


}