package com.example.channel;

import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.example.channel.utils.BasicMessageChannelPlugin;
import com.example.channel.utils.EventChannelPlugin;
import com.example.channel.utils.MethodChannelPlugin;

import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;

public class MainActivity extends FlutterActivity {

    public static MainActivity activity;
    public static BinaryMessenger mBinaryMessenger;
    private BasicMessageChannel<Object> mBasicMessageChannel;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        activity = this;

    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        activity = this;
        mBinaryMessenger = flutterEngine.getDartExecutor().getBinaryMessenger();
        MethodChannelPlugin.getInstance();
        BasicMessageChannelPlugin.getInstance();
        EventChannelPlugin.registerWith(mBinaryMessenger);
    }


}
