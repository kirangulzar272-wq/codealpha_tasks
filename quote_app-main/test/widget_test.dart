import 'package:flutter_test/flutter_test.dart';
import 'package:my_quote_app/main.dart';

void main() {
  testWidgets('Quote Generator App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const QuoteGeneratorApp());
    expect(find.byType(QuoteGeneratorApp), findsOneWidget);
  });
}
