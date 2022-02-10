import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shopping/main.dart';
import 'package:shopping/model/dprint.dart';
import 'package:shopping/model/homescreenModel.dart';
import 'package:shopping/model/server/getDriverLocation.dart';
import 'package:shopping/model/server/getOrders.dart';
import 'package:shopping/ui/main/home/home.dart';
import 'package:shopping/widget/skinRoute.dart';
import 'package:shopping/widget/wmap.dart';

class MapTrackingScreen extends StatefulWidget {
  final OrdersData item;
  MapTrackingScreen({this.item});

  @override
  _MapTrackingScreenState createState() => _MapTrackingScreenState();
}

class _MapTrackingScreenState extends State<MapTrackingScreen> {

  var windowWidth;
  var windowHeight;
  String _mapStyle;

  @override
  void initState() {
    _initIcons();
    startTimer();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    _add();
    _loadDriverLocation();
    Future.delayed(const Duration(milliseconds: 1000), () {
      _initCameraPosition();
    });
    super.initState();
  }

  Timer _timer;

  void startTimer() {
    dprint("start timer");
    _timer = new Timer.periodic(Duration(seconds: 10),
      (Timer timer) {
        _loadDriverLocation();
      },);
  }

  _loadDriverLocation(){
    getDriverLocation(widget.item.driver, (double lat, double lng) {
      if (lat == 0 || lng == 0)
        return;
      try{
        dprint("remove driver marker");
        Marker marker = markers.firstWhere((marker) => marker.markerId.value == "driver",orElse: () => null);
        markers.remove(marker);
        //markers.remove(markers.firstWhere((Marker marker) => marker.markerId.value == "driver"));
      }catch (ex) {
        dprint("exception ${ex.toString()}");
      }
      _lastMarkerId = MarkerId("driver");
      dprint("$lat $lng");
      final marker = Marker(
          markerId: _lastMarkerId,
          icon: _iconDriver,
          position: LatLng(
              lat, lng
          ),
          onTap: () {
          }
      );
      dprint("add driver marker");
      markers.add(marker);
      setState(() {});
    }, (String _) {});
  }

  var _iconHome;
  var _iconDest;
  var _iconDriver;

