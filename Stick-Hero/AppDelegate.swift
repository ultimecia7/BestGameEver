//
//  AppDelegate.swift
//  Stick-Hero
//
//  Created by 顾枫 on 15/6/19.
//  Copyright © 2015年 koofrank. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate{

    var window: UIWindow?
    
    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
            // 注册app(这里随便取个名字)
            WXApi.registerApp("hangge_appid")
            return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
    }
    
    func applicationWillTerminate(application: UIApplication) {
    }
    
    //微信分享完毕后的回调（只有使用真实的AppID才能收到响应）
    func onResp(resp: BaseResp!) {
        if resp.isKindOfClass(SendMessageToWXResp){//确保是对我们分享操作的回调
            if resp.errCode == WXSuccess.rawValue{//分享成功
                NSLog("分享成功")
            }else{//分享失败
                NSLog("分享失败，错误码：%d, 错误描述：%@", resp.errCode, resp.errStr)
            }
        }
    }

}

