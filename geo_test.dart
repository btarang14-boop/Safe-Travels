
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

double haversineKm(LatLng a, LatLng b) {
  final d = const Distance();
  return d(a, b) / 1000.0;
}

double nearestDistanceToRouteKm(LatLng p, List<LatLng> poly) {
  final d = const Distance();
  double minM = double.infinity;
  for (final q in poly) {
    final m = d(p, q);
    if (m < minM) minM = m;
  }
  return minM / 1000.0;
}

void main() {
  final A = const LatLng(28.5562, 77.1);      // IGI
  final B = const LatLng(28.6139, 77.209);    // CP
  final route = <LatLng>[
    A,
    const LatLng(28.59, 77.17),
    B,
  ];

  test('haversine identical points ~ 0', () {
    expect(haversineKm(A, A) < 0.001, true);
  });

  test('IGI→CP plausible distance', () {
    final dAB = haversineKm(A, B);
    expect(dAB > 10 && dAB < 30, true);
  });

  test('nearest distance on-route ≈ 0', () {
    expect(nearestDistanceToRouteKm(route[1], route) < 0.05, true);
  });

  test('nearest distance off-route > 0.5 km', () {
    final off = LatLng(route[1].latitude, route[1].longitude + 0.01);
    expect(nearestDistanceToRouteKm(off, route) > 0.5, true);
  });

  test('symmetric haversine', () {
    expect((haversineKm(A,B) - haversineKm(B,A)).abs() < 1e-6, true);
  });
}
