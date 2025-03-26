import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow_smart_activity_tracker/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(
      find.text('Welcome to TaskFlow'),
      findsOneWidget,
    );
  });
}
