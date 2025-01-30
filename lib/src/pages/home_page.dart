import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location_tracker/src/helpers/route.dart';
import '../base/base.dart';
import 'map/directions_map_page.dart';
import 'map/map_view_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Start/Stop Location')),
      body: Obx(
        () => Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  push(MapViewPage());
                },
                child: Text('Map View'),
              ),
              ElevatedButton(
                onPressed: () async {
                  push(DirectionsMapPage());
                },
                child: Text('Directions Map View'),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: Base.locationTrackerController.isListening.value
                        ? null
                        : () async {
                            if (await Base.locationTrackerController
                                .initLocationListener(isListening: true)) {
                              Base.locationTrackerController.startWork();
                            }
                          },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        Base.locationTrackerController.isListening.value
                            ? Colors.grey.withValues(alpha: 0.5)
                            : Colors.green,
                      ),
                    ),
                    child: Text(
                      'Start Work',
                      style: TextStyle(
                        color: Base.locationTrackerController.isListening.value
                            ? Colors.grey
                            : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: Base.locationTrackerController.isListening.value
                        ? () {
                            Base.locationTrackerController.stopListen();
                            Base.locationTrackerController.latLngList.clear();
                            Base.locationTrackerController.markerList.clear();
                          }
                        : null,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        !Base.locationTrackerController.isListening.value
                            ? Colors.grey.withValues(alpha: 0.5)
                            : Colors.redAccent,
                      ),
                    ),
                    child: Text(
                      'Stop Work',
                      style: TextStyle(
                        color: !Base.locationTrackerController.isListening.value
                            ? Colors.grey
                            : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
