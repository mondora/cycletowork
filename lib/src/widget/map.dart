import 'dart:async';
import 'dart:ui' as ui;

import 'package:cycletowork/src/utility/convert.dart';
import 'package:cycletowork/src/data/location_data.dart';
import 'package:cycletowork/src/utility/share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart'
    as static_map;

enum AppMapType {
  static,
  dynamic,
}

class AppMap extends StatefulWidget {
  final double zoom;
  final double? initialLatitude;
  final double? initialLongitude;
  final double? markerLatitude;
  final double? markerLongitude;
  final AppMapType type;
  final List<LocationData> listTrackingPosition;
  final bool isChallenge;
  final BoxFit fit;
  final double? width;
  final double? height;

  const AppMap({
    Key? key,
    this.zoom = 16.0,
    this.initialLatitude,
    this.initialLongitude,
    this.markerLatitude,
    this.markerLongitude,
    required this.type,
    required this.listTrackingPosition,
    this.isChallenge = false,
    this.fit = BoxFit.fill,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  State<AppMap> createState() => AppMapState();
}

class AppMapState extends State<AppMap> with WidgetsBindingObserver {
  final Completer<GoogleMapController> _controller = Completer();
  static_map.StaticMapController? _staticController;
  BitmapDescriptor? _markerIcon;
  String? _darkMapStyle;
  String? _lightMapStyle;
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

    var camera = CameraUpdate.newLatLngBounds(bounds, 100);

    await controller.animateCamera(camera);
  }

  void setMarker(double latitude, double longitude) {
    _markers = [];
    Marker mark;
    if (_markerIcon != null) {
      mark = Marker(
        markerId: const MarkerId('currentPosition'),
        position: LatLng(latitude, longitude),
        icon: _markerIcon!,
        infoWindow: InfoWindow.noText,
      );
    } else {
      mark = Marker(
        markerId: const MarkerId('currentPosition'),
        position: LatLng(latitude, longitude),
      );
    }
    setState(() {
      _markers.add(mark);
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

  Future shareScreenshot() async {
    var imagePath = await _staticController!.saveFileAndGetPath();
    await Share.shareImage(
      imagePath,
      text: 'Il tuo percorso',
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
    if (_markerIcon == null) {
      final Uint8List markerIcon = await getBytesFromAsset(
        'assets/images/marker_image.png',
        100,
      );
      _markerIcon = BitmapDescriptor.fromBytes(markerIcon);
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<Uint8List> getBytesFromNetwork(String url, int width) async {
    var buffer = (await NetworkAssetBundle(Uri.parse(url)).load(url))
        .buffer
        .asUint8List();

    ui.Codec codec = await ui.instantiateImageCodec(buffer, targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
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
    var colorScheme = Theme.of(context).colorScheme;

    if (widget.type == AppMapType.static) {
      var listLocation = widget.listTrackingPosition;
      var centerPositon = LocationData.getCentralGeoCoordinate(listLocation);
      var listPath = getPathForStaticMapFromLocationData(listLocation);

      _staticController = static_map.StaticMapController(
        googleApiKey: dotenv.env['GOOGLE_MAP_STATIC_API_KEY']!,
        width: widget.width != null
            ? widget.width!.toInt()
            : MediaQuery.of(context).size.width.toInt(),
        height: widget.height != null
            ? widget.height!.toInt()
            : MediaQuery.of(context).size.height.toInt(),
        format: static_map.MapImageFormat.png32,
        center: static_map.GeocodedLocation.latLng(
          centerPositon.latitude,
          centerPositon.longitude,
        ),
        zoom: listPath.isEmpty ? widget.zoom.toInt() : null,
        paths: listPath.length > 1
            ? <static_map.Path>[
                static_map.Path(
                  color: Colors.black,
                  weight: 10,
                  points: listPath,
                ),
                static_map.Path(
                  color: widget.isChallenge
                      ? colorScheme.secondary
                      : colorScheme.primary,
                  weight: 5,
                  points: listPath,
                ),
              ]
            : [],
        markers: listPath.isNotEmpty
            ? <static_map.Marker>[
                static_map.Marker.custom(
                  anchor: static_map.MarkerAnchor.center,
                  icon: 'https://i.ibb.co/7W9gZXW/start-position.png',
                  locations: [
                    listPath.first,
                  ],
                ),
                static_map.Marker.custom(
                  anchor: static_map.MarkerAnchor.center,
                  icon: 'https://i.ibb.co/pWBnTBD/end-position.png',
                  locations: [
                    listPath.last,
                  ],
                ),
              ]
            : [],
      );

      return Image(
        image: _staticController!.image,
        fit: widget.fit,
      );
    }

    return GoogleMap(
      mapType: MapType.normal,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: false,
      buildingsEnabled: false,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          widget.initialLatitude!,
          widget.initialLongitude!,
        ),
        zoom: widget.zoom,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: Set<Marker>.of(_markers),
      polylines: Set<Polyline>.of(_polyline),
    );
  }

  List<static_map.Location> getPathForStaticMapFromLocationData(
    List<LocationData> listLocationData,
  ) {
    return listLocationData
        .map(
          (locationData) => static_map.Location(
            locationData.latitude,
            locationData.longitude,
          ),
        )
        .toList();
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
