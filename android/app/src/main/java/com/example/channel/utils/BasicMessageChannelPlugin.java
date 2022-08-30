package com.example.channel.utils;

import android.annotation.SuppressLint;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import com.example.channel.MainActivity;

import java.util.HashMap;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import io.flutter.Log;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.StandardMessageCodec;

/**
 * Created by Android Studio.
 * User: yufengyang
 * Date: 2022/8/25
 * Time: 14:00
 * Desc: android basic message channel impl
 */
public class BasicMessageChannelPlugin {


    public static final String BASIC_MESSAGE_CHANNEL = "basic.io.flutter/basic";
    public static final String BASIC_MESSAGE_TEST = "test";
    public static final String BASIC_MESSAGE_GET_MESSAGE = "getMessage";
    public static final String BASIC_MESSAGE_START_TIMER = "startTimer";
    public static final String BASIC_MESSAGE_CANCEL_TIMER = "cancelTimer";
    public static volatile Timer timer;

    @SuppressLint("StaticFieldLeak")
    private static volatile BasicMessageChannelPlugin sInstance;
    //    private Activity mActivity;
    public BasicMessageChannel<Object> mBasicMessageChannel;

    private BasicMessageChannelPlugin() {
//        mActivity = MainActivity.activity;
        mBasicMessageChannel = new BasicMessageChannel<Object>(MainActivity.mBinaryMessenger, BASIC_MESSAGE_CHANNEL, StandardMessageCodec.INSTANCE);
        mBasicMessageChannel.setMessageHandler(basicMessageHandler);

    }

    public static BasicMessageChannelPlugin getInstance() {
        if (null == sInstance) {
            synchronized (BasicMessageChannelPlugin.class) {
                if (null == sInstance) {
                    sInstance = new BasicMessageChannelPlugin();
                }
            }
        }
        return sInstance;
    }


    @NonNull
    public final BasicMessageChannel.MessageHandler<Object> basicMessageHandler = (message, reply) -> {
        Map<Object, Object> objectMap = (Map<Object, Object>) message;
        assert objectMap != null;
        String method = (String) objectMap.get("method");
        if (BASIC_MESSAGE_TEST.equals(method)) {
            reply.reply(message);
        } else if (BASIC_MESSAGE_GET_MESSAGE.equals(method)) {
            Map<String, Object> sendMessage = new HashMap<>();
            sendMessage.put("code", 200);
            sendMessage.put("message", "我是native 发送给 flutter 的数据");
            sendMessage.put("method", BASIC_MESSAGE_GET_MESSAGE);
            send(sendMessage);
        } else if (BASIC_MESSAGE_START_TIMER.equals(method)) {
            timer = new Timer();
            TimerTask timerTask = new TimerTask() {
                int count = 0;

                @Override
                public void run() {
                    Map<String, Object> timerCount = new HashMap<>();
                    timerCount.put("code", 200);
                    timerCount.put("message", "timer:" + count);
                    timerCount.put("method", BASIC_MESSAGE_START_TIMER);
//                    new Handler(Looper.getMainLooper()).post(() -> );
                    send(timerCount);
                    count++;
                }
            };
            timer.schedule(timerTask, 0, 1000);
        } else if (BASIC_MESSAGE_CANCEL_TIMER.equals(method)) {
            timer.cancel();
        }
    };

    /**
     * 发送信息给flutter 误会掉
     *
     * @param message
     */
    public void send(Object message) {
        new Handler(Looper.getMainLooper()).post(() -> {
            mBasicMessageChannel.send(message, reply -> {
                Log.i("flutter 回调", "==============" + reply);
            });
        });
    }

}
