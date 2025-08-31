
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';
import 'arrived.dart';

class ActiveTripScreen extends StatefulWidget {
  final String destinationLabel;
  const ActiveTripScreen({super.key, required this.destinationLabel});

  @override
  State<ActiveTripScreen> createState() => _ActiveTripScreenState();
}

class _ActiveTripScreenState extends State<ActiveTripScreen> {
  static const double DEVIATION_KM = 0.5;
  late final LocationSimulator _sim;
  late final StreamSubscription<LatLng> _sub;
  final Distance _dist = const Distance();

  final List<LatLng> _route = [
    const LatLng(28.5562, 77.1000), // IGI
    const LatLng(28.5600, 77.1200),
    const LatLng(28.5700, 77.1500),
    const LatLng(28.5900, 77.1700),
    const LatLng(28.6100, 77.1900),
    const LatLng(28.6200, 77.2000),
    const LatLng(28.6300, 77.2100),
    const LatLng(28.6350, 77.2150),
    const LatLng(28.6200, 77.2200),
    const LatLng(28.6139, 77.2090), // Connaught Place
  ];

  LatLng _pos = const LatLng(28.5562, 77.1000);
  bool _deviated = false;
  int _etaMin = 0;
  bool _simulateDeviation = false;
  final MapController _map = MapController();

  @override
  void initState() {
    super.initState();
    _sim = LocationSimulator(route: _route, speedKmh: 28);
    _etaMin = _computeETAmin(_pos);
    _sub = _sim.stream.listen((p) {
      LatLng pos = p;
      if (_simulateDeviation && _sim.progress > 0.6) {
        pos = LatLng(p.latitude, p.longitude + 0.008); // >500m east
      }
      setState(() {
        _pos = pos;
        _deviated = _nearestDistanceKm(_pos, _route) > DEVIATION_KM;
        _etaMin = _computeETAmin(_pos);
      });
      if (_sim.isArrived) {
        _onArrived();
      }
    });
    _sim.start();
  }

  @override
  void dispose() {
    _sub.cancel();
    _sim.dispose();
    super.dispose();
  }

  double _nearestDistanceKm(LatLng p, List<LatLng> poly) {
    double minM = double.infinity;
    for (final q in poly) {
      final m = _dist(p, q);
      if (m < minM) minM = m;
    }
    return minM / 1000.0;
  }

  int _computeETAmin(LatLng p) {
    double remainM = 0;
    int idx = 0;
    double best = double.infinity;
    for (int i = 0; i < _route.length; i++) {
      final m = _dist(p, _route[i]);
      if (m < best) { best = m; idx = i; }
    }
    for (int i = idx; i < _route.length - 1; i++) {
      remainM += _dist(_route[i], _route[i+1]);
    }
    const speedKmh = 28.0;
    final km = remainM / 1000.0;
    return (km / speedKmh * 60).clamp(0, 999).round();
  }

  void _onArrived() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => ArrivedScreen(destinationLabel: widget.destinationLabel),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final bannerColor = _deviated ? Colors.red : Colors.green;
    final bannerText = _deviated
        ? '⚠️ Route Deviation Detected (>500m)'
        : 'Trip Active — ${_etaMin} min ETA';

    return Scaffold(
      appBar: AppBar(title: Text('To ${widget.destinationLabel}')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: bannerColor,
            padding: const EdgeInsets.all(8),
            child: SafeArea(
              bottom: false,
              child: Text(bannerText, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _map,
              options: const MapOptions(initialCenter: LatLng(28.6139, 77.2090), initialZoom: 12),
              children: [
                TileLayer(urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', subdomains: const ['a','b','c']),
                PolylineLayer(polylines: [
                  Polyline(points: _route, color: Colors.blue, strokeWidth: 4)
                ]),
                MarkerLayer(markers: [
                  Marker(
                    point: _pos,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                  ),
                ])
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(child: Text('ETA: $_etaMin min', style: const TextStyle(fontWeight: FontWeight.w600))),
                TextButton(
                  onPressed: () => setState(() => _simulateDeviation = !_simulateDeviation),
                  child: Text(_simulateDeviation ? 'Sim Deviation: ON' : 'Sim Deviation: OFF'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('SOS sent (demo)')));
                  },
                  child: const Text('SOS'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
