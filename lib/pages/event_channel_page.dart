import 'dart:async';

import 'package:channel/utils/channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EventChannelPage extends StatefulWidget {
  const EventChannelPage({Key? key}) : super(key: key);
  static const String routeName = "eventChannelPage";

  @override
  State<EventChannelPage> createState() => _EventChannelPageState();
}

class _EventChannelPageState extends State<EventChannelPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final EventChannel _eventChannel =
      const EventChannel(Channel.eventChannelName);

  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _initEventChannel();
  }

  void _initEventChannel() {
    _streamSubscription = _eventChannel
        .receiveBroadcastStream("123456")
        .listen(_receiveMessage, onError: _onErrorMessage);
  }

  String _message = "";

  void _receiveMessage(event) {
    print("event===$event");
    setState(() {
      _message = event;
    });
  }

  void _onErrorMessage(error) {
    print("error===>$error");
  }

  @override
  void dispose() {
    _controller.dispose();
    _streamSubscription?.cancel();
    _streamSubscription = null;
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
              Text(
                _message,
                style: const TextStyle(fontSize: 14, color: Colors.lightBlue),
              ),
              ElevatedButton(
                  onPressed: () {
                    Channel().sendMessageToNative("jumpActivity");
                  },
                  child: Text("跳转原声activity"))
            ],
          ),
        ));
  }
}