  _initIcons() async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/marker1.png', 80);
    _iconHome = BitmapDescriptor.fromBytes(markerIcon);
    final Uint8List markerIcon2 = await getBytesFromAsset('assets/marker2.png', 80);
    _iconDest = BitmapDescriptor.fromBytes(markerIcon2);
    final Uint8List markerIcon3 = await getBytesFromAsset('assets/marker3.png', 100);
    _iconDriver = BitmapDescriptor.fromBytes(markerIcon3);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  @override
  void dispose() {
    _timer.cancel();
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
        // margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Stack(children: <Widget>[

          _map(),

          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 15,),
                  buttonPlus(_onMapPlus),
                  buttonMinus(_onMapMinus),
                  buttonMyLocation(_getCurrentLocation),
                ],
              )
            ),
          ),

          skinHeaderBackButton(context, Colors.white),

      ]
        )
    );
  }

  Map<PolylineId, Polyline> _mapPolylines = {};
  int _polylineIdCounter = 1;

  Future<void> _add() async {
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);

    var polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      appSettings.mapapikey,
      PointLatLng(widget.item.shopLat, widget.item.shopLng),
      PointLatLng(widget.item.destLat, widget.item.destLng),
      travelMode: TravelMode.driving,
    );
    List<LatLng> polylineCoordinates = [];

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Colors.red,
      width: 4,
      points: polylineCoordinates,
    );

    setState(() {
      _mapPolylines[polylineId] = polyline;
    });
    _addMarker();
    // _initCameraPosition();
  }

  _addMarker(){
    print("add marker addr1 and addr2");
    _lastMarkerId = MarkerId("addr1");
    final marker = Marker(
        markerId: _lastMarkerId,
        icon: _iconDest,
        position: LatLng(
            widget.item.destLat, widget.item.destLng
        ),
        onTap: () {
        }
    );
    markers.add(marker);
    _lastMarkerId = MarkerId("addr2");
    final marker2 = Marker(
        markerId: _lastMarkerId,
        icon: _iconHome,
        position: LatLng(
            widget.item.shopLat, widget.item.shopLng
        ),
        onTap: () {

        }
    );
    markers.add(marker2);
  }

  _initCameraPosition() async{
    // calculate zoom
    LatLng latLng_1 = LatLng(widget.item.shopLat, widget.item.shopLng);
    LatLng latLng_2 = LatLng(widget.item.destLat, widget.item.destLng);
    dprint("latLng_1 = $latLng_1");
    dprint("latLng_2 = $latLng_2");

    var lat1 = latLng_1.latitude; // широта
    var lat2 = latLng_2.latitude;
    if (latLng_1.latitude > latLng_2.latitude) {
      lat1 = latLng_2.latitude;
      lat2 = latLng_1.latitude;
    }
    var lng1 = latLng_1.longitude;
    var lng2 = latLng_2.longitude;
    if (latLng_1.longitude > latLng_2.longitude) {
      lng1 = latLng_2.longitude;
      lng2 = latLng_1.longitude;
    }
    dprint ("lat1 = $lat1, lat2 = $lat2");
    dprint ("lng1 = $lng1, lng2 = $lng2");
    LatLngBounds bound = LatLngBounds(southwest: LatLng(lat1, lng1), northeast: LatLng(lat2, lng2)); // юго-запад - северо-восток
    dprint(bound.toString());

    CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 50);
    if (_controller != null) {
      print("animateCamera");
      _controller.animateCamera(u2).then((void v) {});
    }

    setState(() {
    });
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
    dprint("orders.map : GoogleMap");
    return GoogleMap(
      mapType: MapType.normal,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: false, // Whether to show zoom controls (only applicable for Android).
      myLocationEnabled: true,  // For showing your current location on the map with a blue dot.
      myLocationButtonEnabled: false, // This button is used to bring the user location to the center of the camera view.
      initialCameraPosition: _kGooglePlex,
      polylines: Set<Polyline>.of(_mapPolylines.values),
      onCameraMove:(CameraPosition cameraPosition){
        _currentZoom = cameraPosition.zoom;
      },
      onTap: (LatLng pos) {

      },
      onLongPress: (LatLng pos) {

      },
      markers: markers != null ? Set<Marker>.from(markers) : null,
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
        if (theme.darkMode)
          _controller.setMapStyle(_mapStyle);
        // if (idRestaurantOnMap != null)
        //   _navigateToMap();
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

  // _getDistanceText(Restaurants item){
  //   var _dist = "";
  //   if (item.distance != -1) {
  //     if (appSettings.distanceUnit == "km") {
  //       if (item.distance <= 1000)
  //         _dist = "${item.distance.toStringAsFixed(0)} m";
  //       else
  //         _dist = "${(item.distance / 1000).toStringAsFixed(0)} km";
  //     }else{                // miles
  //       if (item.distance < 1609.34) {
  //         _dist = "${(item.distance/1609.34).toStringAsFixed(3)} miles";
  //       }else
  //         _dist = "${(item.distance / 1609.34).toStringAsFixed(0)} miles";
  //     }
  //   }
  //   return _dist;
  // }

  MarkerId _lastMarkerId;

  // var _bearing = 0.0;

  // _navigateToMap(){
  //   for (var item in nearYourRestaurants)
  //       if (item.id == idRestaurantOnMap) {
  //         _controller.showMarkerInfoWindow(_lastMarkerId);
  //         _controller.animateCamera(
  //             CameraUpdate.newCameraPosition(
  //               CameraPosition(
  //                 bearing: _bearing,
  //                 target: LatLng(item.lat, item.lng),
  //                 zoom: _currentZoom,
  //               ),
  //             )
  //
  //         );
  //       }
  // }

}