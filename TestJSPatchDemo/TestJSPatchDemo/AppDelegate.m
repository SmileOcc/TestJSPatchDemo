//
//  AppDelegate.m
//  TestJSPatchDemo
//
//  Created by occ on 2017/2/8.
//  Copyright © 2017年 occ. All rights reserved.
//

#import "AppDelegate.h"

//hot
#import <JSPatchPlatform/JSPatch.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //[self hotJSPatch];
    
    //本地测试
    [self hotLocalJSPatch];

    return YES;
}


- (void)hotJSPatch {
    

    //传入在平台申请的 appKey。会自动执行已下载到本地的 patch 脚本。
    [JSPatch startWithAppKey:@"c38c725a42102b45"];
    
    
    /*
     定义用户属性
     用于条件下发，例如:
     [JSPatch setupUserData:@{@"userId": @"100867", @"location": @"guangdong"}];
     在 `+sync:` 之前调用
     */
    //[JSPatch setupUserData:@{@"userId": @"1000876", @"isMale": @(1)}];
    
    /*
     事件回调
     type: 事件类型，详见 JPCallbackType 定义
     data: 回调数据
     error: 事件错误
     在 `+startWithAppKey:` 之前调用
     */
    
    [JSPatch setupCallback:^(JPCallbackType type, NSDictionary *data, NSError *error) {
        switch (type) {
            case JPCallbackTypeUnknow:
                NSLog(@"*****");
                break;
            case JPCallbackTypeRunScript:
                NSLog(@"执行脚本");
                break;
            case JPCallbackTypeUpdate:
                NSLog(@"已拉取新脚本");
                break;
            case JPCallbackTypeCondition:
                NSLog(@"条件下发");
                break;
            case JPCallbackTypeGray:
                NSLog(@"灰度下发");
                break;
            default:
                break;
        }
    }];
    
    [JSPatch setupLogger:^(NSString *msg) {
        NSLog(@"jspatch log: %@",msg);
    }];
    
    
    
#ifdef DEBUG
    
    /*
     进入开发模式
     平台下发补丁时选择开发预览模式，会只对调用了这个方法的客户端生效。
     在 `+sync:` 之前调用，建议在 #ifdef DEBUG 里调。
     */
    
    [JSPatch setupDevelopment];
#endif
    
    /*
     与 JSPatch 平台后台同步，
     发请求询问后台是否有 patch 更新，如果有更新会自动下载并执行
     可调用多次（App启动时调用或App唤醒时调）
     */
    [JSPatch sync];
    
    
    /*
     设置在线参数请求完成的回调
     */
    [JSPatch setupUpdatedConfigCallback:^(NSDictionary *configs, NSError *error) {
        NSLog(@"---- %@",configs);
    }];
    
    
    /*
     获取已缓存在本地的所有在线参数
     */
    NSDictionary *dic =  [JSPatch getConfigParams];
    NSLog(@"---- %@",dic);

    /*
     在状态栏显示调试按钮，点击可以看到所有 JSPatch 相关的 log 和内容
     */
    [JSPatch showDebugView];
}


- (void) hotLocalJSPatch {
    
    //    用于发布前测试脚本
    //    测试完成后请删除，改为调用 +startWithAppKey: 和 +sync
    
    //加载本地js调试
    [JSPatch testScriptInBundle];
    
    //在状态栏显示调试按钮，点击可以看到所有 JSPatch 相关的 log 和内容

    [JSPatch showDebugView];

}







- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
