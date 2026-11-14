import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_version/main.dart';

void main() {
  testWidgets('Student authentication app starts', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: StudentAuthRiverpodApp()),
    );
    expect(find.text('Student Login'), findsOneWidget);
  });
}
