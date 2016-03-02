//
//  AppDelegate.m
//  My微博
//
//  Created by Macx on 16/1/11.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "RightViewController.h"
#import "MainNavCtrl.h"
#import "MMExampleDrawerVisualStateManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.window makeKeyAndVisible];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIStoryboard *right = [UIStoryboard storyboardWithName:@"Right" bundle:[NSBundle mainBundle]];
    
    UIViewController *view1 = [[UIViewController alloc] init];
    MainNavCtrl *rightCtrl = [right instantiateViewControllerWithIdentifier:@"right"];
    
    //MMDrawerCtrl 左右滑动边栏。
    MMDrawerController *drawerController = [[MMDrawerController alloc] initWithCenterViewController:[story  instantiateViewControllerWithIdentifier:@"mainTab"] leftDrawerViewController: view1 rightDrawerViewController:rightCtrl];
    
    self.window.rootViewController = drawerController;
    
    [drawerController setMaximumRightDrawerWidth:60.0];
    [drawerController setMaximumLeftDrawerWidth:70.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    
    //配置管理动画的block
    [drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];

    //新浪微博
    [self setSinaweibo];
        
    return YES;
}

- (void)setSinaweibo {
    //新浪微博。
    _sinaWeibo = [[SinaWeibo alloc] initWithAppKey:kAppkey appSecret:kSecret appRedirectURI:kAppRedirectURI andDelegate:self];
    
    //取出本地保存的认证信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        _sinaWeibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        _sinaWeibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        _sinaWeibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
}

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo {
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken,@"AccessTokenKey",
                              sinaweibo.expirationDate,@"ExpirationDateKey",
                              sinaweibo.userID,@"UserIDKey",
                              sinaweibo.refreshToken,@"refresh_token",nil];
    [[NSUserDefaults standardUserDefaults]setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults]synchronize];
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    //退出前保存主题。
    [[NSUserDefaults standardUserDefaults] setObject:[ThemeManager sharedThemeManager].themeName forKey:kThemeName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
