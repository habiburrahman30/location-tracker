import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? _timer;
  int _remainingTime = 0; // Time in seconds
  bool _isRunning = false;
  DateTime? _startTime;
  final int _maxDuration = 9 * 3600; // 9 hours in seconds

  void _startTimer() {
    if (!_isRunning) {
      setState(() {
        _isRunning = true;
        _startTime = DateTime.now(); // Record the start time
      });
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingTime < _maxDuration) {
            _remainingTime++; // Increment the time every second
          } else {
            _stopTimer(); // Stop the timer when it reaches the max duration
          }
        });
      });
    }
  }

  void _stopTimer() {
    if (_isRunning) {
      setState(() {
        _isRunning = false;
      });
      _timer?.cancel();
    }
  }

  void _resetTimer() {
    setState(() {
      _remainingTime = 0; // Reset the time to 0
      _startTime = null; // Clear the start time
    });
    _stopTimer();
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  double _calculateProgress() {
    return _remainingTime / _maxDuration; // Progress as a value between 0 and 1
  }

  String _calculatePercentage() {
    double progress = _calculateProgress();
    return '${(progress * 100).toStringAsFixed(1)}%';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Count-Up Timer with Progress Bar',
              style: TextStyle(fontSize: 20),
            ),
            Card(
              margin: EdgeInsets.all(20),
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  children: [
                    if (_startTime != null)
                      Text(
                        'Started at: ${DateFormat('hh:mm:ss a').format(_startTime!)}',
                        // 'Started at: ${_startTime!.hour}:${_startTime!.minute}:${_startTime!.second}',
                        style: TextStyle(fontSize: 18),
                      ),
                    SizedBox(height: 5),
                    Text(
                      'Elapsed Time: ${_formatTime(_remainingTime)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Progress: ${_calculatePercentage()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        value: _calculateProgress(),
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        backgroundColor: Colors.grey[300],
                        minHeight: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startTimer,
                  child: Text('Start'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _stopTimer,
                  child: Text('Stop'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
