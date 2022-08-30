package com.example.channel.utils;


import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;

import androidx.annotation.NonNull;

import com.example.channel.EventChannelActivity;
import com.example.channel.MainActivity;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * Created by Android Studio.
 * User: yufengyang
 * Date: 2022/8/23
 * Time: 16:26
 * Desc: android
 */
public class MethodChannelPlugin {

    public static final String METHOD_CHANNEL_NAME = "channel.io.flutter/channel";
    public static final String batteryLevel = "batteryLevel";
    public static final String getVersionName = "getVersionName";
    public static final String jumpActivity = "jumpActivity";

    @SuppressLint("StaticFieldLeak")
    private static volatile MethodChannelPlugin sInstance;
    public MethodChannel methodChannel;
    public Activity mActivity;

    public MethodChannelPlugin() {
        methodChannel = new MethodChannel(MainActivity.mBinaryMessenger, METHOD_CHANNEL_NAME);
        methodChannel.setMethodCallHandler(methodCallHandler);
        mActivity = MainActivity.activity;
    }


    public static MethodChannelPlugin getInstance() {
        if (null == sInstance) {
            synchronized (MethodChannelPlugin.class) {
                if (null == sInstance) {
                    sInstance = new MethodChannelPlugin();
                }
            }
        }
        return sInstance;
    }


    @NonNull
    public final MethodChannel.MethodCallHandler methodCallHandler = new MethodChannel.MethodCallHandler() {
        @Override
        public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
            if (batteryLevel.equals(call.method)) {
                int batteryLevel = getBatteryLevel();
                if (batteryLevel != -1) {
                    result.success(batteryLevel);
                } else {
                    result.error("404", "Battery level not available.", null);
                }
            } else if (getVersionName.equals(call.method)) {
                String versionName = getVersionName();
//                sendMessageToFlutter(getVersionName, versionName);
                result.success(versionName);
            } else if (jumpActivity.equals(call.method)) {
                mActivity.startActivity(new Intent(mActivity, EventChannelActivity.class));
                result.success("200");
            } else {
                result.notImplemented();
            }
        }
    };


    /**
     * sendMessage to flutter
     */
    public void sendMessageToFlutter(String method, Object arguments, MethodChannel.Result callback) {
        methodChannel.invokeMethod(method, arguments, callback);
    }

    /**
     * sendMessage to flutter
     */
    public void sendMessageToFlutter(String method, Object arguments) {
        methodChannel.invokeMethod(method, arguments);
    }


    /**
     * 获取电量
     *
     * @return int
     */
    private int getBatteryLevel() {
        IntentFilter filter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
        Intent receiver = mActivity.getApplicationContext().registerReceiver(null, filter);
        int batteryLevel = receiver.getIntExtra("level", 0);//获取当前电量
        return batteryLevel;
    }


    /**
     * 获取版本号
     *
     * @return String
     */
    private String getVersionName() {
        String versionName = "";
        PackageManager packageManager = mActivity.getPackageManager();
        PackageInfo packageInfo = null;
        try {
            packageInfo = packageManager.getPackageInfo(mActivity.getPackageName(), 0);
            versionName = packageInfo.versionName;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return versionName;
    }

}
