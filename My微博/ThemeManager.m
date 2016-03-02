//
//  ThemeManager.m
//  My微博
//
//  Created by Macx on 16/1/12.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "ThemeManager.h"

@interface ThemeManager ()

@end

@implementation ThemeManager

+ (instancetype)sharedThemeManager {
    static ThemeManager *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //self.themeName 白屏
        _themeName = kDefaultThemeName;
        
        NSString *themeName = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeName];
        if (themeName.length > 0) {
            _themeName = themeName;
        }
        
        //从plist中获取config dic
        NSString *configPath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        NSDictionary *configDic = [NSDictionary dictionaryWithContentsOfFile:configPath];
        _themeConfig = configDic;
    }
    return self;
}

- (NSString *)bundle{
    NSString *bundle = [[NSBundle mainBundle] resourcePath];
    return bundle;
}

- (void)setThemeName:(NSString *)themeName {
    if (_themeName != themeName) {
        _themeName = [themeName copy];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kThemeChangeNotifiCation object:nil];
    }
}

- (NSString *)_getThemePath {
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    NSString *theme = [_themeConfig objectForKey:_themeName];
    NSString *themePath = [bundlePath stringByAppendingPathComponent:theme];
    
    return themePath;
}

- (UIImage *)getThemeImg:(NSString *)imgName {
    
    if (imgName == nil) {
        return nil;
    }
    
    NSString *themePath = [self _getThemePath];
    NSString *imgPath = [themePath stringByAppendingPathComponent:imgName];
    UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
    
    return img;
}

- (NSDictionary *)_getColorConfig {
    NSString *themePath = [self _getThemePath];
    NSString *configPath = [themePath stringByAppendingPathComponent:@"config.plist"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:configPath];
    return dic;
}

- (UIColor *)getThemeColor {
    NSDictionary *dic = [self _getColorConfig];
    NSDictionary *colorDic = [dic objectForKey:@"Mask_Title_color"];
    CGFloat R = [[colorDic objectForKey:@"R"] floatValue];
    CGFloat G = [[colorDic objectForKey:@"G"] floatValue];
    CGFloat B = [[colorDic objectForKey:@"B"] floatValue];
    CGFloat alpha = [[colorDic objectForKey:@"alpha"] floatValue];
    
    if ([colorDic objectForKey:@"alpha"] == nil) {
        alpha = 1;
    }
    
    UIColor *color = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:alpha];
    return color;
}

@end
