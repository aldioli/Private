import 'package:flutter_test/flutter_test.dart';
import 'package:yemenpay/main.dart';

void main() {
  testWidgets('YemenPay app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const YemenPayApp());
    expect(find.byType(YemenPayApp), findsOneWidget);
  });
}
