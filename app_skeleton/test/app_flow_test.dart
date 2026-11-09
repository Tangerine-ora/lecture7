import 'package:app_skeleton/data/book_repository.dart';
import 'package:app_skeleton/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await BookRepository.instance.load();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const BookApp());
    await tester.pumpAndSettle();
  }

  testWidgets('首页 → 列表 → 详情 → 回传闭环', (tester) async {
    await pumpApp(tester);

    expect(find.text('书架首页'), findsOneWidget);

    await tester.tap(find.text('计算机').first);
    await tester.pumpAndSettle();
    expect(find.text('计算机书单'), findsOneWidget);
    expect(find.text('已加载 15/15'), findsOneWidget);

    await tester.tap(find.text('Flutter实战').first);
    await tester.pumpAndSettle();
    expect(find.text('图书详情'), findsOneWidget);
    expect(find.text('作者：奇舞团'), findsOneWidget);

    await tester.tap(find.text('返回并带回浏览结果'));
    await tester.pumpAndSettle();
    expect(find.textContaining('详情页回传'), findsOneWidget);
  });

  testWidgets('加载更多每次追加 20 条', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('全部书目'));
    await tester.pumpAndSettle();
    expect(find.text('已加载 20/60'), findsOneWidget);

    await tester.tap(find.text('加载更多（每次 20 条）').last);
    await tester.pumpAndSettle();
    expect(find.text('已加载 40/60'), findsOneWidget);
  });

  testWidgets('列表长按弹层，选择结果回传首页副标题', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('计算机').first);
    await tester.pumpAndSettle();

    await tester.longPress(find.text('Flutter实战').first);
    await tester.pumpAndSettle();
    expect(find.text('《Flutter实战》快捷筛选'), findsOneWidget);

    await tester.tap(find.text('仅看高借阅量（≥20 次）'));
    await tester.pumpAndSettle();
    expect(find.text('回传：仅看高借阅量（≥20 次）'), findsOneWidget);
  });
}
