//
//  Channel.swift
//  Runner
//
//  Created by yufengyang on 2022/8/26.
//

import Foundation
import Flutter

public class Channel {
    
    static var methodChannelName = "channel.io.flutter/channel";
    static var basicChannelName = "basic.io.flutter/basic";
    static var eventChannelName = "event.io.flutter/event";
    static var batteryLevel = "batteryLevel";
    static var getVersionName = "getVersionName";
    
    var channel: FlutterMethodChannel?;
    
    static let shareInstance = Channel();
    
    var binaryMessager: FlutterBinaryMessenger?;
    
    private init(){
        
    }
    
    func initMethodChannel(binaryMessager: FlutterBinaryMessenger){
        self.binaryMessager = binaryMessager;
        channel = FlutterMethodChannel(name: Channel.methodChannelName, binaryMessenger: binaryMessager);
        initMethodChannelHandler();
    }
    
    func initMethodChannelHandler(){
        channel?.setMethodCallHandler{ (call: FlutterMethodCall, result: @escaping FlutterResult)in
            if(call.method == Channel.batteryLevel) {
                self.getBatteryLevel(result: result);
            }else if(call.method == Channel.getVersionName){
                let versionName = self.getVersionName();
                result(versionName);
            }else{
                result(FlutterMethodNotImplemented);
            }
        }
        
    }
    
    
    private func getBatteryLevel(result: FlutterResult){
        let device = UIDevice.current;
        device.isBatteryMonitoringEnabled = true;
        if device.batteryState == UIDevice.BatteryState.unknown{
            result(FlutterError(code: "UNAVAILABLE", message: "Battery level not available.", details: nil))
        }else {
            result(Int(device.batteryLevel*100));
        }
    }
    
    
    private func getVersionName() -> String{
        var localVersion: String = "";
        if let v:String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString" )as? String{
            localVersion = v;
        }
        return localVersion;
    }
    
    
}
