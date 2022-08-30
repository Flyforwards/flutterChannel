package com.example.channel.utils;

import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;

/**
 * Created by Android Studio.
 * User: yufengyang
 * Date: 2022/8/26
 * Time: 16:18
 * Desc: android
 */
public class EventChannelPlugin implements EventChannel.StreamHandler {

    public static final String EVENT_CHANNEL = "event.io.flutter/event";

    public static EventChannel.EventSink eventSink;


    public static EventChannelPlugin registerWith(BinaryMessenger binaryMessenger) {
        EventChannelPlugin plugin = new EventChannelPlugin();
        new EventChannel(binaryMessenger, EVENT_CHANNEL).setStreamHandler(plugin);
        return plugin;
    }

    /**
     * 发送消息
     *
     * @param params
     */
    public static void send(Object params) {
        if (eventSink != null) {
            eventSink.success(params);
        }
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        Log.i("eventChannel===", arguments.toString());
        eventSink = events;
//        events.success("1234567");
    }

    @Override
    public void onCancel(Object arguments) {
        eventSink.endOfStream();
        eventSink = null;
    }
}
