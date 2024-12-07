import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

//Jonas
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Monitor de Temperatura',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TemperatureMonitor(),
    );
  }
}

class TemperatureMonitor extends StatefulWidget {
  const TemperatureMonitor({super.key});

  @override
  State<TemperatureMonitor> createState() => _TemperatureMonitorState();
}

class _TemperatureMonitorState extends State<TemperatureMonitor> {
  double _temperature = 0.0;
  bool _isLedOn = false;
  late Timer _updateTimer;
  late Timer _countdownTimer;
  int _timeLeft = 30; // Tempo em segundos para a próxima atualização

  @override
  void initState() {
    super.initState();
    _startTemperatureUpdates();
    _startCountdown();
  }

  @override
  void dispose() {
    _updateTimer.cancel();
    _countdownTimer.cancel();
    super.dispose();
  }

  double _simulateTemperature() {
    Random random = Random();
    return 20 + random.nextDouble() * 30;
  }

  void _startTemperatureUpdates() {
    _updateTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _updateTemperature();
    });
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        setState(() {
          _timeLeft = 30;
        });
      }
    });
  }

  void _updateTemperature() {
    double newTemperature = _simulateTemperature();
    setState(() {
      _temperature = newTemperature;
      _isLedOn = _temperature > 45.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitor de Temperatura'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Temperatura atual: ${_temperature.toStringAsFixed(1)}°C',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Icon(
              Icons.lightbulb,
              color: _isLedOn ? Colors.yellow : Colors.grey,
              size: 100,
            ),
            const SizedBox(height: 20),
            Text(
              'Próxima atualização em: $_timeLeft segundos',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _updateTemperature();
                  _timeLeft = 30;
                });
              },
              child: const Text('Atualizar Manualmente'),
            ),
          ],
        ),
      ),
    );
  }
}