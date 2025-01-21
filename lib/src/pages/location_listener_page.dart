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
      () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            TextButton(onPressed: () async {}, child: Text('data')),
            ElevatedButton(
              onPressed: Base.locationTreceController.isListening.value
                  ? null
                  : Base.locationTreceController.startListening,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  Base.locationTreceController.isListening.value
                      ? Colors.grey.withValues(alpha: 0.5)
                      : Colors.green,
                ),
              ),
              child: Text(
                'Start Work',
                style: TextStyle(
                  color: Base.locationTreceController.isListening.value
                      ? Colors.grey
                      : Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: Base.locationTreceController.isListening.value
                  ? Base.locationTreceController.stopListening2
                  : null,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  !Base.locationTreceController.isListening.value
                      ? Colors.grey.withValues(alpha: 0.5)
                      : Colors.redAccent,
                ),
              ),
              child: Text(
                'Stop Work',
                style: TextStyle(
                  color: !Base.locationTreceController.isListening.value
                      ? Colors.grey
                      : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
