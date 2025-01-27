import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_tracker/src/helpers/klog.dart';

import 'model/directions_model.dart';

class DirectionsMapPage extends StatefulWidget {
  @override
  _DirectionsMapPageState createState() => _DirectionsMapPageState();
}

class _DirectionsMapPageState extends State<DirectionsMapPage> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.773972, -122.431297),
    zoom: 11.5,
  );

  late GoogleMapController _googleMapController;
  late Position _currentPosition;

  Set<Marker> originMarker = {};
  Set<Marker> destinationMarker = {};
  late Directions? _info;
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100), () async {
      getCurrentLocation();
    });

    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  Future getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await Dio().get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': "AIzaSyChNqQpYEiGMqEPOOY6ajIr9DbPzCAegis",
      },
    );

    // Check if response is successful
    if (response.statusCode == 200) {
      // return Directions.fromMap(response.data);
    }
    return null;
  }

  getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
    if (position.latitude != 0.0) {
      _googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 18.0,
          ),
        ),
      );
      _currentPosition = position;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Google Maps'),
        actions: [
          // if (_origin != null)
          //   TextButton(
          //     onPressed: () => _googleMapController.animateCamera(
          //       CameraUpdate.newCameraPosition(
          //         CameraPosition(
          //           target: _origin!.position,
          //           zoom: 14.5,
          //           tilt: 50.0,
          //         ),
          //       ),
          //     ),
          //     style: TextButton.styleFrom(
          //       backgroundColor: Colors.green,
          //       textStyle: const TextStyle(fontWeight: FontWeight.w600),
          //     ),
          //     child: const Text('ORIGIN'),
          //   ),
          // if (_destination != null)
          //   TextButton(
          //     onPressed: () => _googleMapController.animateCamera(
          //       CameraUpdate.newCameraPosition(
          //         CameraPosition(
          //           target: _destination!.position,
          //           zoom: 14.5,
          //           tilt: 50.0,
          //         ),
          //       ),
          //     ),
          //     style: TextButton.styleFrom(
          //       backgroundColor: Colors.blue,
          //       textStyle: const TextStyle(fontWeight: FontWeight.w600),
          //     ),
          //     child: const Text('DEST'),
          //   )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: {
              ...originMarker,
              ...destinationMarker,
            },
            polylines: {
              // if (_info != null)
              //   Polyline(
              //     polylineId: const PolylineId('overview_polyline'),
              //     color: Colors.red,
              //     width: 5,
              //     points: _info!.polylinePoints
              //         .map((e) => LatLng(e.latitude, e.longitude))
              //         .toList(),
              //   ),
            },
            onLongPress: (argument) {
              addMarker(argument);
            },
            onTap: (argument) {
              klog(argument);
            },
          ),

          Positioned(
            top: 20,
            right: 10,
            child: ClipOval(
              child: Material(
                color: Colors.white, // button color
                child: InkWell(
                  splashColor: Colors.green, // inkwell color

                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(Icons.refresh, color: Colors.blue),
                  ),
                  onTap: () {
                    originMarker.clear();
                    destinationMarker.clear();
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 65,
            right: 10,
            child: ClipOval(
              child: Material(
                color: Colors.white, // button color
                child: InkWell(
                  splashColor: Colors.green, // inkwell color

                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(Icons.my_location, color: Colors.blue),
                  ),
                  onTap: () {
                    _googleMapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(
                            _currentPosition.latitude,
                            _currentPosition.longitude,
                          ),
                          zoom: 18.0,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // if (_info != null)
          //   Positioned(
          //     top: 20.0,
          //     child: Container(
          //       padding: const EdgeInsets.symmetric(
          //         vertical: 6.0,
          //         horizontal: 12.0,
          //       ),
          //       decoration: BoxDecoration(
          //         color: Colors.yellowAccent,
          //         borderRadius: BorderRadius.circular(20.0),
          //         boxShadow: const [
          //           BoxShadow(
          //             color: Colors.black26,
          //             offset: Offset(0, 2),
          //             blurRadius: 6.0,
          //           )
          //         ],
          //       ),
          //       child: Text(
          //         '${_info!.totalDistance}, ${_info!.totalDuration}',
          //         style: const TextStyle(
          //           fontSize: 18.0,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        onPressed: () {},
        // onPressed: () => _googleMapController.animateCamera(
        //   _info != null
        //       ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
        //       : CameraUpdate.newCameraPosition(_initialCameraPosition),
        // ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  void addMarker(LatLng latLng) async {
    klog(latLng);
    if (originMarker.isEmpty) {
      originMarker.add(
        Marker(
          markerId: MarkerId('origin'),
          position: latLng,
          infoWindow: InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    } else if (destinationMarker.isEmpty || destinationMarker.isNotEmpty) {
      destinationMarker.clear();
      destinationMarker.add(
        Marker(
          markerId: MarkerId('destination'),
          position: latLng,
          infoWindow: InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );

      final directions = await getDirections(
        origin: originMarker.first.position,
        destination: destinationMarker.first.position,
      );
      setState(() {
        _info = directions;
      });
    }
    // if (_origin == null || (_origin != null && _destination != null)) {
    //   // Origin is not set OR Origin/Destination are both set
    //   // Set origin

    //   _origin = Marker(
    //     markerId: const MarkerId('origin'),
    //     infoWindow: const InfoWindow(title: 'Origin'),
    //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    //     position: pos,
    //   );
    //   // Reset destination
    //   _destination = _destination;

    //   // Reset info
    //   _info = _info;
    //   setState(() {});
    // } else {
    //   // Origin is already set
    //   // Set destination
    //   setState(() {
    //     _destination = Marker(
    //       markerId: const MarkerId('destination'),
    //       infoWindow: const InfoWindow(title: 'Destination'),
    //       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    //       position: pos,
    //     );
    //   });

    //   // Get directions
    //   final directions = await getDirections(
    //     origin: _origin!.position,
    //     destination: pos,
    //   );
    //   setState(() => _info = directions);
    // }
  }
}
