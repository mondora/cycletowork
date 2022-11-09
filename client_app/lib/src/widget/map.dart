import 'dart:async';

import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/utility/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AppMap extends StatefulWidget {
  final double zoom;
  final double? initialLatitude;
  final double? initialLongitude;
  final double? markerLatitude;
  final double? markerLongitude;
  final List<LocationData> listTrackingPosition;
  final bool isChallenge;
  final bool canScroll;
  final bool isStatic;
  final double padding;
  final Function(Uint8List?)? onSnapshot;
  final Function() onCreatedMap;

  const AppMap({
    Key? key,
    required this.initialLatitude,
    required this.initialLongitude,
    required this.listTrackingPosition,
    required this.onCreatedMap,
    this.markerLatitude,
    this.markerLongitude,
    this.zoom = 16.0,
    this.isChallenge = false,
    this.canScroll = true,
    this.isStatic = false,
    this.padding = 100.0,
    this.onSnapshot,
  }) : super(key: key);

  @override
  State<AppMap> createState() => AppMapState();
}

class AppMapState extends State<AppMap> with WidgetsBindingObserver {
  final Completer<GoogleMapController> _controller = Completer();
  List<Marker> _markers = [];
  List<Polyline> _polyline = [];

  Future changeCamera(
    double latitude,
    double longitude, {
    double? zoom,
    double? bearing,
  }) async {
    try {
      final controller = await _controller.future;
      final camera = CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: bearing ?? 0,
          target: LatLng(latitude, longitude),
          zoom: zoom ?? widget.zoom,
        ),
      );
      await controller.animateCamera(camera);
    } catch (e) {
      Logger.error(e);
    }
  }

  Future chengeCameraForStaticMap() async {
    try {
      final controller = await _controller.future;
      final bounds = _boundsFromLatLngList(widget.listTrackingPosition);
      final cameraUpdate = CameraUpdate.newLatLngBounds(
        bounds,
        widget.padding,
      );

      await controller.moveCamera(cameraUpdate);
    } catch (e) {
      Logger.error(e);
    }
  }

  void setMarker(double latitude, double longitude) {
    try {
      _markers = [];

      var markerPositionIcon =
          context.read<AppData>().markerCurrentPositionIcon;
      var markerIcon = BitmapDescriptor.fromBytes(markerPositionIcon!);
      var mark = Marker(
        markerId: const MarkerId('currentPosition'),
        position: LatLng(latitude, longitude),
        icon: markerIcon,
        infoWindow: InfoWindow.noText,
      );
      setState(() {
        _markers.add(mark);
      });
    } catch (e) {
      Logger.error(e);
    }
  }

  void setStartAndCurrentMarker(
    double startLatitude,
    double startLongitude,
    double currentLatitude,
    double currnetLongitude,
  ) {
    try {
      _markers = [];
      var markerStartPositionIcon =
          context.read<AppData>().markerStartPositionIcon;
      var markerStartIcon =
          BitmapDescriptor.fromBytes(markerStartPositionIcon!);
      var markStart = Marker(
        markerId: const MarkerId('startPosition'),
        position: LatLng(startLatitude, startLongitude),
        icon: markerStartIcon,
        infoWindow: InfoWindow.noText,
      );
      var markerPositionIcon =
          context.read<AppData>().markerCurrentPositionIcon;
      var markerIcon = BitmapDescriptor.fromBytes(markerPositionIcon!);
      var mark = Marker(
        markerId: const MarkerId('currentPosition'),
        position: LatLng(currentLatitude, currnetLongitude),
        icon: markerIcon,
        infoWindow: InfoWindow.noText,
      );
      setState(() {
        _markers.addAll([
          markStart,
          mark,
        ]);
      });
    } catch (e) {
      Logger.error(e);
    }
  }

  setPath(
    List<LocationData> listLocationData,
  ) {
    try {
      var colorScheme = Theme.of(context).colorScheme;
      _polyline = [];
      var polylineCenter = Polyline(
        polylineId: const PolylineId('polylineCenter'),
        visible: true,
        points: listLocationData
            .map(
              (location) => LatLng(location.latitude, location.longitude),
            )
            .toList(),
        width: 5,
        color: widget.isChallenge ? colorScheme.secondary : colorScheme.primary,
      );
      var polylineBorder = Polyline(
        polylineId: const PolylineId('polylineBorder'),
        visible: true,
        points: listLocationData
            .map(
              (location) => LatLng(location.latitude, location.longitude),
            )
            .toList(),
        width: 10,
        color: Colors.black,
      );
      setState(() {
        _polyline.add(polylineBorder);
        _polyline.add(polylineCenter);
      });
    } catch (e) {
      Logger.error(e);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _setMapStyle());
  }

  Future _setMapStyle() async {
    try {
      final controller = await _controller.future;
      final brightnessTheme = Theme.of(context).brightness;
      var darkMapStyle = context.read<AppData>().darkMapStyle;
      if (brightnessTheme == Brightness.dark && darkMapStyle != null) {
        controller.setMapStyle(darkMapStyle);
      } else {
        var lightMapStyle = context.read<AppData>().lightMapStyle;
        if (lightMapStyle != null) {
          controller.setMapStyle(lightMapStyle);
        }
      }
    } catch (e) {
      Logger.error(e);
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
    if (widget.isStatic) {
      var colorScheme = Theme.of(context).colorScheme;
      _polyline = [];
      var polylineCenter = Polyline(
        polylineId: const PolylineId('polylineCenter'),
        visible: true,
        points: widget.listTrackingPosition
            .map(
              (location) => LatLng(location.latitude, location.longitude),
            )
            .toList(),
        width: 5,
        color: widget.isChallenge ? colorScheme.secondary : colorScheme.primary,
      );
      var polylineBorder = Polyline(
        polylineId: const PolylineId('polylineBorder'),
        visible: true,
        points: widget.listTrackingPosition
            .map(
              (location) => LatLng(location.latitude, location.longitude),
            )
            .toList(),
        width: 10,
        color: Colors.black,
      );

      _polyline.add(polylineBorder);
      _polyline.add(polylineCenter);

      var firstPosition = widget.listTrackingPosition.first;
      var lastPosition = widget.listTrackingPosition.last;
      var markerStartPositionIcon =
          context.read<AppData>().markerStartPositionIcon;
      var markerStartIcon =
          BitmapDescriptor.fromBytes(markerStartPositionIcon!);
      var markerStopPositionIcon =
          context.read<AppData>().markerStopPositionIcon;
      var markerStopIcon = BitmapDescriptor.fromBytes(markerStopPositionIcon!);
      _markers = [];
      var startMark = Marker(
        markerId: const MarkerId('startPosition'),
        position: LatLng(firstPosition.latitude, firstPosition.longitude),
        icon: markerStartIcon,
        infoWindow: InfoWindow.noText,
      );
      _markers.add(startMark);
      var stopMark = Marker(
        markerId: const MarkerId('stopPosition'),
        position: LatLng(lastPosition.latitude, lastPosition.longitude),
        icon: markerStopIcon,
        infoWindow: InfoWindow.noText,
      );
      _markers.add(stopMark);
    }

    return GoogleMap(
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: false,
      buildingsEnabled: false,
      scrollGesturesEnabled: widget.canScroll,
      zoomGesturesEnabled: widget.canScroll,
      rotateGesturesEnabled: widget.canScroll,
      // gestureRecognizers: Set()
      //   ..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
      initialCameraPosition: CameraPosition(
        target: LatLng(
          widget.initialLatitude!,
          widget.initialLongitude!,
        ),
        zoom: widget.zoom,
      ),
      onMapCreated: (GoogleMapController controller) async {
        try {
          _controller.complete(controller);
        } catch (e) {
          Logger.error(e);
        }
        Timer(const Duration(milliseconds: 200), () async {
          try {
            widget.onCreatedMap();
          } catch (e) {
            Logger.error(e);
          }
        });
      },
      onCameraIdle: () {
        if (widget.onSnapshot != null) {
          Timer(const Duration(milliseconds: 300), () async {
            try {
              final controller = await _controller.future;
              final uin8list = await controller.takeSnapshot();
              if (widget.onSnapshot != null) {
                widget.onSnapshot!(uin8list);
              }
            } catch (e) {
              Logger.error(e);
            }
          });
        }
      },
      markers: Set<Marker>.of(_markers),
      polylines: Set<Polyline>.of(_polyline),
    );
  }

  getBounds(
    double latitude1,
    double longitude1,
    double latitude2,
    double longitude2,
  ) {
    LatLngBounds bounds;
    if (latitude1 > latitude2 && longitude1 > longitude2) {
      bounds = LatLngBounds(
        southwest: LatLng(
          latitude2,
          longitude2,
        ),
        northeast: LatLng(
          latitude1,
          longitude1,
        ),
      );
    } else if (longitude1 > longitude2) {
      bounds = LatLngBounds(
        southwest: LatLng(latitude1, longitude2),
        northeast: LatLng(latitude2, longitude1),
      );
    } else if (latitude1 > latitude2) {
      bounds = LatLngBounds(
        southwest: LatLng(latitude2, longitude1),
        northeast: LatLng(latitude1, longitude2),
      );
    } else {
      bounds = LatLngBounds(
        southwest: LatLng(
          latitude1,
          longitude1,
        ),
        northeast: LatLng(
          latitude2,
          longitude2,
        ),
      );
    }

    return bounds;
  }

  LatLngBounds _boundsFromLatLngList(List<LocationData> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (var latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }
}
