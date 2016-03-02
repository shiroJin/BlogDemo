//
//  AppDelegate.h
//  My微博
//
//  Created by Macx on 16/1/11.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, SinaWeiboDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SinaWeibo *sinaWeibo;

@end

