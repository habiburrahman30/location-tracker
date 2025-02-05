import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RingingPage extends StatefulWidget {
  const RingingPage({required this.alarmSettings, super.key});

  final AlarmSettings alarmSettings;

  @override
  State<RingingPage> createState() => _RingingPageState();
}

class _RingingPageState extends State<RingingPage> {
  StreamSubscription? _ringingSubscription;

  @override
  void initState() {
    super.initState();
    // _ringingSubscription = Alarm.ringStream.stream.listen((alarms) {
    //   if (alarms.id == widget.alarmSettings.id) return;

    //   _ringingSubscription?.cancel();
    //   if (mounted) Navigator.pop(context);
    // });
  }

  @override
  void dispose() {
    _ringingSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
    return Scaffold(
      backgroundColor: Color(0xFF190c26),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'You alarm (${widget.alarmSettings.id}) is ringing...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const Text('🔔', style: TextStyle(fontSize: 50)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                spacing: 30,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () async => Alarm.set(
                        alarmSettings: widget.alarmSettings.copyWith(
                          dateTime:
                              DateTime.now().add(const Duration(minutes: 1)),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      fillColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'Snooze',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () async =>
                          Alarm.stop(widget.alarmSettings.id),
                      fillColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'Stop',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
