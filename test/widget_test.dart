import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_math/main.dart';

void main() {
  testWidgets('Rocket Math loads and shows button',
      (WidgetTester tester) async {

    await tester.pumpWidget(const RocketMathApp());

    expect(find.text('Test Adaptive Engine'), findsOneWidget);

    await tester.tap(find.text('Test Adaptive Engine'));
    await tester.pump();
  });
}
