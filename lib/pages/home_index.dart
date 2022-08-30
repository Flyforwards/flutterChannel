import 'package:channel/utils/channel.dart';
import 'package:channel/utils/channel_name.dart';
import 'package:flutter/material.dart';

class HomeIndex extends StatefulWidget {
  const HomeIndex({Key? key}) : super(key: key);
  static const String routeName = "homeIndex";

  @override
  State<HomeIndex> createState() => _HomeIndexState();
}

class _HomeIndexState extends State<HomeIndex>
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

  int _batteryLevel = 0;
  String _versionName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("homeIndex"),
        ),
        body: Center(
          child: Column(
            children: [
              Text("$_batteryLevel"),
              ElevatedButton(
                  onPressed: () async {
                    int result = await Channel().sendMessageToNative(ChannelName.batteryLevel.name)??0;
                    setState(() {
                      _batteryLevel = result;
                    });
                  },
                  child: const Text("获取电量")),

              Text(_versionName),
              ElevatedButton(
                  onPressed: () async {
                    String result = await Channel().sendMessageToNative(ChannelName.getVersionName.name)??"";
                    setState(() {
                      _versionName = result;
                    });
                  },
                  child: const Text("获取版本号")),


            ],
          ),
        ));
  }
}
