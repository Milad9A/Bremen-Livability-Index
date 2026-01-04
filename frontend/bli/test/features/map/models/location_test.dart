import 'package:bli/features/map/models/location.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Location', () {
    const location = Location(latitude: 53.0793, longitude: 8.8017);

    test('supports value equality', () {
      expect(
        location,
        equals(const Location(latitude: 53.0793, longitude: 8.8017)),
      );
    });

    test('toJson', () {
      expect(location.toJson(), {'latitude': 53.0793, 'longitude': 8.8017});
    });

    test('fromJson', () {
      final json = {'latitude': 53.0793, 'longitude': 8.8017};
      expect(Location.fromJson(json), location);
    });
  });
}
