import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppMap extends StatefulWidget {
  final double zoom;
  final double initialLatitude;
  final double initialLongitude;
  final double? markerLatitude;
  final double? markerLongitude;
  final AppMapState myAppState = AppMapState();

  AppMap({
    Key? key,
    this.zoom = 16.0,
    required this.initialLatitude,
    required this.initialLongitude,
    this.markerLatitude,
    this.markerLongitude,
  }) : super(key: key);

  @override
  State<AppMap> createState() => AppMapState();

  void changeCamera(double latitude, double longitude) {
    myAppState.changeCamera(latitude, longitude);
  }
}

class AppMapState extends State<AppMap> with WidgetsBindingObserver {
  final Completer<GoogleMapController> _controller = Completer();
  String? _darkMapStyle;
  String? _lightMapStyle;

  Future changeCamera(double latitude, double longitude) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 16.0,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadMapStyles();
  }

  Future _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/maps/dark_theme.json');
    _lightMapStyle =
        await rootBundle.loadString('assets/maps/light_theme.json');
  }

  Future _setMapStyle() async {
    final controller = await _controller.future;
    final brightnessTheme = Theme.of(context).brightness;
    if (brightnessTheme == Brightness.dark && _darkMapStyle != null) {
      controller.setMapStyle(_darkMapStyle);
    } else {
      if (_lightMapStyle != null) {
        controller.setMapStyle(_lightMapStyle);
      }
    }
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {
      _setMapStyle();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.initialLatitude, widget.initialLongitude),
        zoom: widget.zoom,
      ),
      buildingsEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: widget.markerLatitude != null && widget.markerLongitude != null
          ? <Marker>{
              Marker(
                markerId: const MarkerId('marker_1'),
                position:
                    LatLng(widget.markerLatitude!, widget.markerLongitude!),
              ),
            }
          : <Marker>{},
    );
  }
}
