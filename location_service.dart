
import 'dart:async';
import 'package:latlong2/latlong.dart';

/// Simulated GPS stream that moves along a polyline at a constant average speed.
class LocationSimulator {
  final List<LatLng> route;
  final double speedKmh;
  final _controller = StreamController<LatLng>.broadcast();
  Timer? _timer;
  int _idx = 0;

  LocationSimulator({required this.route, this.speedKmh = 28});

  Stream<LatLng> get stream => _controller.stream;

  double get progress => _idx / (route.length - 1);
  bool get isArrived => _idx >= route.length - 1;

  void start() {
    _controller.add(route[0]);
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (_idx < route.length - 1) {
        _idx += 1;
        _controller.add(route[_idx]);
      } else {
        _timer?.cancel();
      }
    });
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
