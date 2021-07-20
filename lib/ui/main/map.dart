import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shopping/main.dart';
import 'package:shopping/model/dprint.dart';
import 'package:shopping/model/homescreenModel.dart';
import 'package:shopping/model/pref.dart';
import 'package:shopping/model/server/mainwindowdata.dart';
import 'package:shopping/model/topRestourants.dart';
import 'package:shopping/model/utils.dart';
import 'package:shopping/ui/main/home/home.dart';
import 'package:shopping/widget/basic/restaurants.dart';
import 'package:shopping/widget/skinRoute.dart';
import 'package:shopping/widget/wmap.dart';

class MapScreen extends StatefulWidget {
  final Function(String) callback;
  final Color color;
  MapScreen({this.color = Colors.black, this.callback});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  _onTopRestaurantNavigateIconClick(String id){
    print("User pressed Top Restaurant Route icon with id: $id");
    idRestaurantOnMap = id;
    // markers.clear();
    markers = {};
    _addMarkers();
    _navigateToMap();
    setState(() {

    });
  }

  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  var windowWidth;
  var windowHeight;
  String _mapStyle;

  @override
  void initState() {
    //_initCameraPosition();
    _addMarkers();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    var _lat = toDouble(pref.get(Pref.mainMapLat));
    var _lng = toDouble(pref.get(Pref.mainMapLng));
    var _zoom = toDouble(pref.get(Pref.mainMapZoom));
    if (_zoom != 0) {
      _currentZoom = _zoom;
      _kGooglePlex = CameraPosition(target: LatLng(_lat, _lng), zoom: _zoom,);
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(appSettings.defaultLat, appSettings.defaultLng), zoom: appSettings.defaultZoom,); // paris coordinates
  Set<Marker> markers = {};
  GoogleMapController _controller;
  double _currentZoom = 12;

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    if (_controller != null)
      if (theme.darkMode)
        _controller.setMapStyle(_mapStyle);
      else
        _controller.setMapStyle(null);

    return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+50),
        child: Stack(children: <Widget>[

          _map(),

          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15,),
                  buttonPlus(_onMapPlus),
                  buttonMinus(_onMapMinus),
                  buttonMyLocation(_getCurrentLocation),
                ],
              )
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                margin: EdgeInsets.only(bottom: 70),
                child: skinMapHorizontalRestaurants(windowWidth, context, _onTopRestaurantNavigateIconClick, _deleteCircle, _setCircle),
              //_horizontalTopRestaurants()
            ),
          )


      ]
        )
    );
  }

  _getCurrentLocation() async {
    var position = await homeScreen.location.getCurrent();
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: _currentZoom,
        ),
      ),
    );
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
          pref.set(Pref.mainMapLat, cameraPosition.target.latitude.toString());
          pref.set(Pref.mainMapLng, cameraPosition.target.longitude.toString());
          pref.set(Pref.mainMapZoom, cameraPosition.zoom.toString());
          _currentZoom = cameraPosition.zoom;
        },
        onTap: (LatLng pos) {

        },
        onLongPress: (LatLng pos) {

        },
        markers: markers != null ? Set<Marker>.from(markers) : null,
        circles: circles,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          if (theme.darkMode)
            _controller.setMapStyle(_mapStyle);
          if (idRestaurantOnMap != null)
            _navigateToMap();
        });
  }

  _onMapPlus(){
    _controller?.animateCamera(
      CameraUpdate.zoomIn(),
    );
  }

  _onMapMinus(){
    _controller?.animateCamera(
      CameraUpdate.zoomOut(),
    );
  }

  _addMarkers(){
    for (var item in nearYourRestaurants) {
      // if (idRestaurantOnMap != null) {
      //   if (item.id == idRestaurantOnMap) {
      //     _addMarker(item);
      //     break;
      //   }
      // }else
        _addMarker(item);
    }
  }

  MarkerId _lastMarkerId;

  _addMarker(Restaurants item){
    var _dist = getDistanceText(item);
    print("add marker ${item.id}");
    var _lastMarkerId2 = MarkerId(item.id);
    if (idRestaurantOnMap == item.id)
      _lastMarkerId = _lastMarkerId2;
    dprint("_lastMarkerId=$_lastMarkerId");
    final marker = Marker(
          markerId: _lastMarkerId2,
          position: LatLng(
              item.lat, item.lng
          ),
          infoWindow: InfoWindow(
            title: item.name,
            snippet: _dist,
            onTap: () {
              idHeroes = UniqueKey().toString();
              idRestaurant = item.id;
              route.setDuration(1);
              route.push(context, "/restaurantdetails");
            },
            //snippet: id,
          ),
          //icon: myIcon,
          onTap: () {

          }
      );
      markers.add(marker);
      dprint("marker add ${marker.markerId.value}");
  }
  var _bearing = 0.0;

  _navigateToMap(){
    for (var item in nearYourRestaurants)
        if (item.id == idRestaurantOnMap) {
          _controller.showMarkerInfoWindow(_lastMarkerId);
          _controller.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  bearing: _bearing,
                  target: LatLng(item.lat, item.lng),
                  zoom: _currentZoom,
                ),
              )

          );
        }
  }

  Set<Circle> circles = Set.from([]);

  _deleteCircle(Restaurants rest) {
    circles.removeWhere((item) => item.circleId.value  == rest.id);
    setState(() {
    });
  }

  _setCircle(Restaurants item){
    var t = item.area*1000/2;
    if (t < 0) t = 1;
    circles.add(Circle(
      circleId: CircleId(item.id),
      center: LatLng(item.lat, item.lng),
      radius: t,
      fillColor: theme.colorPrimary.withAlpha(30),
      strokeColor: theme.colorPrimary.withAlpha(60)
    ));
    setState(() {
    });
  }
}