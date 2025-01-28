import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../base/base.dart';

class LocationListener extends StatefulWidget {
  const LocationListener({super.key});

  @override
  _LocationListenerState createState() => _LocationListenerState();
}

class _LocationListenerState extends State<LocationListener> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),

            Base.locationTrackerController.latLngList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: Base.locationTrackerController.latLngList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          'Lat: ${Base.locationTrackerController.latLngList[index].latitude}',
                        ),
                        subtitle: Text(
                          'Lng: ${Base.locationTrackerController.latLngList[index].longitude}',
                        ),
                      );
                    },
                  )
                : Text('No location data'),
            // ElevatedButton(
            //   onPressed: Base.locationTreceController.isListening.value
            //       ? null
            //       : Base.locationTreceController.startListening,
            //   style: ButtonStyle(
            //     backgroundColor: WidgetStateProperty.all<Color>(
            //       Base.locationTreceController.isListening.value
            //           ? Colors.grey.withValues(alpha: 0.5)
            //           : Colors.green,
            //     ),
            //   ),
            //   child: Text(
            //     'Start Work',
            //     style: TextStyle(
            //       color: Base.locationTreceController.isListening.value
            //           ? Colors.grey
            //           : Colors.white,
            //     ),
            //   ),
            // ),
            // SizedBox(height: 10),
            // ElevatedButton(
            //   onPressed: Base.locationTreceController.isListening.value
            //       ? Base.locationTreceController.stopListening2
            //       : null,
            //   style: ButtonStyle(
            //     backgroundColor: WidgetStateProperty.all<Color>(
            //       !Base.locationTreceController.isListening.value
            //           ? Colors.grey.withValues(alpha: 0.5)
            //           : Colors.redAccent,
            //     ),
            //   ),
            //   child: Text(
            //     'Stop Work',
            //     style: TextStyle(
            //       color: !Base.locationTreceController.isListening.value
            //           ? Colors.grey
            //           : Colors.white,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
