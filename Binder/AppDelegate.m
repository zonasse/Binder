//
//  AppDelegate.m
//  Bullet
//
//  Created by 钟奇龙 on 16/8/27.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "AppDelegate.h"
#import "BTSignInViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager] ;
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                [MBProgressHUD showError:@"当前无网络"];
 
          break;

           case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                [MBProgressHUD showSuccess:@"当前3G/4G网络,请注意流量"];
             break;

          case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                [MBProgressHUD showSuccess:@"当前Wifi在线"];

                break;
       }
    }];
        //检测网络
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];

    
    
    //1.主窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [[UIScreen mainScreen] bounds];
    [self.window makeKeyAndVisible];
    [Bmob registerWithAppKey:@"54418c45f9c12443dc06cf3c4cf4514b"];
    

    
    //2.检测用户是否已登录
    if ([BmobUser currentUser]) {
            //加载KindleAssistant控制器
        //加载单项控制器
        BTKindleAssistantFatherViewController *fatherVC = [[BTKindleAssistantFatherViewController alloc]init];
        
        UIStoryboard *signInAndUpSB = [UIStoryboard storyboardWithName:@"BTSignInAndUpStoryboard" bundle:nil];
        
         BTProfileViewController *profileVC = [signInAndUpSB instantiateViewControllerWithIdentifier:@"profile"];
        UINavigationController *profileVCNAV = [[UINavigationController alloc] initWithRootViewController:profileVC];
       
        
        self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:fatherVC leftDrawerViewController:profileVCNAV];
        self.drawerController.view.backgroundColor = [UIColor whiteColor];
        [self.drawerController setShowsShadow:YES]; // 是否显示阴影效果
        self.drawerController.maximumLeftDrawerWidth = UIScreenWidth * 7/8; // 左边拉开的最大宽度
        [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        self.window.backgroundColor = [UIColor whiteColor];
        
        self.window.rootViewController = self.drawerController;

    }else{
        //加载登录注册界面
        UIStoryboard *signInAndUpSB = [UIStoryboard storyboardWithName:@"BTSignInAndUpStoryboard" bundle:nil];
        BTSignInViewController *signInVC = signInAndUpSB.instantiateInitialViewController;
        self.window.rootViewController = signInVC;
        
       
    }
    
   return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager] ;
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                [MBProgressHUD showError:@"当前无网络"];
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                [MBProgressHUD showSuccess:@"当前3G/4G网络,请注意流量"];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                [MBProgressHUD showSuccess:@"当前Wifi在线"];
                
                break;
        }
    }];
    //检测网络
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    

    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    //网络监听中断
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager] ;
    [manager stopMonitoring];
}



@end
