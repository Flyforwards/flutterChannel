import 'package:flutter/widgets.dart';

/// created by yufengyang on 2022/8/23 14:41
///des 未知页面

class UnknownPage extends StatefulWidget {
  const UnknownPage({Key? key}) : super(key: key);
  static const String routeName = "unKnownPage";

  @override
  State<UnknownPage> createState() => _UnknownPageState();
}

class _UnknownPageState extends State<UnknownPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
