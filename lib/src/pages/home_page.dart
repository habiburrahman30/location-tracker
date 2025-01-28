import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location_tracker/src/helpers/route.dart';
import '../base/base.dart';
import 'map/directions_map_page.dart';
import 'map_view_page.dart';

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
                children: [
                  ElevatedButton(
                    onPressed: () async {},
                    child: Text('Start With Stream'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await Base.locationTrackerController.stopListen();
                    },
                    child: Text('Stop With Stream'),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: Base.locationTrackerController.isListening1.value
                        ? null
                        : Base.locationTrackerController.startWork,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        Base.locationTrackerController.isListening1.value
                            ? Colors.grey.withValues(alpha: 0.5)
                            : Colors.green,
                      ),
                    ),
                    child: Text(
                      'Start Work',
                      style: TextStyle(
                        color: Base.locationTrackerController.isListening1.value
                            ? Colors.grey
                            : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: Base.locationTrackerController.isListening1.value
                        ? () {
                            Base.locationTrackerController.stopListen();
                            Base.locationTrackerController.latLngList1.clear();
                            Base.locationTrackerController.markerList.clear();
                          }
                        : null,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        !Base.locationTrackerController.isListening1.value
                            ? Colors.grey.withValues(alpha: 0.5)
                            : Colors.redAccent,
                      ),
                    ),
                    child: Text(
                      'Stop Work',
                      style: TextStyle(
                        color:
                            !Base.locationTrackerController.isListening1.value
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
