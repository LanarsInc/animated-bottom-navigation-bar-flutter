import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('renders inside material_ui Scaffold with centerDocked FAB and handles taps', (tester) async {
    var activeIndex = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              body: const SizedBox.expand(),
              floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: AnimatedBottomNavigationBar(
                icons: const [Icons.home, Icons.search, Icons.favorite, Icons.person],
                activeIndex: activeIndex,
                gapLocation: GapLocation.center,
                notchSmoothness: NotchSmoothness.softEdge,
                onTap: (index) => setState(() => activeIndex = index),
              ),
            );
          },
        ),
      ),
    );

    expect(find.byType(AnimatedBottomNavigationBar), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);

    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    expect(activeIndex, 3);
  });

  testWidgets('renders AnimatedBottomNavigationBar.builder inside material_ui Scaffold', (tester) async {
    var activeIndex = 1;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.shopping_cart)),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar.builder(
            itemCount: 3,
            activeIndex: activeIndex,
            gapLocation: GapLocation.end,
            tabBuilder: (index, isActive) => Center(child: Text('tab_$index')),
            onTap: (index) => activeIndex = index,
          ),
        ),
      ),
    );

    expect(find.text('tab_0'), findsOneWidget);
    expect(find.text('tab_1'), findsOneWidget);
    expect(find.text('tab_2'), findsOneWidget);

    await tester.tap(find.text('tab_2'));
    await tester.pump();

    expect(activeIndex, 2);
  });
}
