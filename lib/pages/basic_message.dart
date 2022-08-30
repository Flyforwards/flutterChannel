import 'package:channel/utils/channel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BasicMessage extends StatefulWidget {
  const BasicMessage({Key? key}) : super(key: key);
  static const String routeName = "BasicMessage";

  @override
  State<BasicMessage> createState() => _BasicMessageState();
}

class _BasicMessageState extends State<BasicMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  //创建 BasicMessageChannel
  // flutter_and_native_100 为通信标识
  // StandardMessageCodec() 为参数传递的 编码方式
  final BasicMessageChannel messageChannel = const BasicMessageChannel(
      Channel.basicChannelName, StandardMessageCodec());

  static const String getMessage = "getMessage";
  static const String startTimer = "startTimer";
  static const String cancelTimer = "cancelTimer";

  String _count = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    initBasicMessageHandler();
  }

  String _basicMessage = "";
  String _basicMessageFromNative = "";

  void initBasicMessageHandler() {
    messageChannel.setMessageHandler((result) async {
      if (kDebugMode) {
        print("result===$result");
      }
      int code = result["code"];
      String message = result["message"];
      String method = result["method"];
      if (method == getMessage) {
        setState(() {
          _basicMessageFromNative = "$code: $message";
        });
      } else if (method == startTimer) {
       setState(() {
         _count = message;
       });
      }

      return "flutter 收到消息";
    });
  }

  Future<Map> sendMessage(Map arguments) async {
    Map? reply = (await messageChannel.send(arguments)) as Map?;
    int code = reply!["code"];
    String message = reply["message"];
    setState(() {
      _basicMessage = "$code $message";
    });
    return reply;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("basicMessageChannel"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 在这里约定的数据格式为 {"code":100,"message":"消息","content":内容}
              //     也就是说双向发送消息，可能会有多种消息类型来调用不同的功能，
              //     统一约定数据格式 可以达到编码的规范性和代码的可维护性
              Text(
                _basicMessage,
                style: const TextStyle(fontSize: 12, color: Colors.lightBlue),
              ),
              ElevatedButton(
                  onPressed: () async {
                    Map reply = await sendMessage({
                      "method": "test",
                      "message": "flutter 发送消息到native",
                      "code": 100
                    });
                  },
                  child: const Text("flutter 发送 到 native")),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  _basicMessageFromNative,
                  style: const TextStyle(fontSize: 12, color: Colors.lightBlue),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    Map reply = await sendMessage({
                      "method": "getMessage",
                      "message": "flutter get native message",
                      "code": 100
                    });
                  },
                  child: const Text("flutter 获取 native 信息")),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  _count,
                  style: const TextStyle(fontSize: 12, color: Colors.lightBlue),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    Map reply = await sendMessage({
                      "method": startTimer,
                      "message": "startTimer",
                      "code": 100
                    });
                  },
                  child: const Text("开启定时器")),
              ElevatedButton(
                  onPressed: () async {
                    Map reply = await sendMessage({
                      "method": cancelTimer,
                      "message": "cancelTimer",
                      "code": 100
                    });
                  },
                  child: const Text("取消定时器"))
            ],
          ),
        ));
  }
}
