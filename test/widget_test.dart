import 'package:flutter_test/flutter_test.dart';
import 'package:emun/app_widget.dart';
import 'package:emun/core/di/dependancy_manager.dart';

void main() {
  testWidgets('App loads onboarding screen', (WidgetTester tester) async {
    configureDependencies();

    await tester.pumpWidget(const AppWidget());
    await tester.pumpAndSettle();

    expect(find.text('Emun Marketplace'), findsOneWidget);
    expect(find.text('Continue as guest'), findsOneWidget);
  });
}
