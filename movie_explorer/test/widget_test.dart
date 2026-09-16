import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:movie_explorer/main.dart';

void main() {
  testWidgets('Movie Explorer renders home screen', (tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(const MovieExplorerApp());
      await tester.pump();

      expect(find.text('Movie Explorer'), findsOneWidget);
      expect(find.text('Trending Now'), findsOneWidget);
      expect(find.text('Explore Categories'), findsOneWidget);
    });
  });
}
