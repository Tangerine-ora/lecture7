/// 列表页的去程参数：用强类型对象代替 Map，编译期即可发现字段拼写错误。
class ListPageArgs {
  final String? category;
  final bool onlyPopular;

  const ListPageArgs({this.category, this.onlyPopular = false});
}
