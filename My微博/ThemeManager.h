//
//  ThemeManager.h
//  My微博
//
//  Created by Macx on 16/1/12.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ThemeManager : NSObject

@property (copy, nonatomic)NSString *themeName;
@property (copy, nonatomic)NSDictionary *themeConfig;

+ (instancetype)sharedThemeManager;
- (UIImage *)getThemeImg:(NSString *)imgName;
- (UIColor *)getThemeColor;

@end
