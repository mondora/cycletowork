import 'dart:async';
import 'dart:typed_data';

import 'package:cycletowork/src/data/app_data.dart';
import 'package:cycletowork/src/data/location_data.dart';
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
  final BoxFit fit;
  final double? width;
  final double? height;
  final bool canScroll;
  final bool isStatic;
  final double padding;
  final Function(Uint8List?)? onSnapshot;

  const AppMap({
    Key? key,
    this.zoom = 16.0,
    this.initialLatitude,
    this.initialLongitude,
    this.markerLatitude,
    this.markerLongitude,
    required this.listTrackingPosition,
    this.isChallenge = false,
    this.fit = BoxFit.fill,
    this.height,
    this.width,
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
    final GoogleMapController controller = await _controller.future;

    var camera = CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: bearing ?? 0,
        target: LatLng(latitude, longitude),
        zoom: zoom ?? widget.zoom,
      ),
    );
    await controller.animateCamera(camera);
  }

  Future changeCameraWithMarker(
    double latitude,
    double longitude, {
    double? zoom,
    double? bearing,
  }) async {
    final GoogleMapController controller = await _controller.future;

    var camera = CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: bearing ?? 0,
        target: LatLng(latitude, longitude),
        zoom: zoom ?? widget.zoom,
      ),
    );
    await controller.animateCamera(camera);
    setMarker(latitude, longitude);
  }

  Future changeCameraFromPath(
    double latitudeSource,
    double longitudeSource,
    double latitudeDestination,
    double longitudeDestination,
  ) async {
    final GoogleMapController controller = await _controller.future;
    LatLngBounds bounds = getBounds(
      latitudeSource,
      longitudeSource,
      latitudeDestination,
      longitudeDestination,
    );

    var camera = CameraUpdate.newLatLngBounds(bounds, widget.padding);

    await controller.animateCamera(camera);
  }

  void setMarker(double latitude, double longitude) {
    _markers = [];

    var markerPositionIcon = context.read<AppData>().markerCurrentPositionIcon;
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
  }

  void setStartAndCurrentMarker(
    double startLatitude,
    double startLongitude,
    double currentLatitude,
    double currnetLongitude,
  ) {
    _markers = [];
    var markerStartPositionIcon =
        context.read<AppData>().markerStartPositionIcon;
    var markerStartIcon = BitmapDescriptor.fromBytes(markerStartPositionIcon!);
    var markStart = Marker(
      markerId: const MarkerId('startPosition'),
      position: LatLng(startLatitude, startLongitude),
      icon: markerStartIcon,
      infoWindow: InfoWindow.noText,
    );
    var markerPositionIcon = context.read<AppData>().markerCurrentPositionIcon;
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
  }

  setPath(
    List<LocationData> listLocationData,
  ) {
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
  }

  addPath(
    LocationData lastLocationData,
    LocationData currentLocationData,
  ) {
    var colorScheme = Theme.of(context).colorScheme;
    var now = DateTime.now();
    var polylineCenter = Polyline(
      polylineId: PolylineId('polylineCenter_${now.millisecondsSinceEpoch}'),
      visible: true,
      points: [
        LatLng(
          lastLocationData.latitude,
          lastLocationData.longitude,
        ),
        LatLng(
          currentLocationData.latitude,
          currentLocationData.longitude,
        ),
      ],
      width: 5,
      color: widget.isChallenge ? colorScheme.secondary : colorScheme.primary,
    );
    var polylineBorder = Polyline(
      polylineId: PolylineId('polylineBorder_${now.millisecondsSinceEpoch}'),
      visible: true,
      points: [
        LatLng(
          lastLocationData.latitude,
          lastLocationData.longitude,
        ),
        LatLng(
          currentLocationData.latitude,
          currentLocationData.longitude,
        ),
      ],
      width: 10,
      color: Colors.black,
    );
    setState(() {
      _polyline.add(polylineBorder);
      _polyline.add(polylineCenter);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Future _setMapStyle() async {
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
      mapToolbarEnabled: false,
      buildingsEnabled: false,
      scrollGesturesEnabled: widget.canScroll,
      zoomGesturesEnabled: widget.canScroll,
      rotateGesturesEnabled: widget.canScroll,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          widget.initialLatitude!,
          widget.initialLongitude!,
        ),
        zoom: widget.zoom,
      ),
      onMapCreated: (GoogleMapController controller) async {
        if (widget.isStatic) {
          setPath(widget.listTrackingPosition);
          var firstPosition = widget.listTrackingPosition.first;
          var lastPosition = widget.listTrackingPosition.last;
          var markerStartPositionIcon =
              context.read<AppData>().markerStartPositionIcon;
          var markerStartIcon =
              BitmapDescriptor.fromBytes(markerStartPositionIcon!);
          var markerStopPositionIcon =
              context.read<AppData>().markerStopPositionIcon;
          var markerStopIcon =
              BitmapDescriptor.fromBytes(markerStopPositionIcon!);
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
          LatLngBounds bounds = getBounds(
            firstPosition.latitude,
            firstPosition.longitude,
            lastPosition.latitude,
            lastPosition.longitude,
          );
          CameraUpdate cameraUpdate =
              CameraUpdate.newLatLngBounds(bounds, widget.padding);
          controller.moveCamera(cameraUpdate);
          Timer(const Duration(milliseconds: 500), () async {
            final uin8list = await controller.takeSnapshot();
            if (widget.onSnapshot != null) {
              widget.onSnapshot!(uin8list);
            }
          });
        }
        _controller.complete(controller);
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
}
