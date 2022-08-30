import 'package:channel/utils/channel_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Channel {
  static const methodChannelName = "channel.io.flutter/channel";
  static const basicChannelName = "basic.io.flutter/basic";
  static const eventChannelName = "event.io.flutter/event";

  static final _instance = Channel._();

  factory Channel() => _instance;

  static MethodChannel? _channel;

  Channel._() {
    _channel = const MethodChannel(methodChannelName);
    _channel?.setMethodCallHandler(platformMethodHandler);
  }

  /// method_name sendMessageToNative
  /// description flutter send method to native
  /// @param [method, arguments]
  ///#return Future<dynamic>
  Future<dynamic> sendMessageToNative(String method,
      {dynamic arguments}) async {
    dynamic result = await _channel?.invokeMethod(method, arguments);
    if (kDebugMode) {
      print("$result");
    }
    return result;
  }

  /// method_name platformMethodHandler
  /// description 监听native 发送到 flutter 的  method
  /// @param [call]
  ///#return Future<dynamic>
  Future<dynamic> platformMethodHandler(MethodCall call) async {
    if (call.method == ChannelName.batteryLevel.name) {
      if (kDebugMode) {
        print("${call.arguments}");
      }
    } else if (call.method == ChannelName.getVersionName.name) {
      if (kDebugMode) {
        print("${call.arguments}");
      }
    } else {
      if (kDebugMode) {
        print("notImplemented");
      }
    }
  }
}
